class PostsController < ApplicationController
    
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  before_filter :require_login
  
  
  def like
    @post = Post.find(params[:id])
    @like_count = Post.find(params[:id])
    current_user.like!(@post)
    respond_to do |format|
    	format.js { render :file => "/users/like.js.erb" }		
    end
  end

  def unlike
    @post = Post.find(params[:id])
    @like_count = Post.find(params[:id])
    current_user.unlike!(@post)
    respond_to do |format|
		format.js { render :file => "/users/unlike.js.erb" }
    end
  end

  # GET /posts
  # GET /posts.json
  def index
        @posts = current_user.following_users.includes(:posts).collect{|u| u.posts}.flatten   
        @selfposts = Post.find(:all, :conditions => {:user_id => session[:user_id]})
        @posts = @posts + @selfposts
        @posts = @posts.sort_by(&:created_at).reverse
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @user = @post.user
    render :layout => "stay_layout"
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
      if current_user.id != @post.user_id
          redirect_to root_url
      end
  end

  # POST /posts
  # POST /posts.json
  def create
      @post = Post.new(post_params)
      @post.user_id = current_user.id
      if @post.save
        redirect_to root_url, notice: 'Post was successfully created.'
      else
        render action: 'new'
      end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
      @post.destroy
    redirect_to posts_url
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
        params.require(:post).permit(:title, :text, :photo)
    end
    

end
