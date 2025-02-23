class UserController < ApplicationController

  before_action :authenticate_user! # 未ログイン時にアクセスできい

  def new
    @user = current_user
    @profile = Profile.new
    
  end

  def create
    @profile = Profile.new(
      user_id: current_user.id,  # に紐付ける
      profile_image: params[:profile][:profile_image],
      has_partner: false, #パートナー（恋人）がいるかどうか
      unique_id: SecureRandom.hex(4), #ランダムで生成された一意の識別ID
      friend_requests: [], #友達申請
      friends: [] # 友達リスト
    )
  
    # 🔹 生年月日を `birthdate` に変換してセット
    birth_year = params.dig(:profile, :birth_year).to_i
    birth_month = params.dig(:profile, :birth_month).to_i
    birth_day = params.dig(:profile, :birth_day).to_i
  
    if birth_year > 0 && birth_month > 0 && birth_day > 0
      @profile.birthdate = Date.new(birth_year, birth_month, birth_day)
    end
  
    # 🔹 LINEの `current_user.image` を `profile_image` に保存（`profile_image` が空なら）
    if @profile.profile_image.blank? && current_user.image.present?
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