class RelationshipsController < ApplicationController
  before_action :authenticate_user!, except: %i[followings followers]
  before_action :set_follow

  def create
    current_user.follow(@user)
    redirect_to request.referer
  end

  def destroy
    current_user.unfollow(@user)
    redirect_to request.referer
  end

  def followings
    @users = @user.followings.page(params[:page]).per(10)
  end

  def followers
    @users = @user.followers.page(params[:page]).per(10)
  end

  private

  def set_follow
    @user = User.find(params[:user_id])
  end
end
