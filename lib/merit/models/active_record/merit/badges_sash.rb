module Merit
  class BadgesSash < ActiveRecord::Base
    include Base::BadgesSash
    has_many :activity_logs,
      class_name: Merit::ActivityLog,
      as: :related_change

    unless defined?(ActionController::StrongParameters)
      attr_accessible :badge_id
    end

    def self.last_granted(options = {})
      options[:since_date] ||= 1.month.ago
      options[:limit]      ||= 10
      where("created_at > '#{options[:since_date]}'").
        limit(options[:limit]).
        map(&:badge)
    end
  end
end
