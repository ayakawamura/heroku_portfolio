class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_favorite, only: %i[create destroy]

  def create
    favorite = current_user.favorites.new(post_id: @post.id)
    favorite.save
  end

  def destroy
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite.destroy
  end

  def index
    # current_userのお気に入りのpost_idカラムを取得
    favorites = Favorite.where(user_id: current_user.id).pluck(:post_id)
    all_favorites = Post.find(favorites)
    @all_favorites = Kaminari.paginate_array(all_favorites).page(params[:page]).per(9)
  end

  private

  def set_favorite
    @post = Post.find(params[:post_id])
  end
end
