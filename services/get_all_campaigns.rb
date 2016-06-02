require 'http'

# returns all campaigns belonging to an account

class GetAllCampaigns
  def self.call(current_account:, auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/accounts/#{current_account['username']}/campaigns")
    response.code == 200 ? extract_campaigns(response.parse) : nil
  end

  private_class_method

  def self.extract_campaigns(campaigns)
    campaigns['data'].map do |camp|
      { id: camp['id'],
        label: camp['attributes']['label']}
    end
  end
end
