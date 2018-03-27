class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :phone, :email, :nick, :role, :last_login, :deleted
end
