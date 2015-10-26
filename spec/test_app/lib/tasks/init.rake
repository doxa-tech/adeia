namespace :init do

  desc "Create a user"
  task user: :environment do
    User.create!(name: "admin", password: "12341", password_confirmation: "12341")
  end

  task permissions: :environment do
    owner = User.find_by_name!("admin")
    %w(articles adeia/permissions).each do |element|
      element = Adeia::Element.find_or_create_by!(name: element)
      Adeia::Permission.find_or_create_by!(element: element, owner: owner, permission_type: "all_entries", read_right: true, create_right: true, update_right: true, destroy_right: true)
    end
  end

end
