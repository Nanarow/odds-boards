class RemoveColumnsFromBoards < ActiveRecord::Migration[8.0]
  def change
    remove_column :boards, :upvotes_count, :integer
    remove_column :boards, :status, :string
  end
end
