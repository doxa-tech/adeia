require 'rails_helper'

module Adeia
  RSpec.describe Permission, type: :model do

    let(:user) { create(:user) }

    describe "#add" do

      it "creates a permission with default attributes" do
        permission = Permission.add!(owner: user, element: "adeia/permissions", read: true)
        expect(permission.owner).to eq user
        expect(permission.element.name).to eq "adeia/permissions"
        expect(permission.permission_type).to eq "all_entries"
        expect(permission.read_right).to be true
        expect(permission.create_right).to be false
        expect(permission.resource_id).to be_nil
        expect(permission.actions).to be_empty
      end

      it "creates a permission with good attributes" do
        permission = Permission.add!(owner: user, element: "adeia/permissions", type: "on_entry", read: true, resource_id: 1, actions: ["share"])
        expect(permission.permission_type).to eq "on_entry"
        expect(permission.read_right).to be true
        expect(permission.resource_id).to eq 1
        expect(permission.actions.first.name).to eq "share"
      end

      it "creates a permission with all the rights when using the full option" do
        permission = Permission.add!(owner: user, element: "adeia/permissions", full: true)
        expect(permission.read_right).to be true
        expect(permission.create_right).to be true
        expect(permission.update_right).to be true
        expect(permission.destroy_right).to be true
      end

    end

    describe "#find_or_add_by" do

      it "returns a permission when it already exists" do
        permission = Permission.add!(owner: user, element: "adeia/permissions", type: "on_entry", read: true, resource_id: 1, actions: ["share"])
        expect(Permission.find_or_add_by!(owner: user, element: "adeia/permissions", type: "on_entry")).to eq permission
      end

    end
  end
end
