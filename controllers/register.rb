require 'sinatra'

class PixelTrackApp < Sinatra::Base
    get '/register/?' do
        slim :register
    end

    post '/register/?' do
        email = Email.call(params)
        if email.failure?
            flash[:error] = 'Please enter a valid email'
            redirect '/register'
            halt
        end
        begin
            EmailRegistrationVerification.call(email)
            flash[:notice] = 'Take a look at your mailbox, our messenger pigeon is coming ASAP!'
            redirect '/'
        rescue => e
            logger.error "FAIL EMAIL: #{e}"
            flash[:error] = 'Unable to send email verification -- please '\
                      'check you have entered the right address'
            redirect '/register'
        end
    end

    get '/register/:token_secure/verify' do
        @token_secure = params[:token_secure]
        puts @token_secure
        @new_account = SecureMessage.decrypt(@token_secure)

        slim :register_confirm
    end

    post '/register/:token_secure/verify' do
        registration = Registration.call(params)
        if registration.failure?
            flash[:error] = registration.messages.values.join('; ')
            redirect "/register/#{params[:token_secure]}/verify"
            halt
        end

        email = SecureMessage.decrypt(params[:token_secure])
        result = CreateVerifiedAccount.call(
            username: params['username'],
            email: email['email'],
            password: params['password']
        )
        puts "RESULT: #{result}"
        if result
          flash[:notice] = "Let\'s try to loggin with your all new account"
          redirect('/login')
        end
        flash[:error] = "Please try to register again"
        redirect('/register')
    end
end
