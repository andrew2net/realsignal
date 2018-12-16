# frozen_string_literal: true

# User model.
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :subscriptions, inverse_of: :user
  has_one :address, inverse_of: :user

  def full_name
    "#{first_name} #{last_name}"
  end

  def token_generate
    iat = Time.now.to_i
    payload = { data: { user_id: id }, iat: iat }
    update_attribute :token_iat, iat
    JWT.encode payload, Figaro.env.api_secret, 'HS256'
  end
end
