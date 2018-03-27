class AuthenticateUserCommand < BaseCommand
  private

    attr_reader :account, :password

    def initialize(account, password)
      @account = account
      @password = password
    end

    def user
      @user ||= User.find_by(account: account)
    end

    def password_valid?
      user && user.authenticate(password)
    end

    def payload
      if password_valid?
        @result = JwtService.encode(contents)
      else
        errors.add(:base, 'Invalid Credentials')
      end
    end

    def contents
      {
        uid: user.id,
        expiration: 24.hours.from_now.to_i
      }
    end
end
