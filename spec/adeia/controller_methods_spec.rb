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
        sign_in_user
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
        sign_in_user
        expect{ get :index }.not_to raise_error
      end

    end

    describe "#can?" do

      context "with a controller provided" do

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
          sign_in_user
          create(:permission, owner: @user, element_name: "articles", read_right: true)
          get :index
          expect(assigns(:can)).to be true
        end
      end

      context "with a resource provided" do

        controller do
          def index
            @article = Article.create(title: "Rspec tests", content: "Lorem ipsum", id: 100)
            @can = can? :read, @article
            render nothing: true
          end
        end

        it "guesses the element from the resource" do
          sign_in_user
          create(:permission, owner: @user, element_name: "articles", type_name: "on_entry", resource_id: 100, read_right: true)
          get :index
          expect(assigns(:can)).to be true
        end
      end

      context "with a resource provided and a controller with a different name" do

        controller do
          def index
            @article = Article.create(title: "Rspec tests", content: "Lorem ipsum", id: 100)
            @can = can? :read, "letters", @article
            render nothing: true
          end
        end

        it "returns true when the user is authorized" do
          sign_in_user
          create(:permission, owner: @user, element_name: "letters", type_name: "on_entry", resource_id: 100, read_right: true)
          get :index
          expect(assigns(:can)).to be true
        end

      end

      context "with a resource and a namespace" do

        controller do
          def index
            @article = Article.create(title: "Rspec tests", content: "Lorem ipsum", id: 100)
            @can = can? :read, [:admin, @article]
            render nothing: true
          end
        end

        it "guesses an namespaced element from the resource" do
          sign_in_user
          create(:permission, owner: @user, element_name: "admin/articles", type_name: "on_entry", resource_id: 100, read_right: true)
          get :index
          expect(assigns(:can)).to be true
        end
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
        sign_in_user
        create(:permission, owner: @user, element_name: "articles", type_name: "on_ownerships", read_right: true)
        get :index
        expect(assigns(:rights)).to be true
      end

    end

  end
end