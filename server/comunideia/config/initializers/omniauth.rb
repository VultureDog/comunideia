OmniAuth.config.logger = Rails.logger
OmniAuth.config.on_failure = SessionsController.action(:failure)

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 'App ID', 'App Secret', :scope => "email"
  provider :google_oauth2, 'Client ID', 'Client secret', :scope => "userinfo.email"
end