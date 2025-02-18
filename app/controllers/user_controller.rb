class UserController < ApplicationController

  before_action :authenticate_user! # 未ログイン時にアクセスできい

  def new
    @user = current_user
    @profile = Profile.new
    
  end

  def create
    @profile = current_user.build_profile(profile_params) # 🔹 `Profile` を新規作成

    # LINEの画像を Active Storage (`profile_image`) に保存
    #profile_image が未設定で、User.image (LINEの画像) がある場合のみ、profile_image に保存
    if @profile.profile_image.blank? && current_user.image.present?
      downloaded_image = URI.open(current_user.image) #  画像をダウンロード
      @profile.profile_image.attach(io: downloaded_image, filename: "line_profile.jpg", content_type: "image/jpeg") # 🔹 Active Storage に保
    end

    if @user.update(user_params)
      redirect_to root_path, notice: "プロフィール作成"
    else
      flash.now[:alert] = "プロフィール失敗しました (あってもなくても良い)"
      render :new, status: :unprocessable_entity
    end
  end

  private
  def profile_params
    params.require(:profile).permit(:birthdate, :profile_image)
    # params.require(:profile).permit(:name, :email) もし名前以外を追加したい場合は隣に値を追加　例えばメールの場合はこう書く、これからフォームウィズの方でも追加していくと良い

  end
  

end