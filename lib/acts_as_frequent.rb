require "acts_as_frequent/version"

module ActsAsFrequent
  extend ActiveSupport::Concern

  included do
    has_one :schedule, as: :schedulable, dependent: :destroy
  end

  module ClassMethods
  end

  module InstanceMethods
  end
end

path = File.join(File.dirname(__FILE__), 'acts_as_frequent/schedule.rb')
$LOAD_PATH << path
ActiveSupport::Dependencies.autoload_paths << path
