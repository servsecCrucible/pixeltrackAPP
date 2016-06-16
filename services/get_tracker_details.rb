require 'http'

# returns tracker details

class GetTrackerDetails
  def self.call(campaign_id:, tracker_id:, auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/campaigns/#{campaign_id}/trackers/#{tracker_id}")
    response.code == 200 ? extract_tracker_details(response.parse) : nil
  end

  private_class_method

  def self.extract_tracker_details(tracker_data)
    campaign = tracker_data['data']
  end
end
