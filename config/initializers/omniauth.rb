Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer, fields: [:name, :uid], uid_field: :uid unless Rails.env.production?
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
end