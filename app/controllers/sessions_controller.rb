class SessionsController < ApplicationController
        
  def new
      if session[:user_id]
          redirect_to root_url
          else
          render :layout => false
      end
  end
  
  def create
      user = User.authenticate(params[:email], params[:password])
      if user
          session[:user_id] = user.id
          redirect_to root_url
          else
          redirect_to root_url, :alert => "Invalid email or password"
      end
  end
  
  def destroy
      session[:user_id] = nil
      redirect_to root_url, :notice => "Logged out!"
  end
  
  
end
