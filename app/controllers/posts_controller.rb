class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
  	# @posts = Post.all
    @search = Post.search(params[:q])
    @posts = @search.result
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    binding.pry
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:success] = "投稿が完了しました。"
      redirect_to post_path(@post.id)
    else
      flash[:warning] = "投稿失敗しました。"
      render 'new'
    end
  end

  def hashtags
  	@tag = Tag.find_by(name: params[:name])
  	@posts = @tag.posts
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post.id)
    else
      render 'edit'
    end
  end

  def destroy
    if @post.destroy
      redirect_to user_path(current_user)
    end
  end

  private

  def set_post
  	@post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :used_at, :shop_name, :shop_address, :shop_map, :latitude, :longitude, :price_id, :url, :status, :user_id, images: [])
  end

end
