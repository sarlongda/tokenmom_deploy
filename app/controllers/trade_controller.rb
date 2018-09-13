require 'net/http'
require 'net/https'
require 'uri'
require 'json'
require 'bigdecimal'
require "web3/eth/version"
require "web3/eth/abi/abi_coder"
require "web3/eth/utility"
require "web3/eth/block"
require "web3/eth/transaction"
require "web3/eth/contract"
require "web3/eth/call_trace"
require "web3/eth/log"
require "web3/eth/transaction_receipt"
require "web3/eth/eth_module"
require "web3/eth/trace_module"
require "web3/eth/etherscan"
require "web3/eth/rpc"
require "ethereum.rb"

$web3 = Web3::Eth::Rpc.new host: 'ropsten.infura.io',
  port: 443,  
  connect_options: {
    open_timeout: 20,
    read_timeout: 140,
    use_ssl: true,                            
  }
$hash_function_name = {
  "withdraw" => "0x2e1a7d4d",
  "fillOrder" => "0xbc61394a",
  "batchFillOrKillOrders" => "0x4f150787",
  "approve" => "0x095ea7b3"
}
# Contract Addresses for ropsten network
$exchange_contract_addr = "0x479cc461fecd078f766ecc58533d6f69580cf3ac"
$token_contract_addr = "0x4e9aad8184de8833365fea970cd9149372fdf1e6"
$weth_contract_addr = "0xc778417e063141139fce010982780140aa0cd5ab"
$zrx_contract_addr = "0xa8e9fa8f91e5ae138c74648c9c304f1c75003a8d"


# Contract Addresses for kovan Network
# $exchange_contract_addr = "0x90fe2af704b34e0224bf2299c838e04d4dcf1364"
# $token_contract_addr = "0x087eed4bc1ee3de49befbd66c662b434b15d49d4"
# $weth_contract_addr = "0xd0a1e359811322d97991e03f863a0c30c2cf029c"
# $zrx_contract_addr = "0x6ff6c0ff1d68b964901f986d4c9fa3ac68346570"

# Set allowance value
$set_allow_value = "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
# Server Setting values
$wallet_address = "0x7Cc2768c52DEAB5Bc304485c0Fd82Bed287372cD"
$server_key = "6efdb4fb96870179bc6db81900b40b2dca3f1e899a4fa180da7a66a85c1edd72"
$api = Web3::Eth::Etherscan.new api_key: "99MSTBF4NK8F7GT7WNG1173KCYZQNBKHKE"

