require 'sinatra'

# Base class for PixelTrack web application
class PixelTrackApp < Sinatra::Base
    get '/login/?' do
        slim :login
    end

    post '/login/?' do
        credentials = LoginCredentials.call(params)
        if credentials.failure?
            redirect '/login'
            halt
        end

        @current_account = FindAuthenticatedAccount.call(credentials)

        if @current_account
            session[:current_account] = SecureMessage.encrypt(@current_account)
            redirect '/'
        else
            slim :login
        end
    end

    get '/logout/?' do
        @current_account = nil
        session[:current_account] = nil
        slim :login
    end

    get '/account/:username' do
        if @current_account && @current_account['username'] == params[:username]
            slim :account
        else
            slim :login
        end
    end
end
