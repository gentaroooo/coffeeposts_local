class PostsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :edit, :update,]

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.page(params[:page]).per(7).reverse_order
    @comment = Comment.new
  end

  def index
    @posts = Post.order(id: :desc).page(params[:page]).per(6)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url

    else
      @posts = current_user.feed_posts.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render :new
    end
  end

  def destroy
    @post.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    if @post.update(post_params)
      flash[:success] = 'メッセージは正常に更新されました'
      redirect_to root_url
    else
      flash.now[:danger] = 'メッセージは更新されませんでした'
      render :edit
    end
  end


  private

  def post_params
    params.require(:post).permit(:content, :image, :post_id)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    unless @post
      redirect_to root_url
    end
  end
end

