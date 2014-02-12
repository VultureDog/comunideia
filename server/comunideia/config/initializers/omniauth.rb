OmniAuth.config.logger = Rails.logger
OmniAuth.config.on_failure = SessionsController.action(:failure_facebook_login)

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 'App ID', 'App Secret', :scope => "email"
end
