# frozen_string_literal: true

class InstanceActorsController < ApplicationController
  include AccountControllerConcern

  before_action :set_cache_headers

  def show
    respond_to do |format|
      format.html do
        expires_in 0, public: true
      end

      format.json do
        expires_in 3.minutes, public: true
        render json: @account, content_type: 'application/activity+json', serializer: ActivityPub::ActorSerializer, adapter: ActivityPub::Adapter, fields: restrict_fields_to
      end
    end
  end

  private

  def set_account
    @account = Account.find(0)
  end

  def restrict_fields_to
    %i(id type preferred_username inbox public_key endpoints icon image url manually_approves_followers)
  end
end
