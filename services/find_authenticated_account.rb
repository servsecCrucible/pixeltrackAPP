require 'http'

# returns authenticated user or nil
class FindAuthenticatedAccount
	HOST = 'localhost:9292//api/v1'

	def self.call(username:, password:)
		response = HTTP.get("#{HOST}/accounts/#{username}/authenticate",
							params: {password: password})
		response.code == 200 ? JSON.parse(response) : nil
	end
end