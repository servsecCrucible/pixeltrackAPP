require 'sinatra'

# Base class for PixelTrack web application
class PixelTrackApp < Sinatra::Base
    use Rack::Session::Cookie,  expire_after: 2_592_000,
                                coder: CookieEncoder.new,
                                let_coder_handle_secure_encoding: true

    set :views, File.expand_path('../../views', __FILE__)

    before do
        @current_account = session[:current_account]
    end

    get '/' do
        slim :home
    end
end
