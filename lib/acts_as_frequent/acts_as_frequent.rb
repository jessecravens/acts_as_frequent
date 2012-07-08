module ActsAsFrequent
  extend ActiveSupport::Concern

  included do
    has_one :schedule, as: :schedulable, dependent: :destroy

    %w(start_time end_time duration last_occurrence next_occurrences next_occurrence prev_occurrences prev_occurrence).each do |method|
      delegate method.to_sym, to: :schedule
    end
  end
end