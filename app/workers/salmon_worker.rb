# frozen_string_literal: true

class SalmonWorker
  include Sidekiq::Worker

  sidekiq_options backtrace: true

  def perform(account_id, body)
    ProcessInteractionService.new.call(body, Account.find(account_id))
  rescue LL::ParserError, ActiveRecord::RecordNotFound
    true
  end
end
