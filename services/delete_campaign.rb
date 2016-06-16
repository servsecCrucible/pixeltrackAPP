require 'http'

# Returns an authenticated user, or nil
class DeleteCampaign
  def self.call(auth_token:, owner:, campaign_id:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .delete("#{ENV['API_HOST']}/accounts/#{owner['username']}/owned_campaigns/#{campaign_id}")
    response.code == 200 ? true : nil
  end
end
