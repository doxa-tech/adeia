require 'rails_helper'

module Adeia
  describe "ControllerMethods", type: :controller do

    describe "#require_login!" do

      controller do
        def index
          require_login!
          render nothing: true
        end
      end

      it "requires to be logged in" do
        expect { get :index }.to raise_error Adeia::LoginRequired
      end

      it "responds successfully when logged in" do
        @user = create(:user)
        sign_in @user
        expect{ get :index }.not_to raise_error
      end

    end

    describe "::require_login" do

      controller do
        require_login

        def index
          render nothing: true
        end
      end

      it "requires to be logged in" do
        expect { get :index }.to raise_error Adeia::LoginRequired
      end

      it "responds successfully when logged in" do
        @user = create(:user)
        sign_in @user
        expect{ get :index }.not_to raise_error
      end

    end

    describe "#can?" do

      controller do
        def index
          @can = can? :read, "articles"
          render nothing: true
        end
      end

      it "returns false when the user is not authorized" do
        get :index
        expect(assigns(:can)).to be false
      end

      it "caches the result" do
        get :index
        expect(assigns(:can_articles_read)).to be false
      end

      it "returns true when the user is authorized" do
        @user = create(:user)
        sign_in @user
        create(:permission, owner: @user, element_name: "articles", read_right: true)
        get :index
        expect(assigns(:can)).to be true
      end

    end

     describe "#rights?" do

      controller do
        def index
          @rights = rights? :read, "articles"
          render nothing: true
        end
      end

      it "returns false when the user is not authorized" do
        get :index
        expect(assigns(:rights)).to be false
      end

      it "caches the result" do
        get :index
        expect(assigns(:rights_articles_read)).to be false
      end

      it "returns true when the user has at least one right" do
        @user = create(:user)
        sign_in @user
        create(:permission, owner: @user, element_name: "articles", type_name: "on_ownerships", read_right: true)
        get :index
        expect(assigns(:rights)).to be true
      end

    end

  end
end