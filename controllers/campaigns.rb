require 'sinatra'

class PixelTrackApp < Sinatra::Base
    get '/accounts/:username/campaigns' do
        if @current_account && @current_account['username'] == params[:username]
            @campaigns = GetAllCampaigns.call(current_account: @current_account,
                                              auth_token: session[:auth_token])
        end

        @campaigns ? slim(:all_campaigns) : redirect ('/login')
    end

    get '/accounts/:username/campaigns/:campaign_id' do
      if @current_account && @current_account['username'] == params[:username]
        @campaign = GetCampaignDetails.call(campaign_id: params[:campaign_id],
                                            auth_token: session[:auth_token])
        if @campaign
          slim(:campaign)
        else
          flash[:error] = 'We cannot find this project in your account'
          redirect "/accounts/#{params[:username]}/campaigns"
        end
      else
        redirect '/login'
      end
    end
end
