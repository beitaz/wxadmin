class UserSerializer < ActiveModel::Serializer
  attributes :id, :account, :phone, :email, :nick, :role, :last_login, :deleted
end