$exchange_abi = 
  '[
    {"constant":true,
      "inputs":[
        {"name":"numerator","type":"uint256"},
        {"name":"denominator","type":"uint256"},
        {"name":"target","type":"uint256"}],
      "name":"isRoundingError",
      "outputs":[
        {"name":"","type":"bool"}],
      "payable":false,
      "type":"function"},
    {"constant":true,
      "inputs":[
        {"name":"","type":"bytes32"}],
      "name":"filled",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[{"name":"","type":"bytes32"}],
      "name":"cancelled",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"},
    {"constant":false,
      "inputs":[
        {"name":"orderAddresses","type":"address[5][]"},
        {"name":"orderValues","type":"uint256[6][]"},
        {"name":"fillTakerTokenAmount","type":"uint256"},
        {"name":"shouldThrowOnInsufficientBalanceOrAllowance","type":"bool"},
        {"name":"v","type":"uint8[]"},
        {"name":"r","type":"bytes32[]"},
        {"name":"s","type":"bytes32[]"}],
      "name":"fillOrdersUpTo",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"},
    {"constant":false,
      "inputs":[
        {"name":"orderAddresses","type":"address[5]"},
        {"name":"orderValues","type":"uint256[6]"},
        {"name":"cancelTakerTokenAmount","type":"uint256"}],
      "name":"cancelOrder",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[],
      "name":"ZRX_TOKEN_CONTRACT",
      "outputs":[{"name":"","type":"address"}],
      "payable":false,"type":"function"},
    {"constant":false,
      "inputs":[
        {"name":"orderAddresses","type":"address[5][]"},
        {"name":"orderValues","type":"uint256[6][]"},
        {"name":"fillTakerTokenAmounts","type":"uint256[]"},
        {"name":"v","type":"uint8[]"},
        {"name":"r","type":"bytes32[]"},
        {"name":"s","type":"bytes32[]"}],
      "name":"batchFillOrKillOrders",
      "outputs":[],
      "payable":false,"type":"function"},
    {"constant":false,
      "inputs":[
        {"name":"orderAddresses","type":"address[5]"},
        {"name":"orderValues","type":"uint256[6]"},
        {"name":"fillTakerTokenAmount","type":"uint256"},
        {"name":"v","type":"uint8"},
        {"name":"r","type":"bytes32"},
        {"name":"s","type":"bytes32"}],
      "name":"fillOrKillOrder",
      "outputs":[],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[{"name":"orderHash","type":"bytes32"}],
      "name":"getUnavailableTakerTokenAmount",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[
        {"name":"signer","type":"address"},
        {"name":"hash","type":"bytes32"},
        {"name":"v","type":"uint8"},
        {"name":"r","type":"bytes32"},
        {"name":"s","type":"bytes32"}],
      "name":"isValidSignature",
      "outputs":[{"name":"","type":"bool"}],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[
        {"name":"numerator","type":"uint256"},
        {"name":"denominator","type":"uint256"},
        {"name":"target","type":"uint256"}],
      "name":"getPartialAmount",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[],
      "name":"TOKEN_TRANSFER_PROXY_CONTRACT",
      "outputs":[{"name":"","type":"address"}],
      "payable":false,"type":"function"},
    {"constant":false,
      "inputs":[
        {"name":"orderAddresses","type":"address[5][]"},
        {"name":"orderValues","type":"uint256[6][]"},
        {"name":"fillTakerTokenAmounts","type":"uint256[]"},
        {"name":"shouldThrowOnInsufficientBalanceOrAllowance","type":"bool"},
        {"name":"v","type":"uint8[]"},
        {"name":"r","type":"bytes32[]"},
        {"name":"s","type":"bytes32[]"}],
      "name":"batchFillOrders",
      "outputs":[],
      "payable":false,"type":"function"},
    {"constant":false,
      "inputs":[
        {"name":"orderAddresses","type":"address[5][]"},
        {"name":"orderValues","type":"uint256[6][]"},
        {"name":"cancelTakerTokenAmounts","type":"uint256[]"}],
      "name":"batchCancelOrders","outputs":[],
      "payable":false,"type":"function"},
    {"constant":false,
      "inputs":[
        {"name":"orderAddresses","type":"address[5]"},
        {"name":"orderValues","type":"uint256[6]"},
        {"name":"fillTakerTokenAmount","type":"uint256"},
        {"name":"shouldThrowOnInsufficientBalanceOrAllowance","type":"bool"},
        {"name":"v","type":"uint8"},
        {"name":"r","type":"bytes32"},
        {"name":"s","type":"bytes32"}],
      "name":"fillOrder",
      "outputs":[{"name":"filledTakerTokenAmount","type":"uint256"}],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[
        {"name":"orderAddresses","type":"address[5]"},
        {"name":"orderValues","type":"uint256[6]"}],
      "name":"getOrderHash",
      "outputs":[{"name":"","type":"bytes32"}],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[],
      "name":"EXTERNAL_QUERY_GAS_LIMIT",
      "outputs":[{"name":"","type":"uint16"}],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[],
      "name":"VERSION",
      "outputs":[{"name":"","type":"string"}],
      "payable":false,"type":"function"},
    {
      "inputs":[
        {"name":"_zrxToken","type":"address"},
        {"name":"_tokenTransferProxy","type":"address"}],
      "payable":false,"type":"constructor"},
    {
      "anonymous":false,
      "inputs":[
        {"indexed":true,"name":"maker","type":"address"},
        {"indexed":false,"name":"taker","type":"address"},
        {"indexed":true,"name":"feeRecipient","type":"address"},
        {"indexed":false,"name":"makerToken","type":"address"},
        {"indexed":false,"name":"takerToken","type":"address"},
        {"indexed":false,"name":"filledMakerTokenAmount","type":"uint256"},
        {"indexed":false,"name":"filledTakerTokenAmount","type":"uint256"},
        {"indexed":false,"name":"paidMakerFee","type":"uint256"},
        {"indexed":false,"name":"paidTakerFee","type":"uint256"},
        {"indexed":true,"name":"tokens","type":"bytes32"},
        {"indexed":false,"name":"orderHash","type":"bytes32"}],
      "name":"LogFill","type":"event"},
    {
      "anonymous":false,
      "inputs":[
        {"indexed":true,"name":"maker","type":"address"},
        {"indexed":true,"name":"feeRecipient","type":"address"},
        {"indexed":false,"name":"makerToken","type":"address"},
        {"indexed":false,"name":"takerToken","type":"address"},
        {"indexed":false,"name":"cancelledMakerTokenAmount","type":"uint256"},
        {"indexed":false,"name":"cancelledTakerTokenAmount","type":"uint256"},
        {"indexed":true,"name":"tokens","type":"bytes32"},
        {"indexed":false,"name":"orderHash","type":"bytes32"}],
      "name":"LogCancel","type":"event"},
    {
      "anonymous":false,
      "inputs":[
        {"indexed":true,"name":"errorId","type":"uint8"},
        {"indexed":true,"name":"orderHash","type":"bytes32"}],
      "name":"LogError","type":"event"}]'
$token_abi = 
  '[
    {"constant":true,
      "inputs":[],
      "name":"name",
      "outputs":[
        {"name":"","type":"string"}
      ],
      "payable":false,
      "type":"function"
    },
    {"constant":false,
      "inputs":[
        {"name":"_spender","type":"address"},
        {"name":"_value","type":"uint256"}
      ],
      "name":"approve",
      "outputs":[{"name":"","type":"bool"}],
      "payable":false,"type":"function"
    },
    {"constant":true,
      "inputs":[],
      "name":"totalSupply",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"
    },
    {"constant":false,
      "inputs":[
        {"name":"_from","type":"address"},
        {"name":"_to","type":"address"},
        {"name":"_value","type":"uint256"}
      ],
      "name":"transferFrom",
      "outputs":[{"name":"","type":"bool"}],
      "payable":false,"type":"function"
    },
    {"constant":true,
      "inputs":[],
      "name":"decimals",
      "outputs":[{"name":"","type":"uint8"}],
      "payable":false,"type":"function"
    },
    {"constant":true,
      "inputs":[{"name":"_owner","type":"address"}],
      "name":"balanceOf",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"
    },
    {"constant":true,
      "inputs":[],
      "name":"symbol",
      "outputs":[{"name":"","type":"string"}],
      "payable":false,"type":"function"
    },
    {"constant":false,
      "inputs":[
        {"name":"_to","type":"address"},
        {"name":"_value","type":"uint256"}
      ],
      "name":"transfer",
      "outputs":[{"name":"","type":"bool"}],
      "payable":false,"type":"function"
    },
    {"constant":true,
      "inputs":[
        {"name":"_owner","type":"address"},
        {"name":"_spender","type":"address"}
      ],
      "name":"allowance",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"
    },
    {
      "inputs":[],
      "payable":false,"type":"constructor"
    },
    {
      "anonymous":false,
      "inputs":[
        {"indexed":true,"name":"_from","type":"address"},
        {"indexed":true,"name":"_to","type":"address"},
        {"indexed":false,"name":"_value","type":"uint256"}
      ],
      "name":"Transfer","type":"event"
    },
    {
      "anonymous":false,
      "inputs":[
        {"indexed":true,"name":"_owner","type":"address"},
        {"indexed":true,"name":"_spender","type":"address"},
        {"indexed":false,"name":"_value","type":"uint256"}
      ],
      "name":"Approval","type":"event"
    }
  ]'
