class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token

  # GET /posts or /posts.json
  def index
    cached_posts = Rails.cache.read("all_posts")

    if cached_posts
      @posts = cached_posts
    else
      @posts = Post.all
      Rails.cache.write("all_posts", @posts.to_json, expires_in: 1.hour)
    end

    render json: @posts, status: :ok
  end

  # GET /posts/1 or /posts/1.json
  def show
    render json: @post, status: :ok
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    render json: @post, status: :ok
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        Rails.cache.delete("all_posts")
        format.json { render :show, status: :created, location: @post }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      
      if @post.update(post_params)
        Rails.cache.delete("all_posts")
        Rails.cache.delete("post_#{@post.id}")
        format.json { render :show, status: :ok, location: @post }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    Rails.cache.delete("all_posts")
    Rails.cache.delete("post_#{@post.id}")

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      cached_post = Rails.cache.read("post_#{params[:id]}")
      if cached_post
        post_data = JSON.parse(cached_post)
        @post = Post.find_by(id: post_data['id']) || Post.new(post_data)      
      else 
        @post = Post.find(params[:id])
        Rails.cache.write("post_#{params[:id]}", @post.to_json, expires_in: 1.hour)
      end
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :author)
    end
end
