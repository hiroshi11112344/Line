class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line] # この1行を追加
         # TwitterやFacebookログインなども導入する場合は %i[line] の配列に追加 してください。　
        # 例： :omniauth_providers: %i[line twitter facebook]）
        def social_profile(provider)
          social_profiles.select { |sp| sp.provider == provider.to_s }.first
        end

        def set_values(omniauth)
          return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
          credentials = omniauth["credentials"]
          info = omniauth["info"]
      
          access_token = credentials["refresh_token"]
          access_secret = credentials["secret"]
          credentials = credentials.to_json
          name = info["name"]
          self.image = omniauth["info"]["image"] if self.image.blank? # 🔹 LINEのプロフィール画像があれば保存
          self.save!
          
        end
      
        def set_values_by_raw_info(raw_info)
          self.raw_info = raw_info.to_json
          self.save!
        end
  has_one :profile, dependent: :destroy # 🔹 1対1の関係（User は 1つの Profile を持つ）
end
