jQuery(function($) {
  $(document).ready(function() {
  var update_texts = function() {
    $('body').i18n();
    // $('#messages').text($.i18n('message_from', 'Ann', 2, 'female'));
    // $("#message_body").prop({
    //   placeholder: $.i18n('enter_message')
    // });
    // $("#symbol_input").prop({
    //   placeholder: $.i18n('search..')
    // });
    // $(".wallet-search-input").prop({
    //   placeholder: $.i18n('search..')
    // });   
    if(currentWalletAddress){
      $("#message_body").prop({
        placeholder: $.i18n('enter_message')
      });
    }else{
      $("#message_body").prop({
        placeholder: $.i18n('connect_wallet')
      });
    }

  };

  $('.lang-switch').click(function(e) {
    e.preventDefault();
    $.i18n().locale = $(this).data('locale');    
    update_texts();
    //window.tvWidget.setLanguage($(this).data('locale'));
    window.tvWidget.remove();
    const toolbar_bg_dark = '#141414';
    const toolbar_bg_light = '#ffffff';
    let token_symbol = localStorage.getItem("select_token") || "ZRX"
    let locale = $(this).data('locale');

    token_symbol = $(".token-info").attr("token_symbol");
    base_token = $(".token-info").attr("base_token");
    symbol_pair = token_symbol + " " + base_token;
    var widget = window.tvWidget = new TradingView.widget({
      symbol: symbol_pair,
      interval: '1D',
      pricescale: 1000000,
      toolbar_bg: toolbar_bg_dark,
      allow_symbol_change: false,
      container_id: 'tv_chart_container',
      datafeed: new Datafeeds.UDFCompatibleDatafeed('https:tokenmom.com/api/v1/datafeeds'),
      library_path: '/assets/charting_library/',
      locale: getLanguageFromURL() || locale,
      overrides: override_dark,
      studies_overrides: {},
      charts_storage_url: 'http://saveload.tradingview.com',
      client_id: 'tradingview.com',
      user_id: 'public_user_id',
      fullscreen: false,
      autosize: true,
      custom_css_url: "theme_style.css",
      loading_screen: { backgroundColor: "#000000", foregroundColor: "#000000" },
      disabled_features: [
        "support_multicharts",
        "header_symbol_search",
        "header_interval_dialog_button",
        "symbol_search_hot_key",
        "show_interval_dialog_on_key_press",
        "left_toolbar"],
      enabled_features: [
        "move_logo_to_main_pane",

      ]
    });
    widget.onChartReady(() => {

      if (localStorage.getItem('theme_color') == "dark") {
        window.tvWidget.applyOverrides(override_dark);
        window.tvWidget.changeTheme("Dark");
      } else if (localStorage.getItem('theme_color') == "light") {
        window.tvWidget.applyOverrides(override_light);
        window.tvWidget.changeTheme("Light");
      } else {
        window.tvWidget.applyOverrides(override_dark);
        window.tvWidget.changeTheme("Dark");
      }
      window.tvWidget.chart().removeAllStudies();
      window.tvWidget.chart().createStudy("volume", false, false);

    });    
  });

  $.i18n().load({
    'en': {
      //Header
      'select_wallet': 'Select Wallet',
      'login_metamask': 'Login to MetaMask',
      'no_accounts_detected' : 'No accounts detected',
      'metamask' : 'MetaMask',
      'ledger' : 'Ledger',
      'disconnect' : 'DISCONNECT',
      'metamask_connected' : 'Metamask Connected',
      'ethereum_main' : 'Ethereum Main',
      'need_help': 'NEED HELP?',
      'why_do_i_need_a_wallet': 'Why do I need a wallet?',
      'tokenmom': 'TOKENMOM',
      'connect_wallet': 'Connect a Wallet',
      'nick_name' : 'Nick Name',
      'wrong_network': 'Warning!! You are on the wrong network.Please open MetaMask and switch over to the Mainnet Ethereum Network.',
      //
      'welcome': 'Welcome!',
      'message_from': '$1 has send you $2 {{plural:$2|message|messages}}. {{gender:$3|He|She}} is waiting for your response!',
      'wallet' : 'Wallet',
      'orders' : 'Orders',
      'help' : 'Help',
      'trade_by_addr' : 'Trade by Address',
      'last_price' : 'Last Price',
      '24h_price' : '24H Change',
      '24h_volumn' : '24H Volume',
      'contract_address' : 'Contract Address',
      'trade_notlistedtoken' : 'Trade not listed token',
      'token_address' : 'Token Address:',
      'submit': 'Submit',
      'cancel': 'Cancel',
      'ok':'OK',
      'cannot_find_token_byaddr': 'Couldn\'t find token by address',
      'no_token_with_address': 'There are no deployed ERC20 token with such address.',
      'please_check_address': 'Please double check the address.',
      'connect_your_wallet': 'You have to connect your wallet.',
      //market_widget
      'pair' : 'Token',
      'markets' : 'MARKETS',
      'search..' : 'Search..',
      //social widget
      'chat' : 'CHAT',
      'twitter' : 'TWITTER',
      'enter_message' : 'Enter new Message',
      'connect_wallet' : 'Connect wallet to Chat',
      //trade widget
      'trade' : 'TRADE',
      'opne_order': 'OPEN ORDER',
      'quick_balance' : 'QUICK BALANCE',
      'wrap' : 'WRAP',
      'unwrap' : 'UNWRAP',
      'search' : 'Search',
      'limit_price' : 'Limit Price',
      'best_ask' : 'Lowest Ask',
      'best_bid' : 'Highest Bid',
      'total≈' : 'Total ≈ ',
      'fee≈' : 'Fee ≈ ',
      'allowance' : 'Allowance',
      'buy' : 'Buy',
      'sell' : 'Sell',
      'cancel' : 'Cancel',
      'wallet_not_connected': 'Wallet is not connected',
      'need_connect_wallet': 'You need to connect your wallet from the top menu',
      //orderbook widget
      'order_book' : 'ORDER BOOK',
      'size' : 'Size',
      'price' : 'Price',
      'amount' : 'Amount',
      'depth' : 'Depth',
      'spread' : 'Spread',
      'real_time' : 'Realtime',
      'success' : 'Success',
      'create_order': 'You have been created order in successfully!',
      'create_trade': 'Your order has been successfully completed.',
      //trade history widget
      'trade_history' : 'TRADE HISTORY',
      'all_trades' : 'ALL TRADES',
      'my_trades' : 'My TRADES',
      'state' : 'State',
      'time' : 'Time',
      //wallet widget
      'symbol' : 'Token',
      'available':'Available',
      'name' : 'Name',
      'address' : 'Address',
      'balance' : 'Balance',
      'tradable/untradable' : 'Tradable/Untradable',
      'only_show_balance' : 'Only show my balance',
      //account widget
      'account' : 'Account',
      'all_open_orders' : 'ALL OPEN ORDERS',
      'all_trades' : 'ALL TRADES',
      'token' : 'Token',
      'side' : 'Side',
      'action' : 'Action',
      'cancel_all' : 'Cancel All',
      'total:' : 'Total(Buy/Sell):',
	    'no_more_data' : 'No more data'
	  
    },
    'ko': {
      //Header
      'select_wallet': '지갑선택',
      'login_metamask': '메타마스크에서 로그인',
      'no_accounts_detected': '계정없음',
      'metamask': '메타마스크',
      'ledger': '렛저나노',
      'disconnect' : '연결해제',      
      'metamask_connected': '메타마스크로 연결됨',
      'ethereum_main': '이더리움 메인넷',
      'need_help': '도움이 필요한가요?',
      'why_do_i_need_a_wallet': '지갑이 왜 필요한가요?',
      'tokenmom': '토큰맘',
      'connect_wallet' : '지갑을 연결하세요',
      'nick_name': '닉네임을 입력해주세요.',
      'wrong_network': '잘못된 네트워크에 연결되였습니다.메타마스그 지갑에서 Mainnet로 전환시켜주십시오.',

      //
      'wallet' : '지갑',
      'orders' : '주문',
      'help' : '지원',
      'trade_by_addr' : '토큰주소로 거래',
      'last_price' : '현재가',
      '24h_price' : '24시 변동률',
      '24h_volumn' : '24시 거래량',
      'contract_address' : ' 컨트랙트 주소',
      'trade_notlistedtoken': '마켓에 상장되지 않은 토큰거래',
      'token_address': '토큰주소:',
      'submit': '확인',
      'cancel': '취소',
      'ok': '예',
      'cannot_find_token_byaddr': '입력하신 주소로 토큰을 찾을수 없습니다',
      'no_token_with_address': '입력하신 주소로 배포된 ERC20토큰이 없습니다',
      'please_check_address': '주소를 다시 한번 확인해 주십시오.',
      'connect_your_wallet': '당신의 지갑을 연결하십시오.',
      //market_widget
      'pair' : '토큰',
      'markets' : '마켓',
      'search..' : '검색..',
      //social widget
      'chat' : '채팅',
      'twitter' : '트위터',
      'enter_message' : '메시지를 입력해주세요',
      'connect_wallet': '계정을 연결하십시오.',
      //trade widget
      'trade' : '거래하기',
      'opne_order': '미체결 주문 ',
      'quick_balance' : '빠른 입출금',
      'wrap' : 'ETH 입금',
      'unwrap' : 'ETH 출금',
      'search' : '검색',
      'limit_price' : '지정가주문',
      'best_ask' : '최저매도가',
      'best_bid' : '최고매수가',
      'total≈' : '주문총액 ≈ ',
      'fee≈' : '수수료 ≈ ',
      'allowance': '거래허용',
      'buy': '매수',
      'sell': '매도',
      'cancel': '취소',
      'wallet_not_connected': '지갑이 연결되지 않았습니다',
      'need_connect_wallet': '톱메뉴에서 지갑을 연결해야 합니다',
      //orderbook widget
      'order_book' : '주문장부',
      'size' : '규모',
      'price' : '가격',
      'amount' : '주문량',
      'depth' : '깊이',
      'spread' : '가격차이',
      'real_time' : '실시간 주문차',
      'success': '성공',
      'create_order': '성공적으로 주문을 완료하였습니다!',
      'create_trade': '성공적으로 주문이 체결되었습니다!',
      //trade history widget
      'trade_history' : '거래 내역',
      'all_trades' : '모든 거래내역',
      'my_trades' : '내 거래내역',
      'time' : '시간',
      'state' : '상태',
      //wallet widget
      'symbol' : '토큰',
      'name' : '토큰명',
      'address' : '컨트랙트 주소',
      'balance' : '잔액',
      'available': '사용가능 잔액',
      'tradable/untradable' : '거래허용/거래중지',
      'only_show_balance' : '보유토큰만 보기',
      //account widget
      'account' : '계정',
      'all_open_orders' : '미체결 주문',
      'all_trades' : '모든 거래내역',
      'token' : '토큰',
      'side' : '구분',
      'action' : '취소',
      'cancel_all' : '모두취소',
      'total:' : '총합계(매수/매도):',
	    'no_more_data' : '거래내역이 없습니다'
    },
    'ja': {

    },
    'zh': {

    }
  });

  update_texts();
});

});
