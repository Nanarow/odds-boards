class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :board, null: false, foreign_key: true
      t.references :commenter, null: false, foreign_key: { to_table: "users" }
      t.references :parent, foreign_key: { to_table: "comments" }
      t.text :body
      t.integer :depth, null: false, default: 0

      t.timestamps
    end
  end
end
