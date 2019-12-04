/*
 * MainViewController.swift
 */

import UIKit

class MainViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var balanceLabel: UILabel?
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView?
    @IBOutlet weak var transferIndicatorView: UIActivityIndicatorView?
    @IBOutlet weak var refreshButton: UIButton?
    @IBOutlet weak var transferButton: UIButton?
    
    let walletManager = WalletManager()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Main"
        
        retrieveBalance()
    }
    
    // MARK: - Actions
    
    @IBAction func transferAction(_ sender: Any? = nil) {
        
        self.transferButton?.isHidden = true
        self.transferIndicatorView?.isHidden = false
        
        walletManager?.sendTransaction(completion: { [weak self] txHash in
          
            DispatchQueue.main.async {
                
                self?.transferButton?.isHidden = false
                self?.transferIndicatorView?.isHidden = true
                
                let alert = UIAlertController(title: "Message",
                                              message: txHash == nil
                                                ? "Something went wrong"
                                                : "Transaction \(txHash!)",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        })
    }
    
    @IBAction func actionRefreshAction(_ sender: Any? = nil) {
        retrieveBalance()
    }
    
    // MARK: - Methods
    
    func retrieveBalance() {
        
        balanceLabel?.isHidden = true
        refreshButton?.isHidden = true
        activityIndicatorView?.isHidden = false
        walletManager?.getBalance(completion: { [weak self] balance in
            
            DispatchQueue.main.async {
                
                self?.balanceLabel?.text = balance != nil
                    ? balance?.presentation
                    : "Something went wrong"
                
                self?.balanceLabel?.isHidden = false
                self?.refreshButton?.isHidden = false
                self?.activityIndicatorView?.isHidden = true
            }
        })
    }
}

