class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.find_and_auth(params = {})
    admin = self.find_for_database_authentication email: params[:email]
    if admin
      admin.auth params
    else
      nil
    end
  end

  def auth(params = {})
    if valid_password?(params[:password])
      if params[:remember_me]
        remember_me!
      else
        forget_me!
      end
      self
    else
      nil
    end
  end
end
