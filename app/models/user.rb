# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)      not null
#  password_digest :string(255)      not null
#  phone           :string(255)
#  email           :string(255)
#  nick            :string(255)
#  role            :integer          default("normal")
#  last_login      :datetime
#  deleted         :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_phone     (phone) UNIQUE
#  index_users_on_username  (username)
#

class User < ApplicationRecord
  enum role: [:normal, :admin]
  has_secure_password
  before_validation { (self.username = username.to_s.downcase) && (self.password = password.to_s.strip) }
  validates :username, presence: true, exclusion: { in: %w[admin administrator super superuser] }
  validates :password, presence: true, length: { minimum: 6 }, allow_blank: false

  # 修改 knock 查询用户的默认字段
  def self.from_token_request(request)
    # Returns a valid user, `nil` or raise `Knock.not_found_exception_class_name`
    username = request.params['auth'] && request.params['auth']['username']
    find_by(username: username)
  end

  # 从 token 中获取有效载荷
  def self.from_token_payload(payload)
    # Returns a valid user, `nil` or raise
    find(payload['sub'])
  end

  def self.admin?
    role == 'admin'
  end
end
