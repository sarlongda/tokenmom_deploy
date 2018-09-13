# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
#
Token.create({name: "Ether Token", symbol: "WETH", contract_address: "0xc778417e063141139fce010982780140aa0cd5ab"})
Token.create({name: "0x Protocol Token", symbol: "ZRX", contract_address: "0xa8e9fa8f91e5ae138c74648c9c304f1c75003a8d"})
Token.create({name: "b0x Protocol Token", symbol: "B0X", contract_address: "0x14823db576c11e4a54ca9e01ca0b28b18d3d1187"})
Token.create({name: "token0", symbol: "TKN0", contract_address: "0xdf18648f5b4357d6cc1e27f7699af4f77ff44558"})
Token.create({name: "token1", symbol: "TKN1", contract_address: "0xd7cdcde4302a60c4d74a11eee21fbf455f476021"})
Token.create({name: "token10", symbol: "TKN10", contract_address: "0xaece1ee1813d56a5897f19ad50164565203b459f"})
Token.create({name: "token11", symbol: "TKN11", contract_address: "0xaab3f0619e529b1f1823be291daa7fcd38a15927"})
