class ReviewsController < ApplicationController
    before_action :set_review, only: [:show, :edit, :update, :destroy ]

  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
      # @review = Review.new
      @review = Review.new(:post_id => params[:id])
      @review.post_id = params[:id]
      @post = Post.find(params[:id])
      @user = @post.user
      render :layout => "stay_layout"
      if params[:id] == nil
          redirect_to root_url
      end
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews
  # POST /reviews.json
  def create
      @review = Review.new(review_params)
      @review.user_id = current_user.id

      if @review.save
        post = Post.find(@review.post_id)
        redirect_to post, notice: 'Review was successfully created.'
        else
        render action: 'new'
      end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
        format.html { redirect_to(:back) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
        params.require(:review).permit(:name, :review_text, :post_id)
    end
end
