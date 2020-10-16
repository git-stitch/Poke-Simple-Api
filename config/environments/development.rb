Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    
    cache_servers = ("redis://192.168.0.10:6379/0")
    config.cache_store = :redis_cache_store, { 
      url: cache_servers,
      password: ENV['POKE_SIMPLE_API_REDIS_PASSWORD'],
      connect_timeout:    30,  # Defaults to 20 seconds
      read_timeout:       0.2, # Defaults to 1 second
      write_timeout:      0.2, # Defaults to 1 second
      reconnect_attempts: 1,   # Defaults to 0
    
      # error_handler: -> (method:, returning:, exception:) {
      #   # Report errors to Sentry as warnings
      #   Raven.capture_exception exception, level: 'warning',
      #     tags: { method: method, returning: returning }
      # }
    }
    config.active_record.cache_versioning = false
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = true
    cache_servers = %w(redis://redis:6379/0)
    config.cache_store = :redis_cache_store, { 
      url: cache_servers,
      password: ENV['POKE_SIMPLE_API_REDIS_PASSWORD'],
      connect_timeout:    30,  # Defaults to 20 seconds
      read_timeout:       0.2, # Defaults to 1 second
      write_timeout:      0.2, # Defaults to 1 second
      reconnect_attempts: 1,   # Defaults to 0
    
      # error_handler: -> (method:, returning:, exception:) {
      #   # Report errors to Sentry as warnings
      #   Raven.capture_exception exception, level: 'warning',
      #     tags: { method: method, returning: returning }
      # }
    }
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true


  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
