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
      before(:each) { create(:permission, owner: user, read_right: true) }

      it "allows the user in the index action" do
        authorization = Authorization.new("admin/articles", "index", nil, nil, user)
        expect { authorization.authorize! }.not_to raise_error
      end

      it "allows the user in the show action" do
        authorization = Authorization.new("admin/articles", "show", nil, nil, user)
        expect { authorization.authorize! }.not_to raise_error
      end

    end

    context "with create permission" do
      before(:each) { create(:permission, owner: user, create_right: true) }

      it "allows the user in the new action" do
        authorization = Authorization.new("admin/articles", "new", nil, nil, user)
        expect { authorization.authorize! }.not_to raise_error
      end

      it "allows the user in the create action" do
        authorization = Authorization.new("admin/articles", "create", nil, nil, user)
        expect { authorization.authorize! }.not_to raise_error
      end

    end

    context "with update permission" do
      before(:each) { create(:permission, owner: user, update_right: true) }

      it "allows the user in the edit action" do
        authorization = Authorization.new("admin/articles", "edit", nil, nil, user)
        expect { authorization.authorize! }.not_to raise_error
      end

      it "allows the user in the update action" do
        authorization = Authorization.new("admin/articles", "update", nil, nil, user)
        expect { authorization.authorize! }.not_to raise_error
      end

    end

    context "with destroy permission" do
      before(:each) { create(:permission, owner: user, destroy_right: true) }

      it "allows the user in the destroy action" do
        authorization = Authorization.new("admin/articles", "destroy", nil, nil, user)
        expect { authorization.authorize! }.not_to raise_error
      end

    end

    context "with an specific action permission" do
      before(:each) { create(:permission, owner: user, action: "share") }

      it "allows the user in the destroy action" do
        authorization = Authorization.new("admin/articles", "share", nil, nil, user)
        expect { authorization.authorize! }.not_to raise_error
      end

    end

    context "with an 'on ownership' permission" do
      let!(:permission) { create(:permission, owner: user, update_right: true, type_name: "on_ownerships") }

      it "does not allow a visitor" do
        token = create(:token, permission: permission).token
        authorization = Authorization.new("admin/articles", "edit", token, nil, nil)
        expect { authorization.authorize! }.to raise_error AccessDenied
      end

      it "does not allow when no resource is provided" do
        authorization = Authorization.new("admin/articles", "edit", nil, nil, user)
        expect { authorization.authorize! }.to raise_error AccessDenied
      end

      it "does not allow when the resource is not his" do
        foreign_user = mock_model(User)
        article = mock_model(Article, user: foreign_user)
        authorization = Authorization.new("admin/articles", "edit", nil, article, user) 
        expect { authorization.authorize! }.to raise_error AccessDenied
      end

      it "allows the user" do
        article = mock_model(Article, user: user)
        authorization = Authorization.new("admin/articles", "edit", nil, article, user)
        expect { authorization.authorize! }.not_to raise_error
      end

    end

    context "with an 'on entry' permission" do

      it "does not allow when there is no resource" do
        permission = create(:permission, owner: user, update_right: true, type_name: "on_entry", resource_id: 1)
        authorization = Authorization.new("admin/articles", "edit", nil, nil, user)
        expect { authorization.authorize! }.to raise_error AccessDenied
      end

      it "does not allow when the resource is not allowed" do
        article = mock_model(Article)
        permission = create(:permission, owner: user, update_right: true, type_name: "on_entry", resource_id: article.id + 1)
        authorization = Authorization.new("admin/articles", "edit", nil, article, user)
        expect { authorization.authorize! }.to raise_error AccessDenied
      end

      it "allows the user" do
        article = mock_model(Article)
        permission = create(:permission, owner: user, update_right: true, type_name: "on_entry", resource_id: article.id)
        authorization = Authorization.new("admin/articles", "edit", nil, article, user)
        expect { authorization.authorize! }.not_to raise_error
      end

    end

    context "with an inherited permission" do

      it "allows the user" do
        group = create(:user_group, user: user).group
        permission = create(:permission, owner: group, create_right: true)
        authorization = Authorization.new("admin/articles", "new", nil, nil, user)
        expect { authorization.authorize! }.not_to raise_error
      end

    end

  end

end