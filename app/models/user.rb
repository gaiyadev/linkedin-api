class User < ApplicationRecord
    has_secure_password

    has_many :posts, dependent: :destroy

    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP } , length: { minimum: 3 }
    validates :password, presence: true, length: { minimum: 6 }, confirmation: true
    validates :password_confirmation, presence: true
    validates :surname, presence: true
    validates :othername, presence: true

    # before_save   :downcase_email

end
