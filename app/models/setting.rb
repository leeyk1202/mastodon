# frozen_string_literal: true
# == Schema Information
#
# Table name: settings
#
#  var        :string           not null
#  value      :text
#  thing_type :string
#  created_at :datetime
#  updated_at :datetime
#  id         :integer          not null, primary key
#  thing_id   :integer
#

class Setting < RailsSettings::Base
  source Rails.root.join('config', 'settings.yml')

  def to_param
    var
  end

  class << self
    def [](key)
      return super(key) unless rails_initialized?

      val = Rails.cache.fetch(cache_key(key, nil)) do
        db_val = object(key)

        if db_val
          default_value = default_settings[key]

          return default_value.with_indifferent_access.merge!(db_val.value) if default_value.is_a?(Hash)
          db_val.value
        else
          default_settings[key]
        end
      end
      val
    end

    def all_as_records
      vars    = thing_scoped
      records = vars.map { |r| [r.var, r] }.to_h

      default_settings.each do |key, default_value|
        next if records.key?(key) || default_value.is_a?(Hash)
        records[key] = Setting.new(var: key, value: default_value)
      end

      records
    end

    def default_settings
      return {} unless RailsSettings::Default.enabled?
      RailsSettings::Default.instance
    end

    def registrations_open?(key = nil)
      return true if Setting.registrations_status == 'open'
      return true if Setting.registrations_status == 'keyed' && key == Setting.registration_key
      false
    end
  end
end
