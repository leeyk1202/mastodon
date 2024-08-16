# frozen_string_literal: true

class ReportFilter
  KEYS = %i(
    resolved
    account_id
    target_account_id
    search_type
    search_term
    target_origin
  ).freeze

  IGNORED_PARAMS = %i(resolved search_type search_term).freeze

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def results
    scope = if params[:resolved] == '-1'
              Report.unscoped
            elsif params[:resolved] == '1'
              Report.resolved
            else
              Report.unresolved
            end

    params.each do |key, value|
      next if IGNORED_PARAMS.include? key.to_sym

      new_scope = scope_for(key, value)
      scope = scope.merge new_scope if new_scope
    end

    scope = scope.merge search_scope if searching?
    scope
  end

  def search_filter
    if params[:search_term].starts_with? '@'
      username_parts = params[:search_term].delete_prefix('@').split('@')
      Account.where(username: username_parts[0], domain: username_parts[1])
    else
      Account.where(domain: params[:search_term])
    end
  end

  def search_scope
    case params[:search_type].to_sym
    when :target
      Report.where(target_account: search_filter)
    when :source
      Report.where(account: search_filter)
    else
      raise Mastodon::InvalidParameterError, "Unknown search type: #{params[:search_type]}"
    end
  end

  def scope_for(key, value)
    case key.to_sym
    when :account_id
      Report.where(account_id: value)
    when :target_account_id
      Report.where(target_account_id: value)
    when :target_origin
      target_origin_scope(value) unless searching?
    else
      raise Mastodon::InvalidParameterError, "Unknown filter: #{key}"
    end
  end

  def target_origin_scope(value)
    case value.to_sym
    when :local
      Report.where(target_account: Account.local)
    when :remote
      Report.where(target_account: Account.remote)
    else
      raise Mastodon::InvalidParameterError, "Unknown value: #{value}"
    end
  end

  def searching?
    params[:search_term].present? && params[:search_type].present?
  end
end
