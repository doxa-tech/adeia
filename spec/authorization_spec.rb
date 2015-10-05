require 'rails_helper'

module Adeia

  describe Authorization do

    it "does not allow a visitor without a token" do
      authorization = Authorization.new("admin/articles", "new", nil, nil, nil)
      expect { authorization.authorize! }.to raise_error LoginRequired
    end

    it "does not allow a visitor with a valid token" do
      permission = create(:permission, element_name: "admin/articles", create_right: true)
      token = create(:token, permission: permission).token
      authorization = Authorization.new("admin/articles", "new", token, nil, nil)
      expect { authorization.authorize! }.not_to raise_error
    end

  end

end