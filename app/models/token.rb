class Token < ActiveRecord::Base
  validates :name, :symbol, presence: true
  def last_price(based_token='WETH')
    last = TradeHistory.where(token_symbol:self.symbol,base_token:based_token).last
    if last
      return last.price
    else 
      return "--"
    end    
  end

  def h_price(based_token='WETH')
    h_price = TradeHistory.where("created_at > ? AND token_symbol = ? AND base_token = ?",Time.now.midnight,self.symbol,based_token).last
    if h_price
      pre_price = TradeHistory.where("created_at < ? AND token_symbol = ? AND base_token = ?",Time.now.midnight,self.symbol,based_token).order(created_at: :asc).last
      if pre_price
        procentage = (((h_price.price - pre_price.price) / pre_price.price) * 100).round(2)
      else
        return 100
      end
    else
      return "--"
    end    
  end

  def h_volumn(based_token='WETH')
    volumns = TradeHistory.where("created_at > ? AND token_symbol = ? AND base_token = ?",Time.now.midnight,self.symbol,based_token)
    h_volumn = 0.00
    if volumns.length > 0
      for volumn in volumns
        h_volumn += volumn.amount*volumn.price
      end
    end
    return h_volumn.round(2)
  end
end
