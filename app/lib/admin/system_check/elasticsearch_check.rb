# frozen_string_literal: true

class Admin::SystemCheck::ElasticsearchCheck < Admin::SystemCheck::BaseCheck
  INDEXES = [
    InstancesIndex,
    AccountsIndex,
    TagsIndex,
    StatusesIndex,
  ].freeze

  def skip?
    !current_user.can?(:view_devops)
  end

  def pass?
    return true unless Chewy.enabled?

    running_version.present? && compatible_version? && cluster_health['status'] == 'green' && indexes_match?
  end

  def message
    if running_version.blank?
      Admin::SystemCheck::Message.new(:elasticsearch_running_check)
    elsif !compatible_version?
      Admin::SystemCheck::Message.new(
        :elasticsearch_version_check,
        I18n.t(
          'admin.system_checks.elasticsearch_version_check.version_comparison',
          running_version: running_version,
          required_version: required_version
        )
      )
    elsif !indexes_match?
      Admin::SystemCheck::Message.new(
        :elasticsearch_index_mismatch,
        mismatched_indexes.join(' ')
      )
    elsif cluster_health['status'] == 'red'
      Admin::SystemCheck::Message.new(:elasticsearch_health_red)
    else
      Admin::SystemCheck::Message.new(:elasticsearch_health_yellow)
    end
  end

  private

  def cluster_health
    @cluster_health ||= Chewy.client.cluster.health
  end

  def running_version
    @running_version ||= begin
      Chewy.client.info['version']['number']
    rescue Faraday::ConnectionFailed, Elasticsearch::Transport::Transport::Error
      nil
    end
  end

  def compatible_wire_version
    Chewy.client.info['version']['minimum_wire_compatibility_version']
  end

  def required_version
    '7.x'
  end

  def compatible_version?
    return false if running_version.nil?

    Gem::Version.new(running_version) >= Gem::Version.new(required_version) ||
      Gem::Version.new(compatible_wire_version) >= Gem::Version.new(required_version)
  end

  def mismatched_indexes
    @mismatched_indexes ||= INDEXES.filter_map do |klass|
      klass.index_name if Chewy.client.indices.get_mapping[klass.index_name]&.deep_symbolize_keys != klass.mappings_hash
    end
  end

  def indexes_match?
    mismatched_indexes.empty?
  end
end
