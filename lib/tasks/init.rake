namespace :adeia do

  task permissions: :environment do
    elements = ENV['elements'].split(",") + %w(articles adeia/permissions adeia/tokens)
    owner = User.find_by_name!("admin")
    elements.each do |element|
      element = Adeia::Element.find_or_create_by!(name: element)
      Adeia::Permission.find_or_create_by!(element: element, owner: owner, permission_type: "all_entries", read_right: true, create_right: true, update_right: true, destroy_right: true)
    end
  end

end
