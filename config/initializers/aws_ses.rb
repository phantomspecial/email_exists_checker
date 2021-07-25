creds = Aws::Credentials.new(
  Rails.application.credentials.dig(:aws, :ses_access_key_id),
  Rails.application.credentials.dig(:aws, :ses_secret_access_key)
)
Aws::Rails.add_action_mailer_delivery_method(:ses, credentials: creds, region: 'us-east-1')
