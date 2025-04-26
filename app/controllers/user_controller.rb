class UserController < ApplicationController

  before_action :authenticate_user! # 未ログイン時にアクセスできい

  def new
    @user = current_user
    @profile = Profile.new
  end

  def update_or_create
    # プロフィールがあった場合のアップデートとなかった場合の新規作成(引数はオムニオーチにて作成)
    @profile = current_user.profile || current_user.create_profile!(unique_id: SecureRandom.hex(4), has_partner: false)
    @profile.assign_attributes(
      has_partner: params[:profile]&.dig(:has_partner) || false,
      unique_id: @profile&.unique_id || SecureRandom.hex(4),
      friend_requests: params[:profile][:friend_requests] || [],
      friends: params[:profile][:friends] || [],
      birth_year: params[:profile][:birth_year],
      birth_month: params[:profile][:birth_month],
      birth_day: params[:profile][:birth_day]
    )   
    # 生年月日を１つにまとめる
    birth_year  = params[:profile][:birth_year].to_i
    birth_month = params[:profile][:birth_month].to_i
    birth_day   = params[:profile][:birth_day].to_i
    if Date.valid_date?(birth_year, birth_month, birth_day)
      @profile.birthdate = Date.new(birth_year, birth_month, birth_day)
    end
    @profile.save # 一応

    if @profile.save
      redirect_to confirm_user_path
    else
      render :new
    end

  end
  # 確認ページ
  def confirm
    @profile = current_user.profile || current_user.create_profile!(unique_id: SecureRandom.hex(4), has_partner: false)
  end

  def confirm_messes
    @profile = current_user.profile
    # 確認ボタン押したら、プロフィールテーブルcompleted: true
    if @profile.update(completed: true)
      redirect_to thank_you_path, notice:
    else
      redirect_to mypage_path
    end
  end
  
  def thank_you
  end
end