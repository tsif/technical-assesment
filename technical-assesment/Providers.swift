/*
 * Providers.swift
 */

import web3

class KeyStorageProvider: EthereumKeyStorageProtocol {
    
    // MARK: - Properties
    
    let privateKey: String
    
    // MARK: - Lifecycle
    
    init(key: String) {
        self.privateKey = key
    }
    
    // MARK: - Methods
    
    func storePrivateKey(key: Data) throws {
        
    }

    func loadPrivateKey() throws -> Data {
        return Data(hex: privateKey) ?? Data()
    }
}
