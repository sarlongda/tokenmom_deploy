class AddtxToReward < ActiveRecord::Migration[5.2]
  def change
    add_column :rewards, :txHash, :string
  end
end
