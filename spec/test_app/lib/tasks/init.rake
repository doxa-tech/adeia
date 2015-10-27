namespace :init do

  desc "Create a user"
  task user: :environment do
    User.create!(name: "admin", password: "12341", password_confirmation: "12341")
  end

end
