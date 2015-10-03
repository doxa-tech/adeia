# This migration comes from adeia (originally 20151003150524)
class CreateAdeiaTokens < ActiveRecord::Migration
  def change
    create_table :adeia_tokens do |t|
      t.string :token
      t.boolean :valid
      t.references :permission, index: true, foreign_key: true
      t.date :exp_at

      t.timestamps null: false
    end
  end
end
