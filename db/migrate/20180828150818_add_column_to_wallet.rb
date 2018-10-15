class AddColumnToWallet < ActiveRecord::Migration[5.2]
  def change
    add_column :wallets, :trading_volumn, :decimal, precision: 21, scale: 10
    add_column :wallets, :reword_volumn, :decimal, precision: 21, scale: 10
  end
end
