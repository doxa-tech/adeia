require "rails_helper"

RSpec.describe "#redirect_back_or", :type => :feature do

  let(:user) { create(:user) }
  
  it "stores the location when authorizing" do
    create(:permission, element_name: "articles", read_right: true, owner: user)
    visit "/articles" # redirect to login path
    fill_in "Name", with: user.name
    fill_in "Password", with: "12341"
    click_button "Login"
    expect(page.current_path).to eq "/articles"
  end

  it "stores the location when requiring login" do
    visit "/comments" # redirect to login path
    fill_in "Name", with: user.name
    fill_in "Password", with: "12341"
    click_button "Login"
    expect(page.current_path).to eq "/comments"
  end

  it "doesn't store the location if the HTTP method isn't GET" do
    visit "/comments/new"
    click_button "Create a comment" # redirect to login path
    fill_in "Name", with: user.name
    fill_in "Password", with: "12341"
    click_button "Login"
    expect(page.current_path).to eq "/"
  end
end