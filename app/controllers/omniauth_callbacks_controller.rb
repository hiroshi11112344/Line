class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  # class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    Rails.logger.debug "LINE_CLIENT_ID from ENV in controller: #{ENV['LINE_CLIENT_ID']}"
    basic_action
    Rails.logger.info "LINE Auth Data: #{request.env['omniauth.auth'].inspect}"
  end

  private

  def basic_action
    @omniauth = request.env["omniauth.auth"]
    unless @omniauth
      Rails.logger.error "OmniAuth Auth Hash is NIL!"
      redirect_to root_path, alert: "LINE認証に失敗しました。"
      return
    end
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
      #　無限ループを防ぐ
      if request.path != confirm_user_path
        if @user.profile&.id.present?
          redirect_to confirm_user_path
        else
          redirect_to expendable_items_path
        end
      end
    end
  end

  def fake_email(uid, provider)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end
