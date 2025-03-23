class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.references :creator, null: false, foreign_key: { to_table: "users" }
      t.string :name

      t.timestamps
    end
  end
end
