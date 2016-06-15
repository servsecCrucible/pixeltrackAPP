require 'http'

# Returns an authenticated user, or nil
class CreateNewCampaign
  def self.call(auth_token:, owner:, new_campaign:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .post("#{ENV['API_HOST']}/accounts/#{owner['username']}/owned_campaigns/",
                         json: new_campaign.to_h)
    new_campaign = response.parse
    response.code == 201 ? new_campaign : nil
  end
end
