require 'http'

# Returns all projects belonging to an account
class AddContributorToCampaign
  def self.call(auth_token:, contributor_email:, campaign_id:)
    config_url = "#{ENV['API_HOST']}/campaigns/#{campaign_id}/contributors"

    response = HTTP.accept('application/json')
                   .auth("Bearer #{auth_token}")
                   .post(config_url,
                         json: { email: contributor_email })

    response.code == 201 ? response.parse : nil
  end
end
