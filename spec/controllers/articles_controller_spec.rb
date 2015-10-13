require "rails_helper"

describe ArticlesController, :type => :controller do
  before(:each) do
    @user = User.create!(name: "admin", password: "12341", password_confirmation: "12341")
    sign_in @user
  end

  describe "GET #index" do

    describe "response" do
      before(:each) { create(:permission, element_name: "articles", read_right: true, owner: @user) }

      it "responds successfully" do
        get :index
        expect(response).to be_success
      end

      it "loads the records" do
        get :index
        expect(assigns(:articles)).not_to be_nil
      end

    end

    describe "records loading" do

      context "with an 'all_entries' permission" do

        it "loads all the entries" do
          create(:permission, element_name: "articles", read_right: true, owner: @user)
          create_list(:article, 5)
          get :index
          expect(assigns(:articles)).to eq Article.all
        end

      end

      context "with an 'on_ownerships' permission" do
        before(:each) do
          create(:permission, element_name: "articles", type_name: "on_ownerships", read_right: true, owner: @user)
          @own_articles = create_list(:article, 5, user: @user)
          create_list(:article, 5)
        end

        it "loads the owned articles" do
          get :index
          expect(assigns(:articles)).to eq @own_articles
        end

        it "loads the owned articles and also the specific ones" do
          specific_article = create(:article)
          create(:permission, element_name: "articles", type_name: "on_entry", resource_id: specific_article.id, read_right: true, owner: @user)
          get :index
          expect(assigns(:articles)).to match_array(@own_articles << specific_article)
        end

      end

      context "with an 'on_entry' permission" do

        it "loads the specific articles" do
          first_article = create(:article)
          second_article = create(:article)
          create_list(:article, 5)
          create(:permission, element_name: "articles", type_name: "on_entry", resource_id: first_article.id, read_right: true, owner: @user)
          create(:permission, element_name: "articles", type_name: "on_entry", resource_id: second_article.id, read_right: true, owner: @user)
          get :index
          expect(assigns(:articles)).to match_array [first_article, second_article]
        end

      end

    end

    describe "GET #show" do
      before(:each) do
        create(:permission, element_name: "articles", read_right: true, owner: @user)
        @article = create(:article)
      end

      it "responds successfully" do
        get :show, id: @article.id
        expect(response).to be_success
      end

      it "loads the record" do
        get :show, id: @article.id
        expect(assigns(:article)).to eq @article
      end

    end

    describe "GET #new" do
      before(:each) { create(:permission, element_name: "articles", create_right: true, owner: @user) }

      it "responds successfully" do
        get :new
        expect(response).to be_success
      end

    end

    describe "GET #edit" do
      before(:each) do
        create(:permission, element_name: "articles", update_right: true, owner: @user)
        @article = create(:article)
      end

      it "responds successfully" do
        get :edit, id: @article.id
        expect(response).to be_success
      end

      it "loads the record" do
        get :edit, id: @article.id
        expect(assigns(:article)).to eq @article
      end

    end

  end
end