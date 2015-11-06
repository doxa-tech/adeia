module SpecLoginHelper
  def sign_in(user)
    request.cookies[:remember_token] = user.remember_token
    self.current_user = user
  end

  def current_user
    @current_user ||= User.users.find_by_remember_token(request.cookies[:remember_token])
  end

  def current_user=(user)
    @current_user = user
  end

  def sign_in_user
    @user = create(:user)
    sign_in @user
  end
end

RSpec.configure do |config|
  config.include SpecLoginHelper
end