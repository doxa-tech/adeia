class CreateAdeiaGroups < ActiveRecord::Migration
  def change
    create_table :adeia_groups do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
