class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:line, :facebook]

  def email_required?
    false
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource = nil)
    user = User.where(uid: auth.uid, provider: auth.provider).first

    unless user
      user = User.create(
        uid: auth.uid,
        provider: auth.provider,
        name: auth.info.name,
        profile_img_url: auth.info.image,
        email: auth.info.email,
        password: Devise.friendly_token[0, 20]
      )
    end

    user
  end

  def self.find_for_line_oauth(auth, signed_in_resouce = nil)
    user = User.where(uid: auth.uid, provider: auth.provider).first

    unless user
      user = User.create(
        uid: auth.uid,
        provider: auth.provider,
        name: auth.info.name,
        profile_img_url: auth.info.image,
        email: '',
        password: Devise.friendly_token[0, 20]
      )
    end

    user
  end
end
