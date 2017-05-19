# frozen_string_literal: true
#
# Mastodon, a GNU Social-compatible microblogging server
# Copyright (C) 2016-2017 Eugen Rochko & al (see the AUTHORS file)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

class Api::V1::StatusesController < ApiController
  before_action :authorize_if_got_token, except:            [:create, :destroy, :reblog, :unreblog, :favourite, :unfavourite, :mute, :unmute]
  before_action -> { doorkeeper_authorize! :write }, only:  [:create, :destroy, :reblog, :unreblog, :favourite, :unfavourite, :mute, :unmute]
  before_action :require_user!, except:  [:show, :context, :card, :reblogged_by, :favourited_by]
  before_action :set_status, only:       [:show, :context, :card, :reblogged_by, :favourited_by, :mute, :unmute]
  before_action :set_conversation, only: [:mute, :unmute]

  respond_to :json

  def show
    cached  = Rails.cache.read(@status.cache_key)
    @status = cached unless cached.nil?
  end

  def context
    ancestors_results   = @status.in_reply_to_id.nil? ? [] : @status.ancestors(current_account)
    descendants_results = @status.descendants(current_account)
    loaded_ancestors    = cache_collection(ancestors_results, Status)
    loaded_descendants  = cache_collection(descendants_results, Status)

    @context = OpenStruct.new(ancestors: loaded_ancestors, descendants: loaded_descendants)
    statuses = [@status] + @context[:ancestors] + @context[:descendants]

    set_maps(statuses)
  end

  def card
    @card = PreviewCard.find_by(status: @status)
    render_empty if @card.nil?
  end

  def reblogged_by
    results   = @status.reblogs.paginate_by_max_id(limit_param(DEFAULT_ACCOUNTS_LIMIT), params[:max_id], params[:since_id])
    accounts  = Account.where(id: results.map(&:account_id)).map { |a| [a.id, a] }.to_h
    @accounts = results.map { |r| accounts[r.account_id] }

    next_path = reblogged_by_api_v1_status_url(pagination_params(max_id: results.last.id))    if results.size == limit_param(DEFAULT_ACCOUNTS_LIMIT)
    prev_path = reblogged_by_api_v1_status_url(pagination_params(since_id: results.first.id)) unless results.empty?

    set_pagination_headers(next_path, prev_path)

    render :accounts
  end

  def favourited_by
    results   = @status.favourites.paginate_by_max_id(limit_param(DEFAULT_ACCOUNTS_LIMIT), params[:max_id], params[:since_id])
    accounts  = Account.where(id: results.map(&:account_id)).map { |a| [a.id, a] }.to_h
    @accounts = results.map { |f| accounts[f.account_id] }

    next_path = favourited_by_api_v1_status_url(pagination_params(max_id: results.last.id))    if results.size == limit_param(DEFAULT_ACCOUNTS_LIMIT)
    prev_path = favourited_by_api_v1_status_url(pagination_params(since_id: results.first.id)) unless results.empty?

    set_pagination_headers(next_path, prev_path)

    render :accounts
  end

  def create
    @status = PostStatusService.new.call(current_user.account,
                                         status_params[:status],
                                         status_params[:in_reply_to_id].blank? ? nil : Status.find(status_params[:in_reply_to_id]),
                                         media_ids: status_params[:media_ids],
                                         sensitive: status_params[:sensitive],
                                         spoiler_text: status_params[:spoiler_text],
                                         visibility: status_params[:visibility],
                                         application: doorkeeper_token.application,
                                         idempotency: request.headers['Idempotency-Key'])

    render :show
  end

  def destroy
    @status = Status.where(account_id: current_user.account).find(params[:id])
    RemovalWorker.perform_async(@status.id)
    render_empty
  end

  def reblog
    @status = ReblogService.new.call(current_user.account, Status.find(params[:id]))
    render :show
  end

  def unreblog
    reblog       = Status.where(account_id: current_user.account, reblog_of_id: params[:id]).first!
    @status      = reblog.reblog
    @reblogs_map = { @status.id => false }

    RemovalWorker.perform_async(reblog.id)

    render :show
  end

  def favourite
    @status = FavouriteService.new.call(current_user.account, Status.find(params[:id])).status.reload
    render :show
  end

  def unfavourite
    @status         = Status.find(params[:id])
    @favourites_map = { @status.id => false }

    UnfavouriteWorker.perform_async(current_user.account_id, @status.id)

    render :show
  end

  def mute
    current_account.mute_conversation!(@conversation)

    @mutes_map = { @conversation.id => true }

    render :show
  end

  def unmute
    current_account.unmute_conversation!(@conversation)

    @mutes_map = { @conversation.id => false }

    render :show
  end

  private

  def set_status
    @status = Status.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @status.permitted?(current_account)
  end

  def set_conversation
    @conversation = @status.conversation
    raise Mastodon::ValidationError if @conversation.nil?
  end

  def status_params
    params.permit(:status, :in_reply_to_id, :sensitive, :spoiler_text, :visibility, media_ids: [])
  end

  def pagination_params(core_params)
    params.permit(:limit).merge(core_params)
  end

  def authorize_if_got_token
    request_token = Doorkeeper::OAuth::Token.from_request(request, *Doorkeeper.configuration.access_token_methods)
    doorkeeper_authorize! :read if request_token
  end
end
