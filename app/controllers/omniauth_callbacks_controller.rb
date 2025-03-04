class OmniauthCallbacksController < ApplicationController

  def line
    Rails.logger.debug "LINE_CLIENT_ID from ENV in controller: #{ENV['LINE_CLIENT_ID']}"
    basic_action
  end

  private
  
  def basic_action
    @omniauth = request.env["omniauth.auth"]
    if @omniauth.present?
      @user = User.find_or_initialize_by(provider: @omniauth["provider"], uid: @omniauth["uid"])
      if @user.email.blank?
        email = @omniauth["info"]["email"] ? @omniauth["info"]["email"] : "#{@omniauth["uid"]}-#{@omniauth["provider"]}@example.com"
        @user = current_user || User.create!(
        provider: @omniauth["provider"], 
        uid: @omniauth["uid"], 
        email: email, 
        name: @omniauth["info"]["name"], 
        password: Devise.friendly_token[0, 20], 
        image: @omniauth["info"]["image"]
        )
        
      end
      @user.set_values(@omniauth)
      sign_in(:user, @user)
    end
    #ログイン後のflash messageとリダイレクト先を設定
    if @user.profile.id?
      redirect_to confirm_user_path
    else
      redirect_to expendable_items_path
    end

  end

  def fake_email(uid, provider)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end
