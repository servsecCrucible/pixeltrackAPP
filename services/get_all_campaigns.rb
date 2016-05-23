require 'http'

# returns all campaigns belonging to an account

class GetAllCampaigns 
  def self.call(username:, auth_token:) 
    response = HTTP.auth("Bearer #{auth_token}") 
                   .get("#{ENV['API_HOST']}/accounts/#{username}/campaigns") 
    response.code == 200 ? extract_campaigns(response.parse) : nil 
  end 
 
  private 

  def self.extract_campaigns(campaigns) 
    projects['data'].map do |proj| 
      { id: proj['id'], 
        name: proj['attributes']['name'], 
        repo_url: proj['attributes']['repo_url'] } 
    end 
  end 
end 
