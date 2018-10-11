class CreateRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :rewards do |t|
      t.string :wallet_address

      t.timestamps
    end
  end
end
