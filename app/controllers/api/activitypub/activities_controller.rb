# frozen_string_literal: true

class Api::Activitypub::ActivitiesController < ApiController
  # before_action :set_follow, only: [:show_follow]
  before_action :set_status, only: [:show_status]

  respond_to :activitystreams2

  def show_status
    if @status.reblog?
      render :show_status_announce
    else
      render :show_status_create
    end
  end

  private

  def set_status
    @status = Status.find(params[:id])
  end
end
