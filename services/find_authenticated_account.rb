require 'http'

# Returns an authenticated user, or nil
class FindAuthenticatedAccount
  def self.call(username:, password:)
    signed_registration = SecureMessage.sign(
      {username: username, password: password})
    response = HTTP.post("#{ENV['API_HOST']}/accounts/authenticate",
                         body: signed_registration)
    response.code == 200 ? response.parse : nil
  end
end