class TradeController < ApplicationController
  skip_before_action :verify_authenticity_token  
  def index
  end  
  def trade   
    @messages = Message.order(updated_at: :asc)
    @tokenlist = get_token_list
    @zrxtoken = Token.where("symbol = ?","ZRX").first
    @buyOrders = Order.where(:base_token => "ZRX",:type => 1).order(price: :desc)
    @sellOrders = Order.where(:base_token => "ZRX",:type => 0).order(price: :asc)
    @user_id = current_user ? current_user.id : nil
  end
  def get_tokens 
    base_token = params[:base_token]
    tokens = Token.order(symbol: :asc) 
    tokens_array = Array.new
    tokens.each_with_index do |token, index|      
      json_record = {          
        :symbol => token.symbol,
        :decimals => token.token_decimals,
        :contract_address => token.contract_address,
        :name => token.name,
        :last_price => token.last_price(base_token),
        :h_price => token.h_price(base_token),
        :h_volumn => token.h_volumn(base_token)
      }
      tokens_array.push json_record
    end
    json_data = {
      "state":"ok",
      "tokens":tokens_array,                
    }
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end
  def get_init_data
    base_token = params[:base_token]
    symbol = params[:token_symbol]
    token_addr = params[:token_address]
    tokens = Token.order(updated_at: :asc)    
    key = Eth::Key.new priv: $server_key    
    result = "OK"  
    # result = batchfillOrder() 
    # //////////////////////////////////////////
    token_amount_unavailable = 0
    myContract = $web3.eth.contract($exchange_abi)
    contract_instance = myContract.at('0x479cc461fecd078f766ecc58533d6f69580cf3ac')
    zrx_token_contract = contract_instance.ZRX_TOKEN_CONTRACT

    i = 0 
    order_hash = (Order.first)    
    if order_hash
      hash = order_hash.order_hash
      
      token_amount_unavailable = "order"
      # abi = $api.contract_getabi address: $exchange_contract_addr
      # myContract = $web3.eth.contract(abi)
      # contract_instance = myContract.at($exchange_contract_addr)
      # order_detail = JSON.parse(OrderDetail.first.signedorder)
      # orderAddresses = Array.new(5)
      # orderValues = Array.new(6)

      # orderAddresses[0] = (order_detail["maker"])
      # orderAddresses[1] = (order_detail["taker"])
      # orderAddresses[2] = (order_detail["makerTokenAddress"])
      # orderAddresses[3] = (order_detail["takerTokenAddress"])
      # orderAddresses[4] = (order_detail["feeRecipient"])

      # orderValues[0] = order_detail["makerTokenAmount"].to_i
      # orderValues[1] = order_detail["takerTokenAmount"].to_i
      # orderValues[2] = order_detail["makerFee"].to_i
      # orderValues[3] = order_detail["takerFee"].to_i
      # orderValues[4] = order_detail["expirationUnixTimestampSec"].to_i
      # orderValues[5] = order_detail["salt"].to_i

      # templete = orderfilledAmount(order_detail)
      # token_amount_unavailable = templete

      # partialAmount = contract_instance.getPartialAmount((templete/2).to_i,orderValues[1].to_i,orderValues[0].to_i)
      # token_amount_unavailable = partialAmount
      # token_amount_unavailable = BigDecimal.new(10)

      # token_amount_unavailable = max_value(145,245)
      # token_amount_unavailable = min_value(145,245)
    end   
    tokens_array = Array.new
    tokens.each_with_index do |token, index|      
      json_record = {
        :id => token.id,
        :symbol => token.symbol,
        :decimals => token.token_decimals,
        :contract_address => token.contract_address,
        :name => token.name,
        :last_price => token.last_price(base_token),
        :h_price => token.h_price(base_token),
        :h_volumn => token.h_volumn(base_token)
      }
      tokens_array.push json_record
    end

    # Select token info
    token = Token.where(:symbol => symbol).first
    if token
      token_info = {
        "token_contract_addr":token.contract_address,
        "token_name":token.name,
        "token_decimals":token.token_decimals,
        "token_symbol":token.symbol,
        "token_last_price":token.last_price(base_token),
        "token_h_price":token.h_price(base_token),
        "token_h_volumn":token.h_volumn(base_token)
      }
    else
      abi = $token_abi          
      exchangeContract = $web3.eth.contract(abi).at(token_addr)
      token_decimals = exchangeContract.decimals()
      token_name = exchangeContract.name()
      last_price = token_last_price(base_token,symbol)
      h_price = token_h_price(base_token,symbol)
      h_volumn = token_h_volumn(base_token,symbol)
      token_info = {
        "token_contract_addr":token_addr,
        "token_name":token_name,
        "token_symbol":symbol,
        "token_decimals":token_decimals,
        "token_last_price":last_price,
        "token_h_price":h_price,
        "token_h_volumn":h_volumn
      }
    end
    json_data = {
      "state":"ok",
      "tokens":tokens_array,
      "select_token":token_info,
      "balance":token_amount_unavailable,          
    }
    respond_to do |format|
      format.json { render :json=>json_data}
    end    
  end

  def orderfilledAmount(order_detail)
    abi = $exchange_abi
    myContract = $web3.eth.contract(abi)
    contract_instance =myContract.at($exchange_contract_addr)
    orderAddresses = Array.new(5)
    orderValues = Array.new(6)
    orderAddresses[0] = (order_detail["maker"])
    orderAddresses[1] = (order_detail["taker"])
    orderAddresses[2] = (order_detail["makerTokenAddress"])
    orderAddresses[3] = (order_detail["takerTokenAddress"])
    orderAddresses[4] = (order_detail["feeRecipient"])
    orderValues[0] = order_detail["makerTokenAmount"].to_i
    orderValues[1] = order_detail["takerTokenAmount"].to_i
    orderValues[2] = order_detail["makerFee"].to_i
    orderValues[3] = order_detail["takerFee"].to_i
    orderValues[4] = order_detail["expirationUnixTimestampSec"].to_i
    orderValues[5] = order_detail["salt"].to_i

    amount = 0
    order_hash = contract_instance.getOrderHash(orderAddresses,orderValues)
    amount = contract_instance.filled(order_hash)
    return amount
  end

  def max_value(a,b)
    return a >= b ? a : b
  end

  def min_value(a,b)
    return a < b ? a : b
  end
  
  # Hash 32 byte fill zero
  def hash32(string)
    num = 64-string.length
    i = 0
    while i < num.to_i do
      string.insert(0,"0")
      i += 1
    end
    return string            
  end
  def hash32_prefix string
    string.insert(-1,"0")
    num = 64 -string.length
    i = 0
    while i < num.to_i do
      string.insert(0,"0")
      i += 1
    end
    return string 
  end
  def fill_order
    base_token = "ETH"
    token_symbol = "ZRX"
    price = 0.0000005
    type = 1
    match_order = Order.where("base_token = ? AND token_symbol = ? AND price >= ?",base_token,token_symbol,price).first
    function_name = ""
    if match_order
      result = "YES"
      order_detail_id = match_order.detail_id
      signed_order = JSON.parse(OrderDetail.where(id:order_detail_id).first.signedorder)
      orderAddresses = Array.new
      orderValues = Array.new
      paramsArray = Array.new
      shouldThrowOnInsufficientBalanceOrAllowance = true
      fillTakerTokenAmount = signed_order["takerTokenAmount"]
      paramsArray[0] = orderAddresses[0] = signed_order["maker"]
      paramsArray[1] = orderAddresses[1] = signed_order["taker"]
      paramsArray[2] = orderAddresses[2] = signed_order["makerTokenAddress"]
      paramsArray[3] = orderAddresses[3] = signed_order["takerTokenAddress"]
      paramsArray[4] = orderAddresses[4] = signed_order["feeRecipient"]

      paramsArray[5] = orderValues[0] = signed_order["makerTokenAmount"]
      paramsArray[6] = orderValues[1] = signed_order["takerTokenAmount"]
      paramsArray[7] = orderValues[2] = signed_order["makerFee"]
      paramsArray[8] = orderValues[3] = signed_order["takerFee"]
      paramsArray[9] = orderValues[4] = signed_order["expirationUnixTimestampSec"]
      paramsArray[10] = orderValues[5] = signed_order["salt"]
      v = signed_order["ecSignature"]["v"]
      r = signed_order["ecSignature"]["r"]
      s = signed_order["ecSignature"]["s"]

      paramsArray[11] = signed_order["takerTokenAmount"]
      paramsArray[12] = 1

      key = Eth::Key.new priv: $server_key
      function_name = $hash_function_name["fillOrder"]
      count = $web3.eth.getTransactionCount([key.address,"pending"]).to_i(16)
      contract_address = $exchange_contract_addr

      j = 0
      while j < 5 do
        paramsArray[j] = $web3.eth.remove_0x_head(orderAddresses[j])
        j += 1
      end     
      i = 0
      while i < 8 do
        paramsArray[i+5] = paramsArray[i+5].to_i.to_s(16)
        i += 1         
      end
      k = 0      
      paramsArray[13] = v.to_i.to_s(16)
      paramsArray[14] = $web3.eth.remove_0x_head(r)
      paramsArray[15] = $web3.eth.remove_0x_head(s)
      while k < 16 do
        paramsArray[k] = hash32 paramsArray[k]
        function_name.insert(-1,paramsArray[k])
        k += 1
      end
      tx = Eth::Tx.new({
        value:0,      
        gas_limit: 1100_00,
        gas_price: 10000000000,
        nonce: count,
        to: contract_address,
        data:function_name,
      })      
      tx.sign key
      $web3.eth.sendRawTransaction([tx.hex]) 
      result = tx.hash     

    else
      result = "NO"      
    end
    return result
    
  end
  def batchfillOrder(type,price,amount,base_token='ETH',token_symbol='ZRX')   
    return_str = ""
    # init Arrays
    signed_order = Array.new
    signed_order_ids = Array.new
    delete_order = Array.new
    update_order = Array.new
    order_real_amountArray = Array.new
    update_order_amount = BigDecimal.new("0")
    update_taker_order = Array.new
    update_taker_order_amount = BigDecimal.new("0")
    taker_amount = BigDecimal.new(amount.to_s)
    maker_amount = BigDecimal.new("0") 
    
    # Contract define
    abi = $exchange_abi
    myContract = $web3.eth.contract(abi)
    contract_instance =myContract.at($exchange_contract_addr)

    # get taker Order values
    create_order = Order.where("base_token = ? AND token_symbol = ? AND price = ? AND type = ?",base_token,token_symbol,price,type).last
    if create_order
      signed_order[0] = JSON.parse(OrderDetail.where(id:create_order.detail_id).first.signedorder)
      signed_order_ids[0] = create_order.id 
      order_real_amountArray[0] = create_order.amount.to_f
      # Get Token decimals from Ether block
      if type == 1
        token_address = signed_order[0]["takerTokenAddress"]
      elsif type == 0
        token_address = signed_order[0]["makerTokenAddress"]
      end
      abi = $token_abi          
      tokenContract = $web3.eth.contract(abi).at(token_address)
      decimals = tokenContract.decimals()
      result = ""
      data_code = ""
      if type == 0         
        match_order = Order.where("base_token = ? AND token_symbol = ? AND price >= ? AND type = ?",base_token,token_symbol,price,1).order(price: :desc)
        if match_order.length > 0
          result = "YES"
          delete_order[0] = create_order
          i = 0
          while i < match_order.length do
            maker_amount += BigDecimal.new(match_order[i].amount.to_s)
            signed_order[i + 1] = JSON.parse(OrderDetail.where(id:match_order[i].detail_id).first.signedorder)
            signed_order_ids[i + 1] = match_order[i].id
            order_real_amountArray[i+1] = match_order[i].amount
            if maker_amount >= taker_amount
              if maker_amount == taker_amount
                delete_order[i+1] = match_order[i]
                break;
              elsif
                update_order[0] = match_order[i]
                update_order_amount = BigDecimal.new(maker_amount.to_s) - BigDecimal.new(taker_amount.to_s)
              end
              break;
            else
              delete_order[i+1] = match_order[i]
            end            
            i += 1
          end
          if taker_amount > maker_amount
            if decimals > 8
              update_taker_order_amount = (BigDecimal.new(taker_amount.to_s) - BigDecimal.new(maker_amount.to_s)).truncate(8)              
            else
              update_taker_order_amount = (BigDecimal.new(taker_amount.to_s) - BigDecimal.new(maker_amount.to_s)).truncate(decimals)
            end
          end
        end
      elsif type == 1
        match_order = Order.where("base_token = ? AND token_symbol = ? AND price <= ? AND type = ?",base_token,token_symbol,price,0).order(price: :asc)
        if match_order.length > 0
          result = "YES"
          delete_order[0] = create_order
          i = 0
          while i < match_order.length do
            maker_amount += BigDecimal.new(match_order[i].amount.to_s)
            signed_order[i + 1] = JSON.parse(OrderDetail.where(id:match_order[i].detail_id).first.signedorder)
            signed_order_ids[i + 1] = match_order[i].id
            order_real_amountArray[i+1] = match_order[i].amount.to_f
            if maker_amount >= taker_amount
              if maker_amount == taker_amount
                delete_order[i+1] = match_order[i]
              elsif
                update_order[0] = match_order[i]
                update_order_amount = BigDecimal.new(maker_amount.to_s) - BigDecimal.new(taker_amount.to_s)
              end
              break;
            else
              delete_order[i+1] = match_order[i]              
            end            
            i += 1
          end
          if taker_amount > maker_amount
            if decimals > 8
              update_taker_order_amount = (BigDecimal.new(taker_amount.to_s) - BigDecimal.new(maker_amount.to_s)).truncate(8)
            else
              update_taker_order_amount = (BigDecimal.new(taker_amount.to_s) - BigDecimal.new(maker_amount.to_s)).truncate(decimals-1)
            end
          end
        end
      end
      if signed_order.count > 1
        order_count = signed_order.count
        # make param prefix
        prefix_param = Array.new
        prefix_params = ""
        data_code = ""
        key = Eth::Key.new priv: $server_key
        # batchfillOrKillOrders
        # data_code = "0x4f150787"
        # batchfillOrders
        data_code = "0xb7b2c7d6"
        count = $web3.eth.getTransactionCount([key.address,"pending"]).to_i(16)
        contract_address = $exchange_contract_addr
        prefix_param[0] = 0xe
        prefix_param[1] = prefix_param[0] + 5 * 2 * order_count + 2
        prefix_param[2] = prefix_param[1] + 6 * 2 * order_count + 2
        prefix_param[3] = prefix_param[2] + 1 * 2 * order_count + 2
        prefix_param[4] = prefix_param[3] + 1 * 2 * order_count + 2
        prefix_param[5] = prefix_param[4] + 1 * 2 * order_count + 2
        i = 0
        while i < 3 do
          param = prefix_param[i].to_i.to_s(16)
          param = hash32_prefix(param)
          prefix_param[i] = param
          prefix_params += prefix_param[i]
          i += 1
        end 
        
        prefix_params +=hash32(1.to_i.to_s(16))
        i = 0 
        while i < 3 do
          param = prefix_param[i+3].to_i.to_s(16)
          param = hash32_prefix(param)
          prefix_param[i+3] = param
          prefix_params += prefix_param[i+3]
          i += 1
        end
        orderAddresses = Array.new(order_count){Array.new}
        orderValues = Array.new(order_count){Array.new}
        paramsArray = Array.new(order_count){Array.new}
        tmp_paramArray = Array.new{Array.new}
        v = Array.new(order_count){Array.new}
        r = Array.new(order_count){Array.new}
        s = Array.new(order_count){Array.new}
        j = 0
        while j < order_count do        
          paramsArray[j][0] = orderAddresses[j][0] = $web3.eth.remove_0x_head(signed_order[j]["maker"])
          paramsArray[j][1] = orderAddresses[j][1] = $web3.eth.remove_0x_head(signed_order[j]["taker"])
          paramsArray[j][2] = orderAddresses[j][2] = $web3.eth.remove_0x_head(signed_order[j]["makerTokenAddress"])
          paramsArray[j][3] = orderAddresses[j][3] = $web3.eth.remove_0x_head(signed_order[j]["takerTokenAddress"])
          paramsArray[j][4] = orderAddresses[j][4] = $web3.eth.remove_0x_head(signed_order[j]["feeRecipient"])

          paramsArray[j][5] = orderValues[j][0] = signed_order[j]["makerTokenAmount"].to_i.to_s(16)
          paramsArray[j][6] = orderValues[j][1] = signed_order[j]["takerTokenAmount"].to_i.to_s(16)
          paramsArray[j][7] = orderValues[j][2] = signed_order[j]["makerFee"].to_i.to_s(16)
          paramsArray[j][8] = orderValues[j][3] = signed_order[j]["takerFee"].to_i.to_s(16)
          paramsArray[j][9] = orderValues[j][4] = signed_order[j]["expirationUnixTimestampSec"].to_i.to_s(16)
          paramsArray[j][10] = orderValues[j][5] = signed_order[j]["salt"].to_i.to_s(16)
          v[j] = signed_order[j]["ecSignature"]["v"]
          r[j] = signed_order[j]["ecSignature"]["r"]
          s[j] = signed_order[j]["ecSignature"]["s"]
          if j == 0
            if update_taker_order_amount > 0              
              if type == 0
                taker_fill_amount =  (signed_order[j]["takerTokenAmount"].to_f * ((maker_amount * (10 ** decimals)).to_f / signed_order[j]["makerTokenAmount"].to_f))
                # decimal round down
                taker_fill_amount_round = (taker_fill_amount / (10 ** 18))
                return_str += taker_fill_amount_round.to_s                
                paramsArray[j][11] = (taker_fill_amount_round * (10 ** 18)).to_i.to_s(16)              
                # taker_fill_amount =  BigDecimal.new(signed_order[j]["takerTokenAmount"].to_s) * ((BigDecimal.new(maker_amount.to_S) * (BigDecimal.new(10.to_s) ** BigDecimal.new(decimals.to_s))) / BigDecimal.new(signed_order[j]["makerTokenAmount"].to_s))
                # taker_fill_amount_round = (taker_fill_amount / (BigDecimal.new(10.to_s) ** BigDecimal.new(18.to_s))).truncate(8)
                # paramsArray[j][11] = (taker_fill_amount_round * (BigDecimal.new(10.to_s) ** BigDecimal.new(18.to_s))).to_i.to_s(16) 
              elsif type == 1
                
                if decimals > 8
                  round_dec = 8
                else
                  round_dec = decimals
                end
                taker_amount_param_0 = (maker_amount.truncate(round_dec) * (BigDecimal.new(10.to_s) ** BigDecimal.new(decimals.to_s))).to_i.to_s(16)
                paramsArray[j][11] = taker_amount_param_0
              end
            else              
              if type == 0                
                paramsArray[j][11] = (signed_order[j]["takerTokenAmount"]).to_i.to_s(16)                
              elsif type == 1
                paramsArray[j][11] = (signed_order[j]["takerTokenAmount"]).to_i.to_s(16)
              end              
            end            
          else
            if update_order.count > 0              
              if update_order[0].id == signed_order_ids[j]                     
                if type == 0   # SELL
                  # BUY order current  
                  taker_Token_amount = ( order_real_amountArray[j] * ( 10 ** decimals ) )
                  paramsArray[j][11] = (taker_Token_amount.to_i - (update_order_amount.to_f * (10 ** decimals)).to_i).to_i.to_s(16)             
                elsif type == 1   #BUY  
                  # SELL order current 
                  maker_Token_amount = ( BigDecimal.new(order_real_amountArray[j].to_s) * ( BigDecimal.new(10) ** BigDecimal.new(decimals) ) )                                  
                  # paramsArray[j][11] = ((BigDecimal.new(tmp.to_s) / BigDecimal.new(100.to_s)).to_i * BigDecimal.new(100.to_s)).to_i.to_s(16)    
                  # get filled amount in order
                  filledTakerTokenAmount = orderfilledAmount(signed_order[j])
                  filledMakerTokenAmount = contract_instance.getPartialAmount(filledTakerTokenAmount,signed_order[j]["takerTokenAmount"],signed_order[j]["makerTokenAmount"])
                  # get current token amounts
                  restMakerTokenAmount = min_value((signed_order[j]["makerTokenAmount"].to_i - filledMakerTokenAmount),(maker_Token_amount))
                  fillMakerTokenAmount = restMakerTokenAmount - (BigDecimal.new(update_order_amount.to_s) * (BigDecimal.new(10) ** BigDecimal.new(decimals) ))
                  fillTakerTokenAmount = ((fillMakerTokenAmount.to_i * signed_order[j]["takerTokenAmount"].to_i).to_i / signed_order[j]["makerTokenAmount"].to_i).to_i
     
                  paramsArray[j][11] = fillTakerTokenAmount.to_i.to_s(16)
                  
                  
                end
              else
                if type == 1
                  taker_Token_amount = (signed_order[j]["takerTokenAmount"].to_f * (( order_real_amountArray[j] * ( 10 ** decimals ) ).to_f / signed_order[j]["makerTokenAmount"].to_f))
                  paramsArray[j][11] = taker_Token_amount.to_i.to_s(16)
                elsif type == 0
                  taker_Token_amount = ( order_real_amountArray[j] * ( 10 ** decimals ) )
                  paramsArray[j][11] = taker_Token_amount.to_i.to_s(16)
                end
              end          
            else
              if type == 1                
                taker_Token_amount = (BigDecimal.new(signed_order[j]["takerTokenAmount"].to_s) * (( order_real_amountArray[j] * ( 10 ** decimals ) ).to_f / signed_order[j]["makerTokenAmount"].to_f))
                paramsArray[j][11] = taker_Token_amount.to_i.to_s(16)                   
              elsif type == 0
                taker_Token_amount = ( order_real_amountArray[j] * ( 10 ** decimals ) )
                paramsArray[j][11] = taker_Token_amount.to_i.to_s(16)
              end              
            end
          end
          
          paramsArray[j][12] = v[j].to_i.to_s(16)
          paramsArray[j][13] = $web3.eth.remove_0x_head(r[j])
          paramsArray[j][14] = $web3.eth.remove_0x_head(s[j])   
          j += 1
        end
        # Change order arrays
        if type == 1
          tmp_paramArray = paramsArray[0]
          paramsArray[0] = paramsArray[order_count - 1]
          paramsArray[order_count - 1] = tmp_paramArray
        end
        order_count_string = order_count.to_i.to_s(16)
        order_count_param = hash32 order_count_string
        # make batchfillorder params
        # make param header
        data_code.insert(-1,prefix_params)        
        # param orderAddress count
        data_code.insert(-1,order_count_param)
        # param orderAddresses
        ii = 0
        jj = 0
        while ii < order_count.to_i do
          while jj < 5 do
            paramsArray[ii][jj] = hash32 paramsArray[ii][jj]
            data_code.insert(-1,paramsArray[ii][jj])
            jj += 1
          end
          jj = 0 
          ii += 1
        end
        # param orderValue count
        data_code.insert(-1,order_count_param)
        # param orderValues
        ii = 0
        jj = 0
        while ii < order_count do
          while jj < 6 do
            paramsArray[ii][jj + 5] = hash32 paramsArray[ii][jj + 5]
            data_code.insert(-1,paramsArray[ii][jj + 5])
            jj += 1
          end 
          jj = 0
          ii += 1
        end
        # param takerfillamount count
        data_code.insert(-1,order_count_param)
        # param takerfillamounts
        ii = 0
        jj = 0
        while ii < order_count do
          while jj < 1 do
            paramsArray[ii][jj + 11] = hash32 paramsArray[ii][jj + 11]
            data_code.insert(-1,paramsArray[ii][jj + 11])
            jj += 1
          end 
          jj = 0
          ii += 1
        end
        # data_code.insert(-1,hash32(1.to_i.to_s(16)))
        ii = 0
        jj = 0
        data_code.insert(-1,order_count_param)
        while ii < order_count do
          while jj < 1 do
            paramsArray[ii][jj + 12] = hash32 paramsArray[ii][jj + 12]
            data_code.insert(-1,paramsArray[ii][jj + 12])
            jj += 1
          end
          jj = 0
          ii += 1
        end
        # param s[v] count
        data_code.insert(-1,order_count_param)
        # param s[v]s
        ii = 0
        jj = 0
        while ii < order_count do
          while jj < 1 do
            paramsArray[ii][jj + 13] = hash32 paramsArray[ii][jj + 13]
            data_code.insert(-1,paramsArray[ii][jj + 13])
            jj += 1
          end 
          jj = 0
          ii += 1
        end

        # param s[r] count
        data_code.insert(-1,order_count_param)
        # param s[r]s
        ii = 0
        jj = 0
        while ii < order_count do
          while jj < 1 do
            paramsArray[ii][jj + 14] = hash32 paramsArray[ii][jj + 14]
            data_code.insert(-1,paramsArray[ii][jj + 14])
            jj += 1
          end 
          jj = 0
          ii += 1
        end
        # param s[s] count
        # data_code.insert(-1,order_count_param)
        # param s[s]s
        # ii = 0
        # jj = 0
        # while ii < order_count do
        #   while jj < 1 do
        #     paramsArray[ii][jj + 15] = hash32 paramsArray[ii][jj + 15]
        #     data_code.insert(-1,paramsArray[ii][jj + 15])
        #     jj += 1
        #   end 
        #   jj = 0
        #   ii += 1
        # end
        tx = Eth::Tx.new({
          value:0,      
          gas_limit: 8900_00,
          gas_price: 10000000000,
          nonce: count,
          to: contract_address,
          data:data_code,
        })
        tx.sign key
        $web3.eth.sendRawTransaction([tx.hex]) 
        result = tx.hash 
        if update_taker_order_amount > 0
          update_orders(create_order.id,update_taker_order_amount)
        else
          delete_orders(delete_order[0].id)
        end
        if delete_order.count > 1
          jj = 1
          while jj < delete_order.count do
            delete_orders(delete_order[jj].id)
            create_trade_histories(delete_order[jj].token_symbol,delete_order[jj].type,delete_order[jj].maker_address,create_order.maker_address,delete_order[jj].price,delete_order[jj].amount,delete_order[jj].base_token,result)
            jj += 1
          end 
        end
        if update_order.count > 0
          update_orders(update_order[0].id,update_order_amount)
          trade_amount = update_order[0].amount - update_order_amount
          create_trade_histories(update_order[0].token_symbol,update_order[0].type,update_order[0].maker_address,create_order.maker_address,update_order[0].price,trade_amount,update_order[0].base_token,result)
        end
        
        return return_str
      else
        return "No match"
      end
    else
      return "No match"
    end   
  end
  def setTokenAllowance token_address
    # token_address = '0xa8e9fa8f91e5ae138c74648c9c304f1c75003a8d' # ZRX token address
    contract_address = token_address
    key = Eth::Key.new priv: $server_key
    # get nonce count
    count = $web3.eth.getTransactionCount([key.address,"pending"]).to_i(16)
    # params
    spender_address = $token_contract_addr
    value = $set_allow_value
    function_name = '';
    function_name = "0x095ea7b3" # approve function name

    # make approve function params
    spender_address = hash32 $web3.eth.remove_0x_head(spender_address)
    function_name.insert(-1,spender_address)
    function_name.insert(-1,value)

    tx = Eth::Tx.new({
      value:0,      
      gas_limit: 1100_00,
      gas_price: 20000000000,
      nonce: count,
      to: contract_address,
      data:function_name,
    })
    tx.sign key
    $web3.eth.sendRawTransaction([tx.hex]) 
    result = tx.hash
    # result = $web3.eth.getTransactionByHash tx.hash
    return result
  end
  def getTokenAllowance token_addr
    abi = $token_abi
    # token_addr = "0xa8e9fa8f91e5ae138c74648c9c304f1c75003a8d"  # Zrx token address
    spender_address = $token_contract_addr    
    exchangeContract = $web3.eth.contract(abi).at(token_addr)
    balance = exchangeContract.allowance($wallet_address,spender_address)
    return balance
  end  
  def get_token_info
    base_token = params[:base_token]
    symbol = params[:symbol]
    token_contract = params[:token_contract]
    token = Token.where(:symbol => symbol).first
    if token
      token_info = {
        "token_contract_addr":token.contract_address,
        "token_name":token.name,
        "token_symbol":token.symbol,
        "token_decimals":token.token_decimals,
        "token_last_price":token.last_price(base_token),
        "token_h_price":token.h_price(base_token),
        "token_h_volumn":token.h_volumn(base_token)
      }
      json_data = {
        "state":"ok",
        "token_info":token_info      
      }
    else
      abi = $token_abi          
      exchangeContract = $web3.eth.contract(abi).at(token_contract)
      token_decimals = exchangeContract.decimals()
      token_name = exchangeContract.name()
      last_price = token_last_price(base_token,symbol)
      h_price = token_h_price(base_token,symbol)
      h_volumn = token_h_volumn(base_token,symbol)
      token_info = {
        "token_contract_addr":token_contract,
        "token_name":token_name,
        "token_symbol":symbol,
        "token_decimals":token_decimals,
        "token_last_price":last_price,
        "token_h_price":h_price,
        "token_h_volumn":h_volumn
      }
      json_data = {
        "state":"ok",
        "token_info":token_info      
      }

    end
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end
  def find_token
    token_symbol = params[:token_symbol]
    base_token = params[:base_token]
    token = Token.where(:symbol => token_symbol).first
    last_price = token_last_price(base_token,token_symbol)
    h_price = token_h_price(base_token,token_symbol)
    h_volumn = token_h_volumn(base_token,token_symbol)
    if token
      json_data = {
        "status": "ok",
        "token": token,
        "l_price": last_price,
        "h_price": h_price,
        "h_volumn": h_volumn
      }
    else
      json_data = {
        "status": "no_data",
        "l_price": last_price,
        "h_price": h_price,
        "h_volumn": h_volumn
      }
    end
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end
  def token_last_price(base_token = 'ETH', token_symbol)
    last = TradeHistory.where(token_symbol:token_symbol).last
    if last
      return last.price
    else 
      return "--"
    end
  end
  def token_h_price(base_token = "ETH", token_symbol)
    h_price = TradeHistory.where("created_at > ? AND token_symbol = ?",Time.now.midnight,token_symbol).last
    if h_price
      pre_price = TradeHistory.where("created_at < ? AND token_symbol = ?",Time.now.midnight,token_symbol).order(created_at: :asc).last
      if pre_price
        procentage = (((h_price.price - pre_price.price) / pre_price.price) * 100).round(2)
      else
        return 100
      end
    else
      return "--"
    end
  end
  def token_h_volumn(base_token = "ETH", token_symbol)
    volumns = TradeHistory.where("created_at > ? AND token_symbol = ?",Time.now.midnight,token_symbol)
    h_volumn = 0.00
    if volumns.length > 0
      for volumn in volumns
        h_volumn += (volumn.amount * volumn.price)
      end
    end
    return h_volumn.round(2)
  end
  def get_messages
    room_id = params[:param1]
    messages = Message.where(room_id: room_id ).order(created_at: :asc)
    json_data = Array.new
    messages.each_with_index do |message, index|
      json_record = {
          :content => message.content,
          :nick_name => message.user.nick_name,
          :contract_address => message.user.wallet_address
      }
      json_data.push json_record
    end
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end
  def get_my_open_orders
    wallet_address = params[:wallet_addr]
    base_token = params[:base_token]
    token_symbol = params[:token_symbol]
    my_orders = Order.where(base_token:base_token,maker_address:wallet_address).order(created_at: :asc)
    if my_orders.length > 0
      json_data = {
        "status":"ok",
        "orders":my_orders
      }
    else
      json_data = {
        "status":"no_data"
      }
    end
    
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end
  def get_orders
    token_symbol = params[:symbol]
    base_token = params[:base_token]
    buy_orders = Order.select("type,price,sum(amount) as amount, min(expire) as expire").where(base_token:base_token,token_symbol:token_symbol,type:1).group("price").order(price: :desc)
    sell_orders = Order.select("type,price,sum(amount) as amount, min(expire) as expire").where(base_token:base_token,token_symbol:token_symbol,type:0 ).group("price").order(price: :asc)
    # max_amount = Order.select("sum(amount) as amount").where(base_token:base_token,token_symbol:token_symbol).maximum("amount")
    buy_max = Order.select("sum(amount) as mamount").where(base_token:base_token,token_symbol:token_symbol,type:1).group("price").order("mamount DESC").first
    sell_max = Order.select("sum(amount) as mamount").where(base_token:base_token,token_symbol:token_symbol,type:0).group("price").order("mamount DESC").first
    best_asks = Order.where(base_token:base_token,token_symbol:token_symbol,type:0).minimum("price");
    best_bids = Order.where(base_token:base_token,token_symbol:token_symbol,type:1).maximum("price");
    max_amount = 0
    if sell_max && buy_max
      if buy_max.mamount > sell_max.mamount
        max_amount = buy_max.mamount
      else
        max_amount = sell_max.mamount
      end
    elsif sell_max == nil && buy_max != nil
      max_amount = buy_max.mamount
    elsif sell_max != nil && buy_max == nil
      max_amount = sell_max.mamount
    end    
    json_data = {
      "buy":buy_orders,
      "sell":sell_orders,
      "max_amount":max_amount,
      "best_asks":best_asks,
      "best_bids":best_bids,      
    }
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end
  def get_owner_data
    account_address = params[:account_address]
    base_token = params[:base_token]
    my_orders = Order.where(base_token:base_token,maker_address:account_address).order(updated_at: :desc)
    order_exist = false
    trade_exist = false
    if my_orders.length > 0
      order_exist = true
    end
    my_trades = TradeHistory.where("base_token = ? AND maker_address = ? OR taker_address = ?",base_token,account_address,account_address).order(updated_at: :desc)
    if my_trades.length > 0
      trade_exist = true
    end
    json_data = {
      "order_exist":order_exist,
      "orders":my_orders,
      "trade_exist":trade_exist,
      "trades":my_trades
    }
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end
  def get_matching_orders
    token_symbol = params[:symbol]
    trade = params[:trade]
    price = params[:price]
    amount = params[:amount]
    base_token = params[:base_token]
    if trade == "buy"
      type = 0
    else
      type = 1
    end    
    order = Order.where(token_symbol:token_symbol,type:type,base_token:base_token,price:price,amount:amount ).first
    if order
      signed_order = OrderDetail.where(id:order.detail_id).first
      json_data = {
        "status":"matched",
        "data":signed_order
      }
      respond_to do |format|
        format.json { render :json => json_data}
      end
    else
      smile_order = Order.where(token_symbol:token_symbol,type:type,base_token:base_token,price:price).order(amount: :desc).first;
      if smile_order
        signed_order = OrderDetail.where(id:smile_order.detail_id).first
        if smile_order.amount > amount.to_f
          json_data = {
            "status":"large_match",
            "data":signed_order,
            "db_amount":smile_order.amount
          }
          respond_to do |format|
            format.json { render :json => json_data}
          end
        else
          json_data = {
            "status":"small_match",
            "data":signed_order,
            "db_amount":smile_order.amount
          }
          respond_to do |format|
            format.json { render :json => json_data}
          end
        end  
      else
        json_data = {
          "status":"no_match"
        }
        respond_to do |format|
          format.json { render :json => json_data}
        end
      end
    end
  end
  def delete_order
    detail_id = params[:detail_id]
    # Get Order id from order detail_id
    order = Order.where(detail_id:detail_id).first
    order_id = order.id    
    OrderDetail.find(detail_id).destroy
    OrderBroadcastJob.perform_later("remove",order)
    Order.find(order_id).destroy
    json_data = {"status":"ok"}
    respond_to do |format|
      format.json{ render :json => json_data }
    end
  end
  def delete_orders id
    order = Order.find(id)
    detail_id = order.detail_id    
    OrderDetail.find(detail_id).destroy
    OrderBroadcastJob.perform_later("remove",order)
    Order.find(id).destroy
  end
  def delete_my_order
    order_id = params[:order_id]
    # Get order from id
    order = Order.where(id:order_id).first
    detail_id = order.detail_id    
    OrderDetail.find(detail_id).destroy
    OrderBroadcastJob.perform_later("remove",order)
    Order.find(order_id).destroy
    json_data = {"status":"ok"}
    respond_to do |format|
      format.json{ render :json => json_data }
    end
  end
  def delete_my_orders
    account_address = params[:account_address]
    del_orders = Order.where(maker_address:account_address)
    if del_orders.length > 0
      del_orders.each_with_index do |del_order, index|
        order_id = del_order.id
        # Get order and order detail
        detail_id = del_order.detail_id           
        OrderDetail.find(detail_id).destroy
        OrderBroadcastJob.perform_later("remove",del_order)
        Order.find(order_id).destroy      
      end
    end
    json_data = {"status":"ok"}
    respond_to do |format|
      format.json{ render :json => json_data }
    end

  end
  def update_order    
    detail_id = params[:detail_id]
    amount = params[:amount]
    # logger.debug(amount)
    order = Order.where(detail_id:detail_id).first
    order.amount = amount
    order.save
    json_data = {"status":"update_order"}
    respond_to do |format|
      format.json{ render :json => json_data }
    end

  end
  def update_orders(id,amount)
    order = Order.where(id:id).first
    order.amount = amount
    order.save
  end
  def create_order
    signed_order = params[:signed_order]
    state = params[:state]
    type = params[:type]
    base_token = params[:base_token]
    token_symbol = params[:token_symbol]
    amount = params[:amount]
    token_price = params[:price]
    expire = params[:expire]
    expire_date = params[:expire_date]
    taker_amount = params[:taker_amount]
    maker_amount = params[:maker_amount]
    maker_address = params[:maker_addr]   
    token_addr = params[:token_addr]
    trade_fee = params[:trade_fee]
    order_hash = params[:order_hash]

    set_allow = '' 
    tx_hash = ''   
    token_allow = getTokenAllowance token_addr
    if token_allow == 0
      set_allow = 'set_token_allow'
      tx_hash = setTokenAllowance token_addr
    else
      set_allow = 'not set_token_allow'
    end

    detail = OrderDetail.new
    detail.signedorder = signed_order
    detail.expire = expire_date
    detail.taker_amount = taker_amount
    detail.maker_amount = maker_amount
    detail.save
    detail_id = detail.id

    # Save Order to db
    order = Order.new
    order.type = type
    order.state = state
    order.base_token = base_token
    order.token_symbol = token_symbol
    order.amount = amount
    order.price = token_price
    order.order_hash = order_hash
    order.fee = trade_fee
    order.expire = expire
    order.detail_id = detail_id
    order.maker_address = maker_address
    order.save

    result = batchfillOrder(type.to_i,token_price.to_f,amount.to_f,base_token,token_symbol) 
       
    json_data = 
    {
      "status":"ok",
      "result":result,
      "token_allow":tx_hash
    }
    respond_to do |format|
      format.json{ render :json => json_data }
    end
  end
  def create_trade_history
    symbol = params[:symbol]
    type = params[:type]
    maker_address = params[:maker_addr]
    taker_address = params[:taker_addr]
    price = params[:price]
    amount = params[:amount]
    base_token = params[:base_token]
    txHash = params[:txHash]
    
    # Save Data to TradeHistory table
    trade = TradeHistory.new
    trade.base_token = base_token
    trade.token_symbol = symbol
    trade.type = type
    trade.maker_address = maker_address
    trade.taker_address = taker_address
    trade.price = price
    trade.amount = amount
    trade.save

    json_data = {"status":"ok"}
    respond_to do |format|
      format.json{ render :json => json_data}
    end
  end
  def create_trade_histories(symbol,type,maker_address,taker_address,price,amount,base_token,txHash)
    # Save Data to TradeHistory table
    trade = TradeHistory.new
    trade.base_token = base_token
    trade.token_symbol = symbol
    trade.type = type
    trade.maker_address = maker_address
    trade.taker_address = taker_address
    trade.price = price
    trade.amount = amount
    trade.txHash = txHash
    trade.save
  end
  def get_trade_history
    symbol = params[:symbol]
    base_token = params[:base_token]
    trade_histories = TradeHistory.where(base_token:base_token,token_symbol:symbol).order(updated_at: :desc)
    json_data = {
      "status":"ok",
      "data":trade_histories
    }
    respond_to do |format|
      format.json{ render :json => json_data }
    end
  end
  def get_signed_order
    order_id = params[:address]
    signed_order = OrderDetail.where(id:order_id).order(updated_at: :desc)
    json_data = {
      "status":"ok",
      "data":signed_order,
      "id":order_id
    }
    respond_to do |format|
      format.json{ render :json => json_data }
    end
  end
  def show

  end
end
