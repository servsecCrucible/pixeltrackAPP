require 'dry-validation'

NewCampaign = Dry::Validation.Form do
    key(:label).required

    configure do
      config.messages_file = File.join(__dir__, 'new_campaign_errors.yml')
    end
end
