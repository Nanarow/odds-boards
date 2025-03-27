class AddColumnToBoards < ActiveRecord::Migration[8.0]
  def change
    add_column :boards, :state, :integer, default: 0, null: false
    add_column :boards, :visibility, :integer, default: 0, null: false
  end
end
