# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  account         :string(255)      not null
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
#  index_users_on_account  (account)
#  index_users_on_email    (email) UNIQUE
#  index_users_on_phone    (phone) UNIQUE
#

class User < ApplicationRecord
  enum role: [:normal, :admin]
  has_secure_password
  before_validation { (self.account = account.to_s.downcase) && (self.password = password.to_s.strip) }
  validates :account, presence: true, exclusion: { in: %w[admin administrator super superuser] }
  validates :password, presence: true, length: { minimum: 6 }, allow_blank: false

  # 修改 knock 查询用户的默认字段
  def self.from_token_request(request)
    # Returns a valid user, `nil` or raise `Knock.not_found_exception_class_name`
    # e.g.
    account = request.params['auth'] && request.params['auth']['account']
    find_by account: account
  end

  def self.admin?
    role == 'admin'
  end
end
