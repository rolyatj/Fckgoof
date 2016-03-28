//
//  IAPHelper.swift
//  Stack
//
//  Created by Kurt Jensen on 2/29/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import StoreKit

class IAPHelper: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    var productsRequest:SKProductsRequest = SKProductsRequest()
    var products = [String : SKProduct]()
    var purchaseCompleted: ((success: Bool, errorMessage: String?) -> Void)?
    var isPurchasing = false
    var isRefreshing = false
    
    static let storeURL = NSURL(string: "https://sandbox.itunes.apple.com/verifyReceipt")! // TODO
    //static let storeURL = NSURL(string: "https://buy.itunes.apple.com/verifyReceipt")!
    static var iapIdentifier = "io.arborapps.LeagueDuel.monthlySubscription"
    static let sharedSecret = "dd80960b3e3046648ab92c87e15fee1c"
    static let instance = IAPHelper()
    
    func setup() {
        requestProductWithProductIdentifiers([IAPHelper.iapIdentifier])
    }
    
    func requestProductWithProductIdentifiers(productIdentifiers: [String]) {
        productsRequest = SKProductsRequest(productIdentifiers: Set(productIdentifiers))
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        for product in response.products {
            products[product.productIdentifier] = product
        }
    }
    
    func priceForIAP() -> String? {
        if let product: SKProduct = products[IAPHelper.iapIdentifier] {
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            formatter.locale = NSLocale.currentLocale()
            return (formatter.stringFromNumber(product.price) ?? "")
        }
        return nil
    }
    
    func purchaseIAP(purchaseCompleted:((success: Bool, errorMessage: String?) -> Void)?) {
        startPurchaseFor(IAPHelper.iapIdentifier, purchaseCompleted: purchaseCompleted)
    }
    
    func restoreIAP(purchaseCompleted:((success: Bool, errorMessage: String?) -> Void)?) {
        self.purchaseCompleted = purchaseCompleted
        refreshReceipt()
    }
    
    func startPurchaseFor(productIDString: String, purchaseCompleted:((success: Bool, errorMessage: String?) -> Void)?) {
        
        if SKPaymentQueue.canMakePayments() {
            
            if let product: SKProduct = products[productIDString] {
                
                self.purchaseCompleted = purchaseCompleted
                let payment = SKPayment(product: product)
                SKPaymentQueue.defaultQueue().addTransactionObserver(self)
                SKPaymentQueue.defaultQueue().addPayment(payment);
                
            } else {
                purchaseCompleted?(success: false, errorMessage: "Product \(productIDString) not found")
            }
            
        } else {
            purchaseCompleted?(success: false, errorMessage: "User cannot make payments")
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .Restored:
                processTransaction(transaction)
                break
            case .Purchased:
                processTransaction(transaction)
                break
            case .Failed:
                
                self.isPurchasing = false
                purchaseCompleted?(success: false, errorMessage: transaction.error?.localizedDescription)
                
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                break
                
            default:
                break
            }
        }
    }
    
    func processTransaction(trans: SKPaymentTransaction) {
        SKPaymentQueue.defaultQueue().finishTransaction(trans)
        if let receiptURL = NSBundle.mainBundle().appStoreReceiptURL where NSFileManager.defaultManager().fileExistsAtPath(receiptURL.path!) {
            
            self.isPurchasing = false
            self.receiptValidation()
        } else {
            self.refreshReceipt()
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        //
    }
    
    func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError) {
        print(error)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print("received restored transactions: \(queue.transactions.count)")
        receiptValidation()
    }
    
    func refreshReceipt() {
        if !isRefreshing {
            isPurchasing = false
            isRefreshing = true
            let request = SKReceiptRefreshRequest(receiptProperties: nil)
            request.delegate = self
            request.start()
        }
    }
    
    func requestDidFinish(request: SKRequest) {
        
        if let appStoreReceiptURL = NSBundle.mainBundle().appStoreReceiptURL where
            NSFileManager.defaultManager().fileExistsAtPath(appStoreReceiptURL.path!) {
                self.receiptValidation()
        } else {
            purchaseCompleted?(success: false, errorMessage: "Cannot find receipt")
        }
    }
    
    func receiptValidation() {
        
        if let receiptPath = NSBundle.mainBundle().appStoreReceiptURL?.path where
            NSFileManager.defaultManager().fileExistsAtPath(receiptPath),
            let receiptData = NSData(contentsOfURL: NSBundle.mainBundle().appStoreReceiptURL!) {
                let receiptDictionary = ["receipt-data" : receiptData.base64EncodedStringWithOptions([]),
                    "password" : IAPHelper.sharedSecret]
                do {
                    let requestData = try NSJSONSerialization.dataWithJSONObject(receiptDictionary, options: [])
                    receiptValidation(requestData)
                } catch {
                    print(error)
                }
        }
    }
    
    func receiptValidation(requestData: NSData) {
        let storeRequest = NSMutableURLRequest(URL: IAPHelper.storeURL)
        storeRequest.HTTPMethod = "POST"
        storeRequest.HTTPBody = requestData
        
        let session = NSURLSession(configuration:
            NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let task = session.dataTaskWithRequest(storeRequest, completionHandler: { (data, response, error) -> Void in
            //print(data)
            if let data = data {
                do {
                    let jsonResponse : NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSDictionary
                    print(jsonResponse)
                    if let receipt = jsonResponse["receipt"] as? NSDictionary, let in_app = receipt["in_app"] as? NSArray {
                        Settings.instance.isUpgraded = true
                        self.purchaseCompleted?(success: true, errorMessage: "Purchase succeeded")
                    } else {
                        self.purchaseCompleted?(success: false, errorMessage: "Could not validate receipt")
                    }
                } catch {
                    print(error)
                }
            }
        })
        
        task.resume()
    }
    
}
