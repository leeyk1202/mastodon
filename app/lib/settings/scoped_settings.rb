# frozen_string_literal: true

module Settings
  class ScopedSettings
    def initialize(object)
      @object = object
    end

    # rubocop:disable Style/MethodMissing
    def method_missing(method, *args)
      method_name = method.to_s
      # set a value for a variable
      if method_name[-1] == '='
        var_name = method_name.sub('=', '')
        value = args.first
        self[var_name] = value
      else
        # retrieve a value
        self[method_name]
      end
    end
    # rubocop:enable Style/MethodMissing

    def respond_to?(_method_name, _include_private = false)
      true
    end

    def all_as_records
      vars = thing_scoped
      records = vars.map { |r| [r.var, r] }.to_h

      Setting.default_settings.each do |key, default_value|
        next if records.key?(key) || default_value.is_a?(Hash)
        records[key] = Setting.new(var: key, value: default_value)
      end

      records
    end

    def []=(key, value)
      key = key.to_s
      record = thing_scoped.find_by(var: key) || thing_scoped.new(var: key)
      record.value = value
      record.save!

      Rails.cache.write(Setting.cache_key(key, @object), value)
      value
    end

    def [](key)
      Rails.cache.fetch(Setting.cache_key(key, @object)) do
        db_val = thing_scoped.find_by(var: key.to_s)
        if db_val
          default_value = Setting.default_settings[key]
          return default_value.with_indifferent_access.merge!(db_val.value) if default_value.is_a?(Hash)
          db_val.value
        else
          Setting.default_settings[key]
        end
      end
    end

    protected

    def thing_scoped
      Setting.unscoped.where(thing_type: @object.class.base_class.to_s, thing_id: @object.id)
    end
  end
end
