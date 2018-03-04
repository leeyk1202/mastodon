# frozen_string_literal: true

class Api::V1::Statuses::PinsController < Api::BaseController
  include Authorization

  before_action -> { doorkeeper_authorize! :write }
  before_action :require_user!
  before_action :set_status

  respond_to :json

  def create
    StatusPin.create!(account: current_account, status: @status)
    distribute_add_activity!
    render json: @status, serializer: REST::StatusSerializer
  end

  def destroy
    pin = StatusPin.find_by(account: current_account, status: @status)

    if pin
      pin.destroy!
      distribute_remove_activity!
    end

    render json: @status, serializer: REST::StatusSerializer
  end

  private

  def set_status
    @status = Status.find(params[:status_id])
  end

  def distribute_add_activity!
    json = Oj.dump(ActivityPub::LinkedDataSignature.new(ActiveModelSerializers::SerializableResource.new(
      @status,
      serializer: ActivityPub::AddSerializer,
      adapter: ActivityPub::Adapter
    ).as_json).sign!(current_account))

    ActivityPub::RawDistributionWorker.perform_async(json, current_account)
  end

  def distribute_remove_activity!
    json = Oj.dump(ActivityPub::LinkedDataSignature.new(ActiveModelSerializers::SerializableResource.new(
      @status,
      serializer: ActivityPub::RemoveSerializer,
      adapter: ActivityPub::Adapter
    ).as_json).sign!(current_account))

    ActivityPub::RawDistributionWorker.perform_async(json, current_account)
  end
end
