class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :ensure_correct_user, only: %i[edit update]
  before_action :ensure_guest_user, only: %i[edit update]

  def index
    @users = User.page(params[:page]).per(10)
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(10)
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'プロフィールを更新しました'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:icon, :name, :introduction)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    redirect_to user_path(current_user) unless @user == current_user
  end

  def ensure_guest_user
    user = User.find(params[:id])
    if user.name == 'guestuser'
      redirect_to user_path(current_user),
                  notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end
end
