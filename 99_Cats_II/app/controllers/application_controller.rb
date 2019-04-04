class ApplicationController < ActionController::Base


    helper_method :current_user, :login, :logged_in?, :require_logged_in, :require_logged_out

    def current_user
        return nil if session[:session_token].nil?
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def login!(user)
        @current_user = user
        @current_user.reset_session_token!
        session[:session_token] = @current_user.session_token
    end

    def logged_in?
        !!(current_user)
    end

    def require_logged_out 
        redirect_to cats_url if logged_in?
    end

    def require_logged_in
        redirect_to new_sessions_url unless logged_in?
    end

end
