class GroupUserTable < BaseTable

  def model
    Adeia::GroupUser
  end

  def attributes
    [{ user: :name }, { group: :name }]
  end

end
