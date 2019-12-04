/*
 * InboundTransfersViewController.swift
 */

import UIKit

class InboundTransfersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView?
    
    let walletManager = WalletManager()
    var transfers: [TransferViewModel] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ERC20 Transfers"
        
        retrieveTransfers()
    }
    
    // MARK: - Table view
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Wallet: \(Constants.walletAddress)"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transfers.count == 0 ? 1 : transfers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if transfers.count > 0, indexPath.row < transfers.count {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionIdentifier",
                                                     for: indexPath)
            
            if let fromLabel = cell.viewWithTag(1001) as? UILabel {
                fromLabel.text = transfers[indexPath.row].fromPresentation
            }
            
            if let toLabel = cell.viewWithTag(1002) as? UILabel {
                toLabel.text = transfers[indexPath.row].toPresentation
            }
            
            if let amountLabel = cell.viewWithTag(1003) as? UILabel {
                amountLabel.text = transfers[indexPath.row].amountPresentation
            }
            
            return cell
            
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "loadingIdentifier",
                                             for: indexPath)
    }
    
    // MARK: - Methods
    
    func retrieveTransfers() {
        
        walletManager?.getTransfers(completion: { [weak self] transfers in
            DispatchQueue.main.async {
                
                if let transfers = transfers {
                    self?.transfers = transfers
                    
                } else {
                    
                }
                
                self?.tableView?.reloadData()
            }
        })
    }
}
