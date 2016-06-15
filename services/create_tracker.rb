require 'http'

# Returns an authenticated user, or nil
class CreateNewTracker
  def self.call(auth_token:, campaign_id:, new_tracker:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .post("#{ENV['API_HOST']}/campaigns/#{campaign_id}/trackers/",
                         json: new_tracker.to_h)
    new_tracker = response.parse
    response.code == 201 ? new_tracker : nil
  end
end
