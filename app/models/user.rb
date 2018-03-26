class User < ApplicationRecord
  has_secure_password
  validates :account, presence: true
end
