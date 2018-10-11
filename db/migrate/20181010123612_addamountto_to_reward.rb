class AddamounttoToReward < ActiveRecord::Migration[5.2]
  def change
    add_column :rewards, :amount, :decimal, precision: 21, scale: 10
    add_column :rewards, :state, :string
  end
end
