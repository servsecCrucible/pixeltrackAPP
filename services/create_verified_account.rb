require 'http'

# Returns an authenticated user, or nil
class CreateVerifiedAccount
  def self.call(username:, email:, password:)
    response = HTTP.post("#{ENV['API_HOST']}/accounts/",
                         json: { username: username,
                                 email: email,
                                 password: password })
    response.code == 201 ? true : false
  end
end
