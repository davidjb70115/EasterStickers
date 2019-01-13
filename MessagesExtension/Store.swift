//
//  Page_Store.swift
//  StoryTellersKit2
//
//  Created by Justin Dike 2 on 9/17/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit
import StoreKit



extension MessagesViewController {
    
   
    //New promoted in app purchase code
    @nonobjc func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment,
                      
                      forProduct product: SKProduct) -> Bool {
        
        // Check to see if you can complete the transaction.
        
        // Return true if you can.
        
        return true
        
    }

     // In-App Purchase Methods
    func setUpPurchasing (){
        
        //if at least some prodcuts haven't been bought start the SKPaymentQueue
        if (productIdentifiers.count != 0 &&  SKPaymentQueue.canMakePayments() == true){
            
            
            purchasingEnabled = true
            SKPaymentQueue.default().add(self)
            requestProductData()
            
            if(debugMode){
                
                print("These products have not been purchased for \(productIdentifiers)")
                print("(Consumables are considered unpurchased since they can be bought multiple times)")
                
            }
            
            
        } else {
            
           
            
            if(productIdentifiers.count == 0){
                
                if(debugMode){
                    
                    print("All products have been purchased")
                    
                    
                }
                
                
            }
            if(SKPaymentQueue.canMakePayments() == false){
                
                purchasingEnabled = false
                
                if(debugMode){
                    
                    print("User can't make payments, so we aren't setting up SKPaymentQueue")
                    
                    
                }
                
                
            }
            
        }

        
        
        
    }
    
    
    func requestProductData()
    {
        
        request = SKProductsRequest(productIdentifiers:
            self.productIdentifiers as Set<String>)
        
       
        
        request!.delegate = self
        request!.start()
        
        
    }
    
    @objc(productsRequest:didReceiveResponse:) func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        var products:[SKProduct] = response.products
        
        if (products.count != 0) {
            
            print("found products")
            
            for i in 0 ..< products.count
            {
                self.product = products[i]
                self.productsArray.append(product!)
                
               // print (product?.productIdentifier)
                // print (product?.price)
            }
            
        } else {
            if(debugMode){
            
            print("No products found")
            }
        }
        
        let invalidProducts:[String] = response.invalidProductIdentifiers
        
        for invalidProduct in invalidProducts
        {
            if(debugMode){
            
            print("Product not found: \(invalidProduct)")
                
            }
        }
    }
    
    func buyProduct( _ ID:String ) {
        
        if SKPaymentQueue.canMakePayments() {
            
            for itemToBuy in productsArray {
                
                if (itemToBuy.productIdentifier == ID) {
                    
                    let payment = SKPayment(product: itemToBuy)
                    SKPaymentQueue.default().add(payment)
                    
                     break
                }
                
               
            }
            
            
            
        } else {
            let alert:UIAlertController = UIAlertController(title: "In-App Purchasing Not Enabled", message: "Please enable them in Settings", preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            let vc:UIViewController = self.view!.window!.rootViewController!
            
            vc.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.restored:
                
                print("Transaction Restored")
                print("Product Identifier: \(transaction.payment.productIdentifier)")
                self.deliverProduct(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case SKPaymentTransactionState.purchased:
                print("Transaction Approved")
                print("Product Identifier: \(transaction.payment.productIdentifier)")
                self.deliverProduct(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case SKPaymentTransactionState.deferred:
                print("Transaction Deferred")

                
                let alert:UIAlertController = UIAlertController(title: "Your purchase is pending", message: "Please continue using the app while we wait", preferredStyle: UIAlertControllerStyle.alert)
                
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                let vc:UIViewController = self.view!.window!.rootViewController!
                
                vc.present(alert, animated: true, completion: nil)
                
                
            default:
                break
            }
        }
    }
    
    func deliverProduct(_ transaction:SKPaymentTransaction) {
        
       
        defaults.set("Purchased", forKey: transaction.payment.productIdentifier)
        
        if (debugMode){
            
            print( " Defaults now knows that \(transaction.payment.productIdentifier) has a saved value of  \(String(describing: defaults.object(forKey: transaction.payment.productIdentifier) ))")
        }
        
        
        stickersAlreadyBought = true
        unlockAllStickers()
        
    }
    
    func restorePurchasesSilently() {
        
        restoreSilently = true
        
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    func restorePurchases() {
        
        restoreSilently = false
        
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
       
        
        //this statement will run multiple times between on the number of test purchases

        for transaction:SKPaymentTransaction in queue.transactions {
            
            defaults.set("Purchased", forKey: transaction.payment.productIdentifier)
            // print (  transaction.payment.productIdentifier )
            // print (defaults.object(forKey: transaction.payment.productIdentifier))
            
            stickersAlreadyBought = true
            
        }
        
        
        if ( stickersAlreadyBought == true){
            
            unlockAllStickers()
        }
        
         ////// show alert or not
        
        if ( restoreSilently == false){
            
            showRestoreAlert()
        }
        
        
       
      
    }
    
    
    func showRestoreAlert(){
        

            let alert:UIAlertController = UIAlertController(title: "Thank you", message: "Any previously purchased stickers have been restored", preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            
            let vc:UIViewController = self.view!.window!.rootViewController!
            
            vc.present(alert, animated: true, completion: nil)
            

    }
    
    
    
    
    
}

enum ID:String {
    
    case k = "D"
    case i = "o"
    case a = "T"
    case d = "n"
    case f = "c"
    case h = "i"
    case b = "r"
    case j = "I"
    case g = "t"
    case e = "s"
    case c = "a"
}

