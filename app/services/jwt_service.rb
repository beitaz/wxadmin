class JwtService
  def self.encode(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
  end

  def self.decode(token)
    # body, header = JWT.decode(...) 忽略返回结果中的头部
    body, = JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
    # 将 JWT 返回的 Key-string 转换为 Hash
    begin
      HashWithIndifferentAccess.new(body)
    rescue JWT::ExpiredSignature => _e
      # TODO: 暂时不抛出异常,而是什么都不做
      # raise e
      nil
    end
    nil
  end
end
