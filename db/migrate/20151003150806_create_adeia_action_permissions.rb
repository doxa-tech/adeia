class CreateAdeiaActionPermissions < ActiveRecord::Migration
  def change
    create_table :adeia_action_permissions do |t|
      t.references :action, index: true, foreign_key: true
      t.references :permission, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
