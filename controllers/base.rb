require 'sinatra'
require 'rack/ssl-enforcer'

# Base class for PixelTrack web application
class PixelTrackApp < Sinatra::Base
    enable :logging

    use Rack::Session::Cookie, secret: ENV['MSG_KEY']
    set :views, File.expand_path('../../views', __FILE__)

    configure :production do
      use Rack::SslEnforcer
    end
    
    before do
        if session[:current_account]
            @current_account = SecureMessage.decrypt(session[:current_account])
        end
    end

    get '/' do
        slim :home
    end
end
