class Schedule
  include Mongoid::Document
  
  belongs_to :schedulable, polymorphic: true
  
  field :frequency_value, type: Integer
  field :frequency_unit, type: String
  field :last_occurrence, type: DateTime
  field :start_time, type: DateTime
  field :end_time, type: DateTime
  field :duration, type: Integer

  field :days, type: String
  field :months, type: String

  cattr_reader :FREQUENCY_UNIT
  @@FREQUENCY_UNIT = { days: 'days', months: 'months', weeks: 'weeks', years: 'years' }
  @@FREQUENCY_UNIT.freeze

  cattr_reader :DAYS
  @@DAYS = { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }
  @@DAYS.freeze

  cattr_reader :MONTHS
  @@MONTHS = { january: 1, february: 2, march: 3, april: 4, may: 5, june: 6, july: 7, august: 8, september: 9, october: 10, november: 11, december: 12 }
  @@MONTHS.freeze

  before_create :set_last_occurrence
  before_save :parse_days #, :parse_months

  def next_occurrences(num)
    update_last_occurrence

    results = []
    count = 0

    occurrence = last_occurrence.past? ? next_occurrence(last_occurrence) : last_occurrence
    while count < num
      results << occurrence
      occurrence = next_occurrence(occurrence)
      count += 1
    end

    results
  end

  def next_occurrence(*args)
    if args.size == 0
      next_occurrences(1)
    elsif args.size == 1
      _occurrence = args.first

      if days.present? # Re-occurrence on specific days of week
        allowed_days = days.split(',').map(&:to_i)

        _occurrence += 1.day
        while allowed_days.include?(_occurrence.wday) == false
          _occurrence += 1.day
        end
        _occurrence
      else
        _occurrence += frequency_value.send(frequency_unit)
      end
    else
      raise "wrong number of arguments #{args.size} for 1"
    end
  end

  def prev_occurrences(num)
    update_last_occurrence

    results = []
    count = 0

    occurrence = last_occurrence.past? ? last_occurrence : prev_occurrence(last_occurrence)
    while count < num
      results << occurrence
      occurrence = prev_occurrence(occurrence)
      count += 1
    end

    results
  end

  def prev_occurrence(*args)
    if args.size == 0
      prev_occurrences(1)
    elsif args.size == 1
      _occurrence = args.first
      _occurrence -= frequency_value.send(frequency_unit)
    else
      raise "wrong number of arguments #{args.size} for 1"
    end
  end

  private
  
  def set_last_occurrence
    if start_time.present?
      self.last_occurrence = start_time
    else
      self.last_occurrence = DateTime.now
    end
  end

  def update_last_occurrence
    unless last_occurrence.future?
      _next_occurrence = last_occurrence

      while next_occurrence(_next_occurrence).past?
        _next_occurrence = next_occurrence(_next_occurrence)
      end

      update_attribute(:last_occurrence, _next_occurrence)
    end
  end

  # Possible inputs
  # days = :weekday OR weekday
  # days = :weekend OR weekend
  # days = sunday,monday,tuesday etc
  def parse_days
    return if days.blank?
    string = days.to_s.downcase

    if string.index('weekday').present? && string.index('weekend').present?
      timing = nil
    elsif string.index('weekday').present?
      timing = '1,2,3,4,5'
    elsif string.index('weekend').present?
      timing = '6,0'
    else
      timing = []
      %w(sunday monday tuesday wednesday thursday friday saturday).each_with_index do |day, i|
        timing << i if string.index(day).present? 
      end
      %w(sun mon tue wed thu fri sat).each_with_index do |day, i|
        timing << i if string.index(day).present? 
      end
      %w(0 1 2 3 4 5 6).each_with_index do |day, i|
        timing << i if string.index(day).present? 
      end

      timing = timing.uniq.join(',')  
    end
    self.days = timing.present? ? timing : nil
  end

  # Possible inputs
  # months = [:january, :february, :march] etc
  def parse_months
    raise 'Implementation Pending'
  end
end