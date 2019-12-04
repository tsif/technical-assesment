/*
 * Extentions.swift
 */

import UIKit
import web3
import BigInt

extension EthereumJSONContract {
    
    public func transaction(function: String,
                            from: EthereumAddress,
                            to: EthereumAddress,
                            gasPrice: BigUInt,
                            gasLimit: BigUInt,
                            args: [String]) throws -> EthereumTransaction {
        
        let data = try self.data(function: function, args: args)
        return EthereumTransaction(from: from,
                                   to: to,
                                   data: data,
                                   gasPrice: gasPrice,
                                   gasLimit: gasLimit)
    }
}
