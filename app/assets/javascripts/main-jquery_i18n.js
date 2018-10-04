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
    if ($("#trade_workspace").length) {
      if (currentWalletAddress) {
        $("#message_body").prop({
          placeholder: $.i18n('enter_message')
        });
      } else {
        $("#message_body").prop({
          placeholder: $.i18n('connect_wallet')
        });
      }

    }
    

  };

  $('.lang-switch').click(function(e) {
    e.preventDefault();
    $.i18n().locale = $(this).data('locale');    
    update_texts();
    //window.tvWidget.setLanguage($(this).data('locale'));

    if ($("#trade_workspace").length) {
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
      datafeed: new Datafeeds.UDFCompatibleDatafeed('https://tokenmom.com/api/v1/datafeeds'),
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
  }
}
);

  $.i18n().load({
    'en': {
      'reward': 'REWARD',
      'tokenmom': 'TOKENMOM',
      'invest_future': 'Invest in Future Value',
      'korea_first_decentral': 'KOREA\'s First Futuristic Real Decentralized Exchage',
      'our_goal_is': 'Our goal is your investment success not ours!',
      'start_trading': 'Start Trading',
      'buy_tm_token': 'Buy TM Token',
      'whitepaper_eng': 'Whitepaper(Eng)',
      'whitepaper_kor': 'Whitepaper(Kor)',
      'advantage': 'ADVANTAGES',
      'no_sign_up_required': 'No Sign Up Required',
      'no_sign_up_required_detail': 'Tokenmom is anonymous and do not need to sign up for trading. It is true decentralized exchange that helps to trade in realtime between individuals by using personal wallets(Metamask, Ledger nano hardware wallet)',
      'no_kyc': 'No KYC For Confirming Personal Identification',
      'no_kyc_detail': 'Start securely trading without any identity verification. No personal information is required.',
      'no_deposit': 'No Deposit/Withdraw',
      'no_deposit_detail': 'Tokenmom does not ask additional deposit and withdrawal. Only with Metamask and Ledger Nano S hardware wallet, users can trade their tokens in real-time anywhere, anytime.',
      'no_hacking': 'No Hacking',
      'no_hacking_detail': 'Even if Tokenmom exchange is hacked or closed, it does not have to worry about it because users own still the assets in their personal wallet.',
      'key_points': 'KEY POINTS',
      'easy_interface': 'Easy & Simple Interface',
      'lowest_fee': 'Lowest Trading Fee',
      'lowest_fee_detail': 'At the same time as Tokenmom is opened, the FEE for buy/sell or maker/taker for all transactions is 0%.',
      'ethereum_based_trading': 'All Ethereum Based Token\'s Trading',
      'ethereum_based_trading_detail': 'Don\'t just wait for your tokens to be listed on the exchange.Any ethereum based token\'s trade is possible as you want.',
      'multi_languages_supported': 'Multi Languages Supported Interface',
      'multi_languages_supported_detail': 'Tokenmom supports English, Korean, Chinese and Japanese too. More and more languages coming soon.',
      'our_token': 'Tokenmom token',
      'tokenmom_exchange_token': 'Tokenmom Exchange Token(TM)',      
      'tokenmom_introduce': 'Tokenmom Exchange introduces it\'s own TM token.',
      'tokenmom_introduce_1': 'It sells only 30% of total supply, and it does not proceed with ICO etc, which can only be purchased on Tokenmom Exchange. We do not know whether it will be listed in other exchanges.',
      'tokenmom_introduce_2': 'In order to maximize the profit of the initial investors, the price will be differentiated step by step and so the earlier investment profit will be maximized.',
      'tokenmom_introduce_3': 'The target price of TM Token is 0.001$(about 11.6 KRW). Thus, investors who invest first become more profitable. We also aim to operate TM Market and the fee will be lower than ETH market, and the fee will be received as TM token, which helps Tokenmom exchange to regain TM token and so more profitable for investors. This depends on the success of both TM token\'s sales and Tokenmom exchange.',
      'token_distribution': 'Token Distribution',
      'usage': 'Usage',
      'usage_40': '- 40%(8,000,000,000) Free TM token to exchange users',
      'usage_30': '- 30%(6,000,000,000) Founder, team, exchange maintenance',
      'usage_20': '- 20%(4,000,000,000) Price stability and maintenance of TM token',
      'usage_10': '- 10%(2,000,000,000) Reserved funds to prepare for problems',
      'who_are_we': 'Who are We?',
      'who_are_we_detail_1': 'We started off on the basis of a number of human resources based in Asian countries, and we were born planning an anonymous decentralized exchange.So where is our headquarter? China, Japan, Korea, Tiwan, Singapore, Thailand, Vietnam, the Philippines, Laos, India, Indonesia, etc.? Don\'t wonder. It\'s near you.',
      'who_are_we_detail_2': 'Our team members are distributed all over the world and united for anonymous Decentralized Exchange.',
      'who_are_we_detail_3': 'We are an exchange for the activation of fair trade between anounymous individuals.',
      'who_are_we_detail_4': 'Do not forget that those who know true future values must win.',
      'exchange_app': 'Exchange App',
      'appstore': 'App Store',
      'android': 'Android',
      'coming_soon': 'Coming Soon …',
      'question': 'QUESTION',
      'what_is_tokenmom': 'What is the Tokenmom?',
      'what_is_tokenmom_answer': 'TokenMom is the Korean\'s First Futuristic Real Decentralized Exchange',
      'how_purchase_tm_token': 'How can I purchase TM token?',
      'how_purchase_tm_token_answer': 'Tokenmom does not proceed with ICO etc, which can only be purchased on Tokenmom Exchange.',
      'how_much_trade_fee': 'How much is the trade fee?',
      'how_much_trade_fee_answer': 'Free trading fee for 2 months, After 2 months, the highest fee shall be 0.05% or less',
      'contact_us': 'Contact Us',
      'have_question': 'Have questions? We\'re happy to help',
      'contact_us_with_question': 'Contact us with any questions regarding TokenMom exchange',
      'send_message': 'Send Message',

      //Reward Page
      'tokenmom_reward_system': 'TOKENMOM REWARD SYSTEM',
      'with_referral_system': 'WITH REFERRAL SYSTEM',
      'pending:': 'Pending :',


      
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
      //Footer
      'terms_and_conditions': 'Terms and Conditions',
      'privacy_policy': 'Privacy Policy',
      'support': 'Support',
      'token_listing': 'Token Listing',
      'support_center': 'Support Center',
      'contact': 'Contact',
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
      'reward': '보상',
      'tokenmom': '토큰맘',
      'invest_future': '미래가치에 투자',
      'korea_first_decentral': '한국 최초의 미래 지향적인 분산 교환',
      'our_goal_is': '우리의 목표는 귀하의 투자 성공입니다.',
      'start_trading': '거래 시작',
      'buy_tm_token': 'TM토큰 구매',
      'whitepaper_eng': '백서(영어)',
      'whitepaper_kor': '백서(한국어)',
      'whitepaper': '백서',
      'advantage': '장점',
      'no_sign_up_required': '가입필요없음',
      'no_sign_up_required_detail': '토큰맘은 익명으로 거래에 등록 할 필요가 없습니다.개인 지갑(메타마스크,네이저)을 사용하여 개인간에 실시간으로 거래하는데 도움이되는 진정한 분산된 교환입니다.',
      'no_kyc': '개인 신분 확인을위한 KYC 없음',
      'no_kyc_detail': '신원 확인없이 안전하게 거래를 시작하십시오. 개인 정보는 필요하지 않습니다.',
      'no_deposit': '예금/출금 없음',
      'no_deposit_detail': '토큰맘은 추가 예금 및 인출을 요구하지 않습니다. 메타마스크 및 네이져 하드웨어 지갑을 사용하는 경우에만 언제 어디서나 실시간으로 토큰을 교환 할 수 있습니다.',
      'no_hacking': '해킹 못함',
      'no_hacking_detail': '토큰맘 교환이 해킹되거나 닫히더라도 사용자가 개인 지갑의 자산을 여전히 소유하고 있으므로 걱정할 필요가 없습니다.',
      'key_points': '주요 사항',
      'easy_interface': '쉽고 간단한 인터페이스',
      'lowest_fee': '최저 거래 수수료',
      'lowest_fee_detail': '토큰맘은 오픈과 동시에 모든 거래에 대하여 매수/매도 또는 Maker/Taker에 대한 수수료는 0%다.',
      'ethereum_based_trading': '모든 이더리움 기반 토큰 거래',
      'ethereum_based_trading_detail': '거래소에 토큰이 상장되기만을 기다리지 마십시요.모든 이더리움기반 토큰거래가 원하는 대로 가능합니다.',
      'multi_languages_supported': '다국어지원 인터페이스',
      'multi_languages_supported_detail': '토큰맘은 영어, 한국어, 중국어, 일본어도 지원합니다. 곧 더 많은 언어가 출시 될 예정입니다.',
      'our_token': '토큰맘 토큰',
      'tokenmom_exchange_token': '토큰맘 거래소 토큰(TM)',
      'tokenmom_introduce': '토큰맘거래소의 자체코인 TM토큰을 소개한다.',
      'tokenmom_introduce_1': '총 발행량의 30%만 판매하며,별도의 ICO등은 진행하지 않으므로, 토큰맘 거래소에서만 구입할수가 있다.향후 타거래소에 상장추진 여부는 알수가 없다.',
      'tokenmom_introduce_2': '최초 투자자들의 수익을 극대화 하기 위하여,판매가격은 단계별로 가격을 상이하게 할 예정이므로,먼저 투자할수록 투자수익은 극대화된다.',
      'tokenmom_introduce_3': 'TM 토큰의 목표가격 은 0.01$(약 11.6원)이다.따라서 먼저 투자하는 투자자들에게 수익이 더 많아진다.또한 TM 자체마켓을 운영할 목표로 하고 있으며, TM마켓을 이용시 ETH마켓보다 수수료는 최저로 운영할 방침이며, 수수료를 TM 토큰으로 받으므로, 토큰맘거래소가 다시 TM 토큰을 회수하는 효과가 있어 투자자들의 수익에 도움이 된다.이는 TM토큰 판매성공과 토큰맘의 성공여부에 달려있다.',

      'token_distribution': '토큰 분포',
      'usage': '사용량',
      'usage_40': '- 40%(8,000,000,000) 토큰맘 거래소를 이용하는 모든 이용자들에게 거래대금에 따른 일정비율로 보상',
      'usage_30': '- 30%(6,000,000,000) 토큰맘 거래소를 운영하기 위한 자금',
      'usage_20': '- 20%(4,000,000,000) TM토큰의 가격안정성 및 유지관리',
      'usage_10': '- 10%(2,000,000,000) 향후 각종 문제발생시를 대비하기 위한 예비자금',

      'who_are_we': '우리는 누구인가?',
      'who_are_we_detail_1': '우리는 아시아 여러 나라에 기반을 한 다수의 인적자원을 기반으로 시작하여, 익명의 탈중앙화거래소를 기획하면서 탄생하였다.따라서 우리의 본거지가 중국, 일본, 대한민국, 타이완, 싱가포르, 타이, 베트남, 필리핀, 라오스, 인도, 인도네시아등 그 어디인가? 궁금해 하지 말라.여러분 가까이에 있다.',
      'who_are_we_detail_2': '우리의 팀원들은 전세계적으로 분포되어 있으며, 익명의 탈중앙화거래소(Anonymous Decentralized Exchange)를 위하여 뭉쳤다.',
      'who_are_we_detail_3': '익명의 개인들 간의 공정한 거래활성화를 위한 거래소다.',
      'who_are_we_detail_4': '진정한 미래가치를 아는 자가 반드시 승리한다는 것을 잊지말라.',
      'exchange_app': '교환 앱',
      'appstore': '앱스토',
      'android': '앤드로이드',
      'coming_soon': '곧 출시됩니다 …',
      'question': '질문',
      'what_is_tokenmom': '토큰맘?',
      'what_is_tokenmom_answer': '국내(한국) 최초의 미래형 탈중앙화 거래소',
      'how_purchase_tm_token': 'TM토큰 구입방법?',
      'how_purchase_tm_token_answer': '별도위 ICO등은 진행하지 않으므로,토큰맘 거래소에서만 구입할수가 있다.',
      'how_much_trade_fee': '거래 수수료는 얼마인가?',
      'how_much_trade_fee_answer': '오픈시 거래소 수수료 2개월간 무료, 2개월뒤 최고 수수료 0.05% 이하',
      'contact_us': '문의',
      'have_question': '질문이 있습니까? 기꺼이 도와드리겠습니다.',
      'contact_us_with_question': '토큰맘 거래소에 관한 문의 사항은 당사에 문의 하십시오.',
      'send_message': '문자 보내기',
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
      //Footer
      'terms_and_conditions': '이용약관',
      'privacy_policy': '개인 정보 정책',
      'support': '지원',
      'token_listing': '토큰 상장',
      'support_center': '지원센터',
      'contact': '콘텍트',

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
      'trade' : '거래',
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
