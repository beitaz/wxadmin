# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  account         :string(255)      not null
#  password_digest :string(255)      not null
#  phone           :string(255)
#  email           :string(255)
#  username        :string(255)
#  admin           :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  has_secure_password
  validates :account, presence: true
end
