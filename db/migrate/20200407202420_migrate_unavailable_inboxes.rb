class MigrateUnavailableInboxes < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    redis = RedisConfiguration.pool.checkout
    urls = redis.smembers('unavailable_inboxes')

    hosts = urls.map do |url|
      Addressable::URI.parse(url).normalized_host
    end.compact.uniq

    UnavailableDomain.delete_all

    hosts.each do |host|
      UnavailableDomain.create(domain: host)
    end

    redis.del(*(['unavailable_inboxes'] + redis.keys('exhausted_deliveries:*')))
  end

  def down; end
end
