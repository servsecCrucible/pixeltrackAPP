require 'http'

# returns all campaigns belonging to an account

class GetCampaignDetails
  def self.call(campaign_id:, auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/campaigns/#{campaign_id}")
    response.code == 200 ? extract_campaign_details(response.parse) : nil
  end

  private_class_method

  def self.extract_campaign_details(campaign_data)
    campaign = campaign_data['data']
    trackers = campaign_data['trackers']
    contributors = campaign_data['contributors']

    tracker_set = trackers.map do |tracker|
      {
        id: tracker['id'],
        label: tracker['attributes']['label'],
        url: tracker['attributes']['url']
      }
    end

    contributor_set = contributors.map do |contributor|
      {
        id: contributor['id'],
        username: contributor['username'],
        email: contributor['email']
      }
    end

    { id: campaign['id'],
      label: campaign['attributes']['label'],
      nb_visits: campaign['attributes']['nb_visits'],
      tracker_set: tracker_set,
      contributor_set: contributor_set
    }
  end
end
