# frozen_string_literal: true

class DomainWhitelist < ApplicationRecord
  enum severity: [:silence, :enable]

  def self.enabled?
    return Setting.where(var: 'whitelist_enabled').first_or_initialize!(var: 'whitelist_enabled', value: false)
  end

  validates :domain, presence: true, uniqueness: true

  def self.blocked?(domain)
    !where(domain: domain).exists?
  end
end
