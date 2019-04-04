class SessionsController < ApplicationController
before_action :require_logged_out, only: [:new, :create]

    def new 
        render :new
    end

    def create 
        user = User.find_by_credentials( 
            params[:user][:user_name],
            params[:user][:password]
        )

        if user.nil?
            render json: "Wrong Credentials"
        else
            login!(user)
            redirect_to user_url(user)
        end
    end

    def destroy
        current_user.reset_session_token! if current_user
        session[:session_token] = nil
        redirect_to users_url
    end

end
