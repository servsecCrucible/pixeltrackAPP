# frozen_string_literal: true
require 'sinatra'

class PixelTrackApp < Sinatra::Base
  get '/accounts/:username/campaigns/?' do
    if @current_account && @current_account['username'] == params[:username]
      @campaigns = GetAllCampaigns.call(current_account: @current_account,
                                        auth_token: session[:auth_token])
    end
    @campaigns ? slim(:all_campaigns) : redirect('/login')
  end

  get '/accounts/:username/campaigns/:campaign_id/?' do
    if @current_account && @current_account['username'] == params[:username]
      @campaign = GetCampaignDetails.call(campaign_id: params[:campaign_id],
                                          auth_token: session[:auth_token])
      if @campaign
        @visits = @campaign[:tracker_set].map do |track|
          {
            id: track[:id],
            data: GetTrackerDetails.call(campaign_id: params[:campaign_id],
                                                tracker_id: track[:id], auth_token: session[:auth_token])
          }
        end
        slim(:campaign)
      else
        flash[:error] = 'We cannot find this project in your account'
        redirect "/accounts/#{@current_account['username']}/campaigns"
      end
    else
      redirect '/login'
    end
  end

  post '/accounts/:username/campaigns/?' do
    halt_if_incorrect_user(params)
    campaigns_url = "/accounts/#{@current_account['username']}/campaigns"

    new_campaign_data = NewCampaign.call(params)
    if new_campaign_data.failure?
      flash[:error] = new_campaign_data.messages.values.join('; ')
      redirect campaigns_url
    else
      begin
        new_campaign = CreateNewCampaign.call(
          auth_token: session[:auth_token],
          owner: @current_account,
          new_campaign: new_campaign_data.to_h
        )
        flash[:notice] = 'Your new campaign has been created! '\
                         ' Now add configurations and invite collaborators.'
        redirect campaigns_url + "/#{new_campaign['id']}"
      rescue => e
        flash[:error] = 'Something went wrong -- we will look into it!'
        logger.error "NEW_CAMPAIGN FAIL: #{e}"
        redirect campaigns_url
      end
    end
  end

  post '/accounts/:username/campaigns/:campaign_id/trackers?' do
    halt_if_incorrect_user(params)

    new_tracker_data = NewTracker.call(params)
    if new_tracker_data.failure?
      flash[:error] = new_tracker_data.messages.values.join('; ')
      redirect back
    else
      begin
        new_tracker = CreateNewTracker.call(
          auth_token: session[:auth_token],
          campaign_id: params[:campaign_id],
          new_tracker: new_tracker_data.to_h
        )
        flash[:notice] = 'Your new tracker has been created! '
        redirect back
      rescue => e
        flash[:error] = 'Something went wrong -- we will look into it!'
        logger.error "NEW_TRACKER FAIL: #{e}"
        redirect back
      end
    end
  end

  post '/accounts/:username/campaigns/:campaign_id/contributors/?' do
    halt_if_incorrect_user(params)

    contributor = AddContributorToCampaign.call(
      contributor_email: params[:email],
      campaign_id: params[:campaign_id],
      auth_token: session[:auth_token]
    )

    if contributor
      account_info = "#{contributor['username']} (#{contributor['email']})"
      flash[:notice] = "Added #{account_info} to the campaign"
    else
      flash[:error] = "Could not add #{params['email']} to the campaign"
    end

    redirect back
  end
end
