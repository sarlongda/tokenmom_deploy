let TESTRPC_NETWORK_ID = 3;
// Provider pointing to local TestRPC on default port 8545
let provider;
let zeroEx;
let currentWalletAddress;
let web3Status;
let http_link = "https://ropsten.etherscan.io/";
// Ropsten Net
let wethAddress = "0xc778417e063141139fce010982780140aa0cd5ab";
const zrxAddress = "0xa8e9fa8f91e5ae138c74648c9c304f1c75003a8d";
const tmAddress = "0x91495D6969120fc016BB687EaD5F5cE56F135504";
const weth_decimals = 18;
const tm_decimals = 18;

let max_trading_eth = 100;
let max_trading_tm = 100000000;
let max_token_amount = 100000000;
const txOpts = {
    gasLimit: 89000,
    gasPrice: new BigNumber(20000000000)
};
let fee_percent = 0.05;
let tm_fee_percent = 0.01;
let initial_tm_fee = 50;
let initial_fee = 0.002;
let reward_request_amount = 5000;
jQuery(function($) {        
    $(document).ready(function () {
        function load_js(){            
            if ($("#trade_workspace").length) {
                metamask_login_emt = document.getElementById("metamask_login");
                metamask_login_emt.onclick = function () { metamask_login() };
            }
            if ((typeof web3) !== 'undefined') {
                web3Status = 1;
                provider = web3.currentProvider;
                web3 = new Web3(provider);
                web3.version.getNetwork((err, netId) => {
                    TESTRPC_NETWORK_ID = netId;
                    switch (netId) {
                        case "1":
                            console.log('This is mainnet');
                            wethAddress = "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2";
                            break;
                        case "2":
                            console.log('This is the deprecated Morden test network.');
                            break;
                        case "3":
                            console.log('This is the ropsten test network.');
                            wethAddress = "0xc778417e063141139fce010982780140aa0cd5ab";
                            break;
                        case "4":
                            console.log('This is the Rinkeby test network.');
                            break;
                        case "42":
                            console.log('This is the Kovan test network.');
                            wethAddress = "0xd0a1e359811322d97991e03f863a0c30c2cf029c";
                            break;
                        default:
                            console.log('This is an unknown network.');
                    }
                });
                const configs = {
                    networkId: TESTRPC_NETWORK_ID,
                };
                zeroEx = new ZeroEx.ZeroEx(provider, configs);
                //web3Wrapper = new ZeroEx.ZeroEx(provider, configs);
                // new Web3ProviderEngine();
                const accountAsync = async () => {
                    var account = web3.eth.accounts.length > 0 ? web3.eth.accounts[0] : 0;
                    currentWalletAddress = account;
                    if ($("#trade_workspace").length) {
                        auto_login();
                        setInterval(function () {
                            if (web3.eth.accounts[0] !== account) {
                                account = web3.eth.accounts[0];
                                currentWalletAddress = account;
                                if (currentWalletAddress === null || currentWalletAddress === undefined) {
                                    clear();
                                }
                                auto_login();
                            }
                        }, 100);
                    }
                };
                accountAsync().catch(console.error);
            }
            else {
                web3Status = 0;
            }

        }
        
        $(document).on('click','#cancel_metamask_login',function(){
            metamask_cancel();
        });
        $(document).on('click', '#cancel_metamask_install', function(){
            metamask_cancel();
        });
        $(document).on('click', '#metamask_install', function () {
            metamask_install();
        });
        function metamask_cancel() {
            var connection_status_ele = document.getElementById("connection_status");
            document.getElementById('sign_in').style.display = "block";
            document.getElementById('metamask_logined').style.display = "none";
            document.getElementById('metamask_install').style.display = "none";
            document.getElementById('metamask_logoutted').style.display = "none";
            //document.getElementById('connected_info').textContent = 'No accounts detected';
            //document.getElementById('connected_wallet').textContent = 'Select Wallet';
            $('#connected_wallet').attr('data-i18n', 'select_wallet');
            $('#connected_wallet').text($.i18n('select_wallet'));
            $('#connected_info').attr('data-i18n', 'no_accounts_detected');
            $('#connected_info').text($.i18n('no_accounts_detected'));
            connection_status_ele.classList.add("not-connected");
            connection_status_ele.classList.remove("connection-issue");
            connection_status_ele.classList.remove("connected");
        }
        function metamask_install() {
            var win = window.open('https://metamask.io/', '_blank');
            win.focus();
        }
        function auto_login() {
            if (currentWalletAddress !== undefined && currentWalletAddress != null && currentWalletAddress !== 0) {
                var get_user = async () => {
                    $.ajax({
                        url: '/user_sessions/get_user',
                        type: 'GET',
                        dataType: 'json',
                        data: {
                            wallet_address: currentWalletAddress
                        },
                        success: function (response) {
                            if (response === null) {
                                return;
                            }
                            var nick_name = response['nick_name'];
                            $('#message_body').attr('data-user-id', response['id']);
                            $('#message_body').attr('data-i18n', '[placeholder]enter_message');
                            $('#message_body').attr('placeholder',$.i18n('enter_message'))                                                           
                            $('#message_body').attr('disabled', false);                                
                            $.ajax({
                                url: '/user_sessions/user_login',
                                type: 'POST',
                                dataType: 'json',
                                data: {
                                    login_type: 'META_MASK',
                                    wallet_address: currentWalletAddress,
                                    nick_name: nick_name
                                },
                                success: function (response) {
                                    if (response === null || response === undefined) {
                                        return;
                                    }
                                    document.getElementById('connected_info').textContent = normalize_string(currentWalletAddress);
                                    document.getElementById('sign_in').style.display = "none";
                                    document.getElementById('metamask_install').style.display = "none";
                                    document.getElementById('metamask_logoutted').style.display = "none";
                                    document.getElementById('metamask_logined').style.display = "block";
                                    document.getElementById('wallet_address').textContent = normalize_string(currentWalletAddress);
                                    //document.getElementById('connected_wallet').textContent = 'Metamask';                                        
                                    $('#connected_wallet').attr('data-i18n','metamask');
                                    $('#connected_wallet').text($.i18n('metamask'));
                                    $('#wallet_address').attr('href',http_link+'address/'+currentWalletAddress);
                                    //$('body').i18n();
                                    //Change login Icon image;
                                    $("#connection_status").children("img").attr("src","/assets/wallet.svg");
                                    var connection_status_ele = document.getElementById("connection_status");
                                    connection_status_ele.classList.remove("not-connected");
                                    connection_status_ele.classList.remove("connection-issue");
                                    connection_status_ele.classList.add("connected");
                                    let token_contract_addr = $(".contract-address").children("a").attr("value");
                                    //Trade.get_token_amount(token_contract_addr);
                                    document.getElementById('metamask_disconnect').onclick = function () {
                                        $('#message_body').attr('data-user-id', '');
                                        $('#message_body').attr('data-i18n', '[placeholder]connect_wallet');
                                        $('#message_body').attr('placeholder', $.i18n('connect_wallet'));
                                        $('#message_body').attr('disabled', true);
                                        document.getElementById('sign_in').style.display = "block";
                                        document.getElementById('metamask_logined').style.display = "none";
                                        document.getElementById('metamask_install').style.display = "none";
                                        document.getElementById('metamask_logoutted').style.display = "none";
                                        //document.getElementById('connected_info').textContent = 'No accounts detected';
                                        //document.getElementById('connected_wallet').textContent = 'Select Wallet';
                                        $('#connected_wallet').attr('data-i18n', 'select_wallet');
                                        $('#connected_wallet').text($.i18n('select_wallet'));
                                        $('#connected_info').attr('data-i18n', 'no_accounts_detected');
                                        $('#connected_info').text($.i18n('no_accounts_detected'));
                                        $("#connection_status").children("img").attr("src", "/assets/lock.svg");
                                        connection_status_ele.classList.add("not-connected");
                                        connection_status_ele.classList.remove("connection-issue");
                                        connection_status_ele.classList.remove("connected");
                                        currentWalletAddress = undefined;
                                        document.getElementById("wallet_widget").children[0].classList.remove('is-active');
                                        //Remove token and weth balance in trade widget;
                                        $(".token-amount").removeAttr("value");
                                        $(".token-amount").removeAttr("weth_balance");
                                        $(".wallet").removeClass("is-active");
                                    };
                                }
                            });
                        }
                    });
                };
                get_user().catch(console.error);
            } else {
                var connection_status_ele = document.getElementById("connection_status");
                //document.getElementById("connected_info").textContent = 'No accounts detected';
                //document.getElementById("connected_wallet").textContent = 'Select Wallet';
                $('#connected_info').attr('data-i18n', 'no_accounts_detected');
                $('#connected_info').text($.i18n('no_accounts_detected'));
                $('#connected_wallet').attr('data-i18n', 'select_wallet');
                $('#connected_wallet').text($.i18n('select_wallet'));
                connection_status_ele.classList.add("not-connected");
                connection_status_ele.classList.remove("connection-issue");
                connection_status_ele.classList.remove("connected");
            }
        }
        function clear() {
                $('#message_body').attr('data-user-id', '');
                $('#message_body').attr('data-i18n', '[placeholder]connect_wallet');
                $('#message_body').attr('placeholder', $.i18n('connect_wallet'));                
                $('#message_body').attr('disabled', true);
                document.getElementById('sign_in').style.display = "block";
                document.getElementById('metamask_logined').style.display = "none";
                document.getElementById('metamask_install').style.display = "none";
                document.getElementById('metamask_logoutted').style.display = "none";
                //Wallet disable when metamask logout
                document.getElementById("wallet_widget").children[0].classList.remove('is-active');
        }
        function metamask_login() {
            var nick_name_ele = document.getElementById("nick_name");
            var nick_name = nick_name_ele.value;
            if (nick_name.length === 0 || !nick_name.trim()) {
                nick_name_ele.classList.add();
                return;
            }
            nick_name_ele.classList.remove();
            var account = web3.eth.accounts.length > 0 ? web3.eth.accounts[0] : 0;
            currentWalletAddress = account;
            if (currentWalletAddress !== undefined && currentWalletAddress != null && currentWalletAddress !== 0) {
                    refer_id = $(".navbar-brand").attr("refer_id");
                    
                    if(refer_id != "" && refer_id != null){

                    }
                    $.ajax({
                        url: '/user_sessions/user_login',
                        type: 'POST',
                        dataType: 'json',
                        data: {
                            login_type: 'META_MASK',
                            wallet_address: currentWalletAddress,
                            nick_name: nick_name,
                            refer_id:refer_id
                        },
                        success: function (response) {
                            $('#message_body').attr('data-user-id', response['id']);
                            $('#message_body').attr('data-i18n', '[placeholder]enter_message');
                            $('#message_body').attr('placeholder', $.i18n('enter_message'));
                            $('#message_body').attr('disabled', false);
                        }
                    });
                    let wallet_address = normalize_string(currentWalletAddress);
                    //document.getElementById('connected_info').textContent = normalize_string(currentWalletAddress);
                    $('#connected_info').attr('data-i18n', '');
                    $('#connected_info').text(wallet_address);
                    document.getElementById('sign_in').style.display = "none";
                    document.getElementById('metamask_logined').style.display = "block";
                    document.getElementById('metamask_install').style.display = "none";
                    document.getElementById('metamask_logoutted').style.display = "none";
                    //document.getElementById('wallet_address').textContent = normalize_string(currentWalletAddress);
                    //document.getElementById('connected_wallet').textContent = 'Metamask';
                    $('#wallet_address').attr('data-i18n', '');
                    $('#wallet_address').text(wallet_address);
                    $('#wallet_address').attr('href', http_link + 'address/' + currentWalletAddress);
                    //$('#wallet_address').children('a').text("Hello");
                    
                    $('#connected_wallet').attr('data-i18n', 'metamask');
                    $('#connected_wallet').text($.i18n('metamask'));
                    var connection_status_ele = document.getElementById("connection_status");
                    connection_status_ele.classList.remove("not-connected");
                    connection_status_ele.classList.remove("connection-issue");
                    connection_status_ele.classList.add("connected");

                    //Change login icon to wallet image;
                    $("#connection_status").children("img").attr("src", "/assets/wallet.svg");
                    //Get token balance and weth balance;
                    let token_addr = $(".contract-address").children("a").attr("value");
                    let base_token = $(".token-info").attr("base_token");
                    Trade.get_token_amount(token_addr,base_token);
                    document.getElementById('metamask_disconnect').onclick = function () {
                        $('#message_body').attr('data-user-id', '');
                        $('#message_body').attr('data-i18n', '[placeholder]connect_wallet');
                        $('#message_body').attr('placeholder', $.i18n('connect_wallet'));
                        $('#message_body').attr('disabled', true);
                        document.getElementById('sign_in').style.display = "block";
                        document.getElementById('metamask_logined').style.display = "none";
                        document.getElementById('metamask_install').style.display = "none";
                        document.getElementById('metamask_logoutted').style.display = "none";
                        //document.getElementById('connected_info').textContent = 'No accounts detected';
                        //document.getElementById('connected_wallet').textContent = 'Select Wallet';
                        $('#connected_wallet').attr('data-i18n', 'select_wallet');
                        $('#connected_wallet').text($.i18n('select_wallet'));
                        $('#connected_info').attr('data-i18n', 'no_accounts_detected');
                        $('#connected_info').text($.i18n('no_accounts_detected'));
                        //Change login icon to lock key icon
                        $("#connection_status").children("img").attr("src", "/assets/lock.svg");
                        connection_status_ele.classList.add("not-connected");
                        connection_status_ele.classList.remove("connection-issue");
                        connection_status_ele.classList.remove("connected");
                    }; 
            } else {
                if (web3Status === 1) {
                    document.getElementById('sign_in').style.display = "none";
                    document.getElementById('metamask_logined').style.display = "none";
                    document.getElementById('metamask_install').style.display = "none";
                    document.getElementById('metamask_logoutted').style.display = "block";
                } else if (web3Status === 0) {
                    document.getElementById('sign_in').style.display = "none";
                    document.getElementById('metamask_logined').style.display = "none";
                    document.getElementById('metamask_install').style.display = "block";
                    document.getElementById('metamask_logoutted').style.display = "none";
                }
            }
        }        
        load_js();
    });       
});






