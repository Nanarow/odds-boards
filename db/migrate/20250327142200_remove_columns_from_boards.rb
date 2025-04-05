class RemoveColumnsFromBoards < ActiveRecord::Migration[8.0]
  def change
    remove_column :boards, :upvotes_count, :integer
    remove_column :boards, :status, :string
    remove_column :boards, :views_count, :integer
    remove_column :boards, :last_activity_at, :datetime
  end
end
