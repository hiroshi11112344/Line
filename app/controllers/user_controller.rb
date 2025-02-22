class UserController < ApplicationController

  before_action :authenticate_user! # 未ログイン時にアクセスできい

  def new
    @user = current_user
    @profile = Profile.new
    
  end

  def create

    #プロフィールテーブルにある、ランダムIDカラム作成予定

    # Profile を新規作成
    @profile = current_user.build_profile(profile_params) 
    # LINEの名前を profile.nameに追加
    @profile.name = current_user.name

    # LINEの画像を Active Storage (`profile_image`) に保存
    #profile_image が未設定で、User.image (LINEの画像) がある場合のみ、profile_image に保存
    if @profile.profile_image.blank? && current_user.image.present?
      #  画像をダウンロード
      downloaded_image = URI.open(current_user.image)
      # Active Storage に保存
      @profile.profile_image.attach(io: downloaded_image, filename: "line_profile.jpg", content_type: "image/jpeg")
    end

    # 生年月日birthdate を birth_year, birth_month, birth_day から作成
    if params[:profile][:birth_year].present? && params[:profile][:birth_month].present? && params[:profile][:birth_day].present?
      @profile.birthdate = Date.new(params[:profile][:birth_year].to_i, params[:profile][:birth_month].to_i, params[:profile][:birth_day].to_i)
    end

    # ここに確認画面に飛ばすif文作成予定
  end

  private
  def profile_params
    params.require(:profile).permit(:name,:profile_image)
    # params.require(:profile).permit(:name, :email) もし名前以外を追加したい場合は隣に値を追加　例えばメールの場合はこう書く、これからフォームウィズの方でも追加していくと良い

  end
end