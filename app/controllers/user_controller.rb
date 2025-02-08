class UserController < ApplicationController

  before_action :authenticate_user! # 未ログイン時にアクセスできい

  def new
    @user = current_user
  end

  def create
    @user = current_user
    if @user.update(user_params)
      redirect_to root_path, notice: "プロフィール作成"
    else
      flash.now[:alert] = "プロフィール失敗しました (あってもなくても良い)"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # 新規登録するときに登録されてきたデータをまず取得する
    params.require(:user).permit(:name)
    # params.require(:user).permit(:name, :email) もし名前以外を追加したい場合は隣に値を追加　例えばメールの場合はこう書く、これからフォームウィズの方でも追加していくと良い

  end
  

end