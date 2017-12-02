# Set available locales
I18n.available_locales = [:en, :de]

# Make english the default locale
I18n.default_locale = :en

# Load nested translations
I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
