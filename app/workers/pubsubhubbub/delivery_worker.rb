# frozen_string_literal: true

class Pubsubhubbub::DeliveryWorker
  include Sidekiq::Worker
  include RoutingHelper

  sidekiq_options queue: 'push'

  def perform(subscription_id, payload)
    subscription = Subscription.find(subscription_id)
    headers      = {}

    headers['User-Agent']      = 'Mastodon/PubSubHubbub'
    headers['Link']            = LinkHeader.new([[api_push_url, [%w(rel hub)]], [account_url(subscription.account, format: :atom), [%w(rel self)]]]).to_s
    headers['X-Hub-Signature'] = signature(subscription.secret, payload) unless subscription.secret.blank?

    response = HTTP.timeout(:per_operation, write: 50, connect: 20, read: 50)
                   .headers(headers)
                   .post(subscription.callback_url, body: payload)

    raise "Delivery failed for #{subscription.callback_url}: HTTP #{response.code}" unless response.code > 199 && response.code < 300
  end

  private

  def signature(secret, payload)
    hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, payload)
    "sha1=#{hmac}"
  end
end
