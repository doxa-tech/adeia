require 'rails_helper'

module Adeia

  describe Authorization do
    let(:user) { mock_model(User) }

    it "does not allow a visitor without a token" do
      authorization = Authorization.new("admin/articles", "new", nil, nil, nil)
      expect { authorization.authorize! }.to raise_error LoginRequired
    end

    it "allows a visitor with a valid token" do
      permission = create(:permission, create_right: true)
      token = create(:token, permission: permission).token
      authorization = Authorization.new("admin/articles", "new", token, nil, nil)
      expect { authorization.authorize! }.not_to raise_error
    end

    it "does not allow a user without a permission" do
      authorization = Authorization.new("admin/articles", "new", nil, nil, user)
      expect { authorization.authorize! }.to raise_error AccessDenied
    end

    it "does not allow a user with a wrong permission" do
      create(:permission, owner: user, read_right: true, update_right: true, destroy_right: true)
      authorization = Authorization.new("admin/articles", "new", nil, nil, user)
      expect { authorization.authorize! }.to raise_error AccessDenied
    end

    context "with read permission" do

      it "allows the user in the index action" do
        create(:permission, owner: user, read_right: true)
        authorization = Authorization.new("admin/articles", "index", nil, nil, user)
        expect { authorization.authorize! }.not_to raise_error
      end

      it "allows the user in the show action" do
        create(:permission, owner: user, read_right: true)
        authorization = Authorization.new("admin/articles", "show", nil, nil, user)
        expect { authorization.authorize! }.not_to raise_error
      end

    end

  end

end