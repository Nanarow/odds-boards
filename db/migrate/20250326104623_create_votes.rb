class CreateVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :votes do |t|
      t.references :voter, null: false, foreign_key: { to_table: "users" }
      t.references :votable, polymorphic: true, null: false
      t.boolean :is_upvote, null: false

      t.timestamps
    end

    add_index :votes, [ :voter_id, :votable_type, :votable_id ], unique: true, name: "index_votes_on_voter_and_votable"
  end
end
