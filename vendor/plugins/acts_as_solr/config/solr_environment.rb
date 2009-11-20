ENV['RAILS_ENV']  = (ENV['RAILS_ENV'] || 'development').dup
***REMOVED*** RAILS_ROOT isn't defined yet, so figure it out.
rails_root_dir = "***REMOVED***{File.dirname(File.expand_path(__FILE__))}/../../../../"
SOLR_PATH = "***REMOVED***{File.dirname(File.expand_path(__FILE__))}/../solr" unless defined? SOLR_PATH

SOLR_LOGS_PATH = "***REMOVED***{rails_root_dir}/log" unless defined? SOLR_LOGS_PATH
SOLR_PIDS_PATH = "***REMOVED***{rails_root_dir}/tmp/pids" unless defined? SOLR_PIDS_PATH
SOLR_DATA_PATH = "***REMOVED***{rails_root_dir}/solr/***REMOVED***{ENV['RAILS_ENV']}" unless defined? SOLR_DATA_PATH

unless defined? SOLR_PORT
  config = YAML::load_file(rails_root_dir+'/config/solr.yml')
  
  SOLR_PORT = ENV['PORT'] || URI.parse(config[ENV['RAILS_ENV']]['url']).port
end

SOLR_JVM_OPTIONS = config[ENV['RAILS_ENV']]['jvm_options'] unless defined? SOLR_JVM_OPTIONS

if ENV['RAILS_ENV'] == 'test'
  DB = (ENV['DB'] ? ENV['DB'] : 'mysql') unless defined?(DB)
  MYSQL_USER = (ENV['MYSQL_USER'].nil? ? 'root' : ENV['MYSQL_USER']) unless defined? MYSQL_USER
  require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'test', 'db', 'connections', DB, 'connection.rb')
end
