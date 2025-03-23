class CreateBoards < ActiveRecord::Migration[8.0]
  def change
    create_table :boards do |t|
      t.references :author, null: false, foreign_key: { to_table: "users" }
      t.references :category, foreign_key: true
      t.string :title
      t.text :body
      t.string :status
      t.integer :upvotes_count
      t.integer :views_count
      t.datetime :last_activity_at

      t.timestamps
    end
  end
end
