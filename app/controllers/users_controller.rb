class UsersController < ApplicationController
    
   # before_action :signed_in_user, only: [:edit, :update, :show]
   # before_action :correct_user,   only: [:edit, :update]
    before_filter :require_login, :except => [:create, :new]
  
    
    def remove_request
      @user = User.find(params[:id])
      Request.where(:approval_id => @user, :request_id => current_user).destroy_all
      redirect_to :back
    end
    
    def following
      if params[:id].nil? # if there is no user id in params, show current one
          @user = current_user
          @userfollowing = current_user.all_following
      else # if there is the user id in params just use it, 
           # maybe get 'authorization failed'
          @user = User.find params[:id]
          @userfollowing = @user.all_following
      end
      render :action => "following", :layout => "stay_layout"
    end
    
    def followers
      if params[:id].nil? # if there is no user id in params, show current one
          @user = current_user
          @userfollowers = current_user.followers
      else # if there is the user id in params just use it, 
           # maybe get 'authorization failed'
          @user = User.find params[:id]
          @userfollowers = @user.followers
      end
      render :action => "followers", :layout => "stay_layout"
    end
    
    def follow
      @user = User.find(params[:id])
      if @user.is_public == true
        @request = Request.new
        @request.request_id = current_user.id
        @request.approval_id = @user.id
        @request.save
      else
        current_user.follow(@user)
      end
      redirect_to :back
    end

    def unfollow
      @user = User.find(params[:id])
      current_user.stop_following(@user)
      redirect_to :back
    end
    
    def search
      if params[:id].nil? # if there is no user id in params, show current one
          @user = current_user
      else # if there is the user id in params just use it, 
           # maybe get 'authorization failed'
          @user = User.find params[:id]
      end
      #@events = Event.simple_search(params[:search_string])
      @users = User.fuzzy_search(params[:search_string])
      
      render :action => "index"
    end
    
    def new
            @user = User.new
            render :layout => false
    end
    
    def index 
        if @user == nil
          redirect_to root_url
        end
    end
    
    def create
        @user = User.new(user_params)
        if @user.save
            redirect_to log_in_path, :notice => "Signed up successful! Please log in"
            else
            render "new", :layout => false, :notice => "Signed up successful! Please log in"
        end
    end
    
    def edit
        @user = User.find(params[:id])
        render :layout => false
    end
    
    def show
        if params[:id].nil? # if there is no user id in params, show current one
            @user = current_user
        else # if there is the user id in params just use it, 
             # maybe get 'authorization failed'
            @user = User.find params[:id]
        end
        @post = @user.posts.sort_by(&:created_at).reverse
        @postphoto = @user.posts.order('created_at desc').limit(12)
        render :layout => false
    end
    


    def update
		    @user = User.find(params[:id])
        if @user.update_attributes(user_params)
            redirect_to user_url
        else
            render action: "edit", :layout => false
        end
    end
    
    def user_params
        params.require(:user).permit(:f_name, :s_name, :email, :password, :password_confirmation, :picture, :is_public)
    end
    
#     def signed_in_user
#         redirect_to root_url unless signed_in?
#     end
    
#     def correct_user
#         @user = User.find(params[:id])
#         redirect_to(root_url) unless current_user?
#     end
    
#     def require_login
#         unless current_user
#             redirect_to log_in_url
#         end
#     end

end
