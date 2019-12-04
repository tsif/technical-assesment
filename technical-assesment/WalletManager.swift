/*
 * WalletManager.swift
 */

import Foundation
import web3
import BigInt

struct Constants {

    static let proxy = "https://ropsten.infura.io/v3/735489d9f846491faae7a31e1862d24b"
    static let walletAddress = "0x70ABd7F0c9Bdc109b579180B272525880Fb7E0cB"
    static let transferModuleAddress = "0xcdAd167a8A9EAd2DECEdA7c8cC908108b0Cc06D1"
    static let privateKey = "0xec983791a21bea916170ee0aead71ab95c13280656e93ea4124c447bbd9a24a2"
    static let tokenAddress = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"
    static let toAddress = "0x6da1C4462820B178B4493C5BE02c1E84Ff7335Dd"
}

class WalletManager {
    
    let client: EthereumClient
    let erc20: ERC20
    
    // MARK: - Lifecycle
        
    init?() {
    
        guard let proxyUrl = URL(string: Constants.proxy) else { return nil }
        
        client = EthereumClient(url: proxyUrl)
        erc20 = ERC20(client: client)
    }
    
    // MARK: - Methods
    
    
    func getBalance(completion: @escaping (_ walletBalance: BalanceViewModel?) -> Void) {
        
        client.eth_getBalance(address: Constants.walletAddress,
                              block: .Latest) { (error, balance) in
            
            guard
                let balance = balance,
                error == nil
            else {
                return completion(nil)
            }
                                
            return completion(BalanceViewModel(value: balance))
        }
    }

    
    func getTransfers(completion: @escaping (_ transfers: [TransferViewModel]?) -> Void) {
        
        erc20.transferEventsTo(recipient: EthereumAddress(Constants.walletAddress),
                               fromBlock: .Earliest,
                               toBlock: .Latest) { (error, erc20Transfers) in
                                
            guard
                let erc20Transfers = erc20Transfers,
                error == nil
            else {
                return completion(nil)
            }
            
            let transfers = erc20Transfers.compactMap {
                TransferViewModel(amount: $0.value, from: $0.from, to: $0.to)
            }
                                
            completion(transfers)
        }
    }
    
    func sendTransaction(completion: @escaping (_ txHash: String?) -> Void) {
        
        let storage = KeyStorageProvider(key: Constants.privateKey)
        guard let account = try? EthereumAccount(keyStorage: storage) else {
            return completion(nil)
        }
        
        let contractAddress = EthereumAddress(Constants.transferModuleAddress)
        let abiUrl = Bundle.main.url(forResource: "transferManagerABI", withExtension: "json")!
        let contract = EthereumJSONContract(url: abiUrl, address: contractAddress)!
        
        guard
            let transaction = try? contract.transaction(
            function: "transferToken",
            from: EthereumAddress(Constants.toAddress),
            to: EthereumAddress(Constants.walletAddress),
            gasPrice: BigUInt(integerLiteral: 12),
            gasLimit: BigUInt(integerLiteral: 250000),
            args: [
                EthereumAddress(Constants.walletAddress).value,
                EthereumAddress(Constants.tokenAddress).value,
                EthereumAddress(Constants.toAddress).value,
                String(BigUInt(10000000000000000)),
                String(bytes: Data().bytes)
            ])
        else {
            return completion(nil)
        }
        
        client.eth_sendRawTransaction(transaction, withAccount: account) { (error, result) in
            return completion(result)
        }
    }
}
