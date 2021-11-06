class CreateAdeiaElements < ActiveRecord::Migration[4.2]
  def change
    create_table :adeia_elements do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
