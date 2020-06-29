# :nocov:
path = Rails.root.join('config', 'locales', '**', '*.{rb,yml}')
Rails.application.config.i18n.load_path += Dir[path]
Rails.application.config.i18n.default_locale = :en
# :nocov:
