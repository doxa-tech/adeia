module Adeia

  class Error < StandardError; end

  class LoginRequired < Error

    def to_s
      I18n.t("exceptions.messages.login_required")
    end

  end

  class AccessDenied < Error

    def to_s
      I18n.t("exceptions.messages.access_denied")
    end

  end

  class MissingParams < Error

    def initialize(params)
      @params = params
    end

    def to_s
      I18n.t("exceptions.messages.missing_params", params: @params)
    end

  end

  class MissingUserModel < Error

    def to_s
      I18n.t("exceptions.messages.missing_user_model", params: @params)
    end

  end

end