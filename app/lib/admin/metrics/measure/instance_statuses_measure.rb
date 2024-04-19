# frozen_string_literal: true

class Admin::Metrics::Measure::InstanceStatusesMeasure < Admin::Metrics::Measure::BaseMeasure
  include Admin::Metrics::Measure::QueryHelper

  def self.with_params?
    true
  end

  def key
    'instance_statuses'
  end

  def total_in_time_range?
    false
  end

  protected

  def perform_total_query
    domain = params[:domain]
    domain = Instance.by_domain_and_subdomains(params[:domain]).select(:domain) if params[:include_subdomains]
    Status.joins(:account).merge(Account.where(domain: domain)).count
  end

  def perform_previous_total_query
    nil
  end

  def sql_array
    [sql_query_string, { start_at: @start_at, end_at: @end_at, domain: params[:domain], earliest_status_id: earliest_status_id, latest_status_id: latest_status_id }]
  end

  def data_source_query
    Status
      .select(:id)
      .joins(:account)
      .where(
        <<~SQL.squish
          statuses.id BETWEEN :earliest_status_id AND :latest_status_id
          AND #{account_domain_sql(params[:include_subdomains])}
          AND date_trunc('day', statuses.created_at)::date = axis.period
        SQL
      ).to_sql
  end

  def earliest_status_id
    Mastodon::Snowflake.id_at(@start_at.beginning_of_day, with_random: false)
  end

  def latest_status_id
    Mastodon::Snowflake.id_at(@end_at.end_of_day, with_random: false)
  end

  def params
    @params.permit(:domain, :include_subdomains)
  end
end
