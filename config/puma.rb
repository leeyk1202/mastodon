persistent_timeout ENV.fetch('PERSISTENT_TIMEOUT') { 20 }.to_i

threads_count = ENV.fetch('MAX_THREADS') { 5 }.to_i
threads threads_count, threads_count

if ENV['SOCKET']
  bind "unix://#{ENV['SOCKET']}"
else
  bind "tcp://#{ENV.fetch('BIND', '127.0.0.1')}:#{ENV.fetch('PORT', 3000)}"
end

environment ENV.fetch('RAILS_ENV') { 'development' }
workers     ENV.fetch('WEB_CONCURRENCY') { 2 }

preload_app!

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end

  require 'prometheus_exporter/instrumentation'
  require 'prometheus_exporter/client'
  
  prometheus_exporter_host = ENV.fetch('PROMETHEUS_EXPORTER_HOST') { 'prometheus_exporter' }
  prometheus_client = PrometheusExporter::Client.new(host: prometheus_exporter_host)
  PrometheusExporter::Client.default = prometheus_client

  # this reports basic process stats like RSS and GC info
  PrometheusExporter::Instrumentation::Process.start(type: "master")
  PrometheusExporter::Instrumentation::Process.start(type:"web")

end

plugin :tmp_restart
