require File.expand_path('../boot', __FILE__)

require 'rails/all'

***REMOVED*** Get the SMTP password for Action Mailer
require File.join(File.dirname(__FILE__), 'smtp_settings')

***REMOVED*** If you have a Gemfile, require the gems listed there, including any gems
***REMOVED*** you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

require 'ucb_ldap'

module ResearchMatch
  class Application < Rails::Application
    ***REMOVED*** Settings in config/environments/* take precedence over those specified here.
    ***REMOVED*** Application configuration should go into files in config/initializers
    ***REMOVED*** -- all .rb files in that directory are automatically loaded.

    ***REMOVED*** Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(***REMOVED***{config.root}/extras ***REMOVED***{config.root}/lib)

    ***REMOVED*** Only load the plugins named here, in the order given (default is alphabetical).
    ***REMOVED*** :all can be used as a placeholder for all plugins not explicitly named.
    ***REMOVED*** config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    ***REMOVED*** Activate observers that should always be running.
    ***REMOVED*** config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    ***REMOVED*** Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    ***REMOVED*** Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "Pacific Time (US & Canada)"

    ***REMOVED*** The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    ***REMOVED*** config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    ***REMOVED*** config.i18n.default_locale = :de

    ***REMOVED*** JavaScript files you want as :defaults (application.js is always included).
    ***REMOVED*** config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    ***REMOVED*** Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    ***REMOVED*** Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    ***REMOVED*** Configure the Action Mailer.
    ***REMOVED*** TODO: Move this into per-environment config rb's.
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => 'localhost',
      :user_name            => @@smtp_username,
      :password             => @@smtp_pw,
      :authentication       => 'plain',
      :enable_starttls_auto => true
    }
  end
end
