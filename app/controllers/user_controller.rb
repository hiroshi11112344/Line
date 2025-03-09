class UserController < ApplicationController

  before_action :authenticate_user! # 未ログイン時にアクセスできい

  def new
    @user = current_user
    @profile = Profile.new
    
  end

  def update_or_create

    @profile = current_user.profile || Profile.new(user_id: current_user.id)

    @profile.assign_attributes(
      has_partner = params[:profile]&.dig(:has_partner) || false
      unique_id: @profile.unique_id || SecureRandom.hex(4),
      friend_requests: params[:profile][:friend_requests] || [],
      friends: params[:profile][:friends] || []
    )   
    # 🔹 生年月日を `birthdate` に変換してセット
    birth_year = params.dig(:profile, :birth_year).to_i
    birth_month = params.dig(:profile, :birth_month).to_i
    birth_day = params.dig(:profile, :birth_day).to_i
  
    if birth_year > 0 && birth_month > 0 && birth_day > 0
      @profile.birthdate = Date.new(birth_year, birth_month, birth_day)
    end
  
    # 🔹 LINEの `current_user.image` を `profile_image` に保存（`profile_image` が空なら）

    if params[:profile][:profile_image].present?
      @profile.profile_image.attach(params[:profile][:profile_image])
    elsif @profile.profile_image.blank? && current_user.image.present?
      downloaded_image = URI.open(current_user.image)
      @profile.profile_image.attach(io: downloaded_image, filename: "line_profile.jpg", content_type: "image/jpeg")
    end
  
    if @profile.save
      redirect_to confirm_user_path
    else
      flash.now[:alert] = @profile.errors.full_messages.join(", ")  # 🔹 エラーメッセージを表示
      puts "=== デバッグ情報 ==="
       puts "保存エラー: #{@profile.errors.full_messages}"
      puts "================="
       render :new
    end

  end

  def confirm
    @profile = current_user.profile
  end
  
end