class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_accessor :identifier

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :username, presence: true, length: { maximum: 50 }
  validates :username, format: { with: /\A[a-zA-Z0-9_\.]*\z/, message: "can only contain letters, numbers, dots and underscores" }
  validates :bio, length: { maximum: 500 }, allow_blank: true

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    identifier = conditions.delete(:identifier)
    where(conditions).where([
      "lower(username) = :value OR lower(email) = :value",
      { value: identifier.downcase }
    ]).first
  end
end
