module Adeia
  class GuestUser < User

    def nil?
      true
    end

    def blank?
      true
    end

    def present?
      false
    end

  end
end
