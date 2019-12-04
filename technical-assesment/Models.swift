/*
 * Models.swift
 */

import web3
import BigInt

struct BalanceViewModel {
    
    let value: BigUInt
    let (quotient, remainder): (BigUInt, BigUInt)
    let presentation: String
    
    init(value: BigUInt) {
        
        self.value = value
        (quotient, remainder) = self.value.quotientAndRemainder(dividingBy: BigUInt(1e18))
        presentation = String(format: "%@.%@ ETH",
                              String(quotient),
                              String(String(remainder).prefix(2)))
    }
}

struct TransferViewModel {
    
    let amount: BigUInt
    let amountPresentation: String
    
    let from: EthereumAddress
    let fromPresentation: String
    
    let to: EthereumAddress
    let toPresentation: String
    
    init(amount: BigUInt, from: EthereumAddress, to: EthereumAddress) {
        
        self.amount = amount
        amountPresentation = String(amount)
        
        self.from = from
        fromPresentation = self.from.value
        
        self.to = to
        toPresentation = self.to.value
    }
}
