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
        logger.info "1"
        logger.info session[:auth_token]
        logger.info @current_account
        logger.info new_campaign_data.to_h
        new_campaign = CreateNewCampaign.call(
          auth_token: session[:auth_token],
          owner: @current_account,
          new_campaign: new_campaign_data.to_h)
        logger.info "2"
        flash[:notice] = 'Your new campaign has been created! '\
                         ' Now add configurations and invite collaborators.'
        logger.info "3"
        redirect campaigns_url + "/#{new_campaign['id']}"
      rescue => e
        flash[:error] = 'Something went wrong -- we will look into it!'
        logger.error "NEW_CAMPAIGN FAIL: #{e}"
        redirect "/accounts/#{@current_account['username']}/campaigns"
      end
    end
  end
end
