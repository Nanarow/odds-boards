class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.references :creator, null: false, foreign_key: { to_table: "users" }
      t.string :name, null: false

      t.timestamps
    end

    add_index :tags, :name, unique: true
  end
end
