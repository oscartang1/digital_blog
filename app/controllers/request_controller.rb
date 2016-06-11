class RequestController < ApplicationController

  before_filter :require_login
  
  def new
  end
  
  def destroy
    @user = User.find(params[:id])
    Request.where(:approval_id => @user, :request_id => current_user).destroy_all
    redirect_to users_url
  end
   
  def index    
    @request = Request.where(:approval_id => current_user.id)
    @follow = Follow.where(followable_id: current_user.id).sort_by(&:created_at).reverse
  end
  
  def confirm  
    @user = User.find(params[:id])
    Request.where(:approval_id => current_user, :request_id => @user).destroy_all
    @user.follow(current_user)
    redirect_to :back 
  end
  
  def reject  
    @user = User.find(params[:id])
    Request.where(:approval_id => current_user, :request_id => @user).destroy_all
    redirect_to :back 
  end
  
end
