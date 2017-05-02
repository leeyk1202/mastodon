# frozen_string_literal: true

module Admin
  class InstancesController < BaseController
    def index
      @instances = ordered_instances.page(params[:page])
    end

    def show
      @instance = DomainPresenter.new(params[:id])
    end

    private

    def ordered_instances
      Account.remote.by_domain_accounts
    end
  end
end
