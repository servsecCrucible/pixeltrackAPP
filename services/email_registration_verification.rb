require 'pony'

class EmailRegistrationVerification
  def self.call(email:)
    email = { email: email }
    token_encrypted = SecureMessage.encrypt(email)
    Pony.mail(to: email[:email],
              subject: "Your Account is Almost Ready",
              html_body: registration_email(token_encrypted))
  end

  private_class_method

  def self.registration_email(token)
    verification_url = "#{ENV['APP_HOST']}/register/#{token}/verify"

    <<~END_EMAIL
      <H1>ShareConfig Registration Received<H1>
      <p>Please <a href=\"#{verification_url}\">click here</a> to validate your
      email. You will be asked to set a password to activate your account.</p>
    END_EMAIL
  end
end
