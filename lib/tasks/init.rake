namespace :adeia do

  desc "Create the elements and a group with all the privileges"
  task permissions: :environment do
    elements =  %w(articles adeia/permissions adeia/tokens) + ENV.fetch("elements", []).split(",")
    owner = Adeia::Group.find_or_create_by!(name: "superadmin")
    elements.each do |element|
      element = Adeia::Element.find_or_create_by!(name: element)
      Adeia::Permission.find_or_create_by!(adeia_element_id: element.id, owner_id: owner.id, owner_type: "Adeia::Group",
       permission_type: "all_entries", read_right: true, create_right: true, update_right: true, destroy_right: true)
    end
  end

  desc "Add an user to the group with all the privileges"
  task superuser: :environment do
    errors = []
    errors << "Please provide an `user_id`: `rake adeia:superuser user_id=1`" unless ENV["user_id"].present?
    group = Adeia::Group.find_by_name("superadmin")
    errors << "Please first run `rake adeia:permissions`" if group.nil?
    if errors.empty?
      Adeia::GroupUser.create!(user_id: ENV["user_id"], adeia_group_id: group.id)
    else
      errors.each { |message| puts message }
    end
  end

end
