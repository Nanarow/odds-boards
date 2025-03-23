class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.references :creator, null: false, foreign_key: { to_table: "users" }
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
