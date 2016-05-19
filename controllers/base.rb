require 'sinatra'
require 'rack-flash'

# Base class for PixelTrack web application
class PixelTrackApp < Sinatra::Base
    enable :logging
    
    use Rack::Session::Cookie, secret: ENV['MSG_KEY']
    use Rack::Flash

    set :views, File.expand_path('../../views', __FILE__)
    set :public_dir, File.expand_path('../../public', __FILE__)

    before do
        if @current_account
            session[:current_account] = SecureMessage.decrypt(session[:current_account])
            flash[:notice] = "Welcome back #{@current_account['username']}"
            slim :home
        else
            flash[:error] = "Your username or password did not match our records"
            slim :login    
        end
    end

    get '/' do
        slim :home
    end
end
