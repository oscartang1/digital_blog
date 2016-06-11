class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  helper_method :post_owner?, :count_posts, :current_user, :user_post_count, :owner?, :params_user, :requested?, :current_requested?, :signed_in?, :requrie_login
    
	
    def requested?
      Request.exists? approval_id: @user.id
    end
    
    def current_requested?
      Request.exists? approval_id: params[:id]
    end

    def post_owner?
        @post.user_id == current_user.id
    end
    
    def owner?
        @user.id == current_user.id
    end
    
    def count_posts
        current_user.posts.count
    end
    
    def user_post_count
        @user.posts.count
    end
    
    def record_not_found
        redirect_to root_path
    end
    
    def signed_in?
        current_user != nil
    end
    
    def require_login
        unless current_user
            redirect_to log_in_url
        end
    end

    private
  
    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  
    def current_user?
        @user == current_user
    end
  
end
