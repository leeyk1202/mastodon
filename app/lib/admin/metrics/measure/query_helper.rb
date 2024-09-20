# frozen_string_literal: true

module Admin::Metrics::Measure::QueryHelper
  protected

  def perform_data_query
    measurement_data_rows.map { |row| { date: row['period'], value: row['value'].to_s } }
  end

  def measurement_data_rows
    ActiveRecord::Base.connection.select_all(sanitized_sql_string)
  end

  def sanitized_sql_string
    ActiveRecord::Base.sanitize_sql_array(sql_array)
  end

  def sql_array
    [sql_query_string, { start_at: @start_at, end_at: @end_at }]
  end

  def sql_query_string
    <<~SQL.squish
      SELECT axis.*, (
        WITH data_source AS (#{data_source.to_sql})
        SELECT #{select_target} FROM data_source
      ) AS value
      FROM (
        SELECT generate_series(:start_at::timestamp, :end_at::timestamp, '1 day')::date AS period
      ) AS axis
    SQL
  end

  def select_target
    Arel.star.count.to_sql
  end

  def matching_day(model, column)
    <<~SQL.squish
      DATE_TRUNC('day', #{model.table_name}.#{column})::date = axis.period
    SQL
  end

  def account_domain_scope
    if params[:include_subdomains]
      Account.by_domain_and_subdomains(params[:domain])
    else
      Account.with_domain(params[:domain])
    end
  end
end
