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
    trackers = campaign_data['relationships']

    tracker_set = trackers.map do |tracker|
      {
        id: tracker['id'],
        label: tracker['attributes']['label'],
        url: tracker['attributes']['url']
      }
    end

    { id: campaign['id'],
      label: campaign['attributes']['label'],
      tracker_set: tracker_set }
  end
end
