require 'rails_helper'

module Adeia

  describe Permission, type: :model do

    describe "validations" do

      it "is valid" do
        expect(build(:permission)).to be_valid
      end

      it "requires the presence of an owner" do
        expect(build(:permission, owner: nil)).to be_invalid
      end

      it "requires the presence of an element" do
        expect(build(:permission, element: nil)).to be_invalid
      end

      it "requires the presence of a type" do
        expect(build(:permission, permission_type: nil)).to be_invalid
      end

      it "requires a resource id when the permission is 'on entry'" do
        expect(build(:permission, type_name: "on_entry", resource_id: nil)).to be_invalid
      end

      it "requires a read, update or destroy right when the permission is 'on ownerships'" do
        expect(build(:permission, type_name: "on_ownerships", actions: [])).to be_invalid
      end

    end

  end

end