FactoryBot.define do

  factory :token, class: "Adeia::Token" do
    token { SecureRandom.urlsafe_base64 }
    is_valid { true }
    exp_at { 1.month.from_now }
  end

  factory :permission, class: "Adeia::Permission" do
    transient do
      element_name { 'admin/articles' }
      group_name { 'admin' }
      type_name { 'all_entries' }
      action { 'share' }
    end
    element { Adeia::Element.find_or_create_by(name: element_name) }
    owner { Adeia::Group.find_by_name(group_name) || create(:group, name: group_name) }
    
    permission_type { Adeia::Permission.permission_types[type_name] }

    resource_id { nil }
    read_right { false }
    create_right { false }
    update_right { false }
    destroy_right { false }
    actions {[ Adeia::Action.find_or_create_by(name: action) ]}
  end

  factory :group, class: "Adeia::Group" do
    name { "admin" }
  end

  factory :user_group, class: "Adeia::GroupUser" do
    group { Adeia::Group.find_by_name("admin") || create(:group) }
    user { nil }
  end

  ### Test App factories

  factory :user do
    name { "admin" }
    password { "12341" }
    password_confirmation { "12341" }
  end
  
  factory :article do
    title { "Des ours meurt chaque année" }
    content { "Chaque année, plus de 1000 ourse blancs meurt" }
    user { User.find_by_name("editor") || create(:user, name: "editor") }
  end

end