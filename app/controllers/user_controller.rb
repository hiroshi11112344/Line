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
      friends: params[:profile][:friends] || []
    )   
    # 生年月日を `birthdate` に変換してセット
    birth_year = params.dig(:profile, :birth_year).to_i
    birth_month = params.dig(:profile, :birth_month).to_i
    birth_day = params.dig(:profile, :birth_day).to_i
    # 生年月日を１つにまとめる
    if birth_year > 0 && birth_month > 0 && birth_day > 0
      @profile.birthdate = Date.new(birth_year, birth_month, birth_day)
    end

    @profile.save # 一応

    if @profile.save
      redirect_to confirm_user_path
    else
      flash.now[:alert] = @profile.errors.full_messages.join(", ")
       render :new
    end

  end

  def confirm
    @profile = current_user.profile || current_user.create_profile!(unique_id: SecureRandom.hex(4), has_partner: false)
  end
  
end