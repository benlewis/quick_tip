class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :client
  attr_accessible :email, :password, :password_confirmation, :remember_me, :client, :super_admin, :client_id

  validate :super_admin_client

  def super_admin_client
    errors.add(:super_admin, "Super Admins can't have clients") if super_admin? && client
    errors.add(:client, "Non super-admins must have a client") if !super_admin? && client.nil?
  end

end
