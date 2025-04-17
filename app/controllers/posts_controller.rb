class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :ensure_correct_user, only: %i[edit update destroy]

  def new
    @post = Post.new
    @post.post_images.build
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    # 投稿ページからタグを取得、,で区切って配列にする
    tag_list = params[:post][:tag].split(',')
    if @post.save

      # APIでエンティティー取得
      entities = Language.get_data(post_params[:body])
      entities.each do |entity|
        @post.entities.create(name: entity)
      end

      # APIでタグ取得
      # 写真一枚ずつタグ取得
      @post.post_images.each do |post_image|
        # post.post_imageのimage_idカラムをvision.rbに渡す（post_imageモデルのattachmentがimageのため）
        api_tags = Vision.get_image_data(post_image.image)
        # tagを取り出して手入力したタグに追加　名前がカブらないようにする
        api_tags.each do |tag|
          tag_list << tag unless tag_list.include?(tag)
        end
      end
      @post.save_tags(tag_list)

      redirect_to post_path(@post), notice: '投稿しました'
    else
      render :new
    end
  end

  def index
    # いいね順が多いに並び替え
    posts = Post.includes(:favorited_users).sort { |a, b| b.favorited_users.size <=> a.favorited_users.size }
    # pagination使用
    @posts = Kaminari.paginate_array(posts).page(params[:page]).per(9)
    # タグは関連記事が多い順に表示
    @tags = Tag.all.sort { |a, b| b.posts.count <=> a.posts.count }
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @post_comment = PostComment.new
    post_comments = @post.post_comments.includes(:user).order('created_at DESC')
    # 新着の4件を表示
    @comments_latest = post_comments.first(4)
    # 4件を除くコメントを表示
    @comments_offset = post_comments.offset(4)
  end

  def edit
    @tag_list = @post.tags.pluck(:name).join(',')
  end

  def update
    tag_list = params[:post][:tag].split(',')

    if @post.update(post_params)
      # 既存エンティティーの削除と新規作成
      @post.entities.destroy_all
      entities = Language.get_data(post_params[:body])
      entities.each do |entity|
        @post.entities.create(name: entity)
      end

      @post.post_images.each do |post_image|
        api_tags = Vision.get_image_data(post_image.image)
        api_tags.each do |tag|
          tag_list << tag unless tag_list.include?(tag)
        end
      end
      @post.save_tags(tag_list)

      redirect_to post_path(@post), notice: '投稿を更新しました'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to user_path(current_user), notice: '投稿を削除しました'
  end

  def timeline
    @users = current_user.followings
    posts = Post.where(user_id: @users).order('created_at DESC')
    @posts = Kaminari.paginate_array(posts).page(params[:page]).per(9)
  end

  private

  def post_params
    params.require(:post).permit(:body, :address, :atitude, :longitude, post_images_images: [])
  end

  def ensure_correct_user
    @post = Post.find(params[:id])
    redirect_to user_path(current_user) unless @post.user_id == current_user.id
  end
end
