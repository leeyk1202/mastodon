# frozen_string_literal: true

module Admin
  class ReportsController < BaseController
    before_action :set_report, except: [:index]

    def index
      @reports = filtered_reports.page(params[:page])
    end

    def show; end

    def update
      process_report
      redirect_to admin_report_path(@report)
    end

    private

    def process_report
      case params[:outcome].to_s
      when 'resolve'
        @report.update(action_taken: true, action_taken_by_account_id: current_account.id)
      when 'suspend'
        Admin::SuspensionWorker.perform_async(@report.target_account.id)
        resolve_all_target_account_reports
      when 'silence'
        @report.target_account.update(silenced: true)
        resolve_all_target_account_reports
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    def resolve_all_target_account_reports
      unresolved_reports_for_target_account.update_all(
        action_taken: true,
        action_taken_by_account_id: current_account.id
      )
    end

    def unresolved_reports_for_target_account
      Report.
        unresolved.
        where(target_account: @report.target_account)
    end

    def filtered_reports
      filtering_scope.
        includes(:account, :target_account).
        order('id desc')
    end

    def filtering_scope
      params[:resolved].present? ? Report.resolved : Report.unresolved
    end

    def set_report
      @report = Report.find(params[:id])
    end
  end
end
