namespace :adeia do

  desc "Create the elements and a group with all the privileges"
  task permissions: :environment do
    elements =  %w(adeia/permissions adeia/tokens adeia/groups)
    elements.concat(ENV["elements"].split(",").map { |e| e.strip }) if ENV["elements"].present?
    owner = Adeia::Group.find_or_create_by!(name: "superadmin")
    elements.each do |element|
      Adeia::Permission.find_or_add_by!(owner: owner, element: element, full: true)
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

  desc "Create groups"
  task groups: :environment do
    groups = ENV["groups"].split(",").map { |e| e.strip } if ENV["groups"].present?
    if groups.present?
      groups.each { |group| Adeia::Group.create!(name: group) }
    end
  end

end
