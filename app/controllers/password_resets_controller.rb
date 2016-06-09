class PasswordResetsController < ApplicationController
  def new
      render :layout => false
  end
  
  def create
      if user = User.find_by_email(params[:email])
          user.send_password_reset if user
          redirect_to root_url, :notice => "Email sent with password reset instructions."
      else
      redirect_to new_password_reset_path, :layout => false, :alert => "Email not registered"
      end
  end
  
  def edit
      @user = User.find_by_password_reset_token!(params[:id])
      render :layout => false
  end
  
  def update
      @user = User.find_by_password_reset_token!(params[:id])
      if @user.password_reset_sent_at < 1.hours.ago
          redirect_to new_password_reset_path, :alert => "Password reset has expired.", :layout => false
          elsif @user.update_attributes(params.permit![:user])
          redirect_to root_url, :notice => "Password has been reset!", :layout => false
          else
          render :edit, :layout => false
      end
  end
end
