//
//  ViewController.swift
//  IN_App_Purchase_Demo
//
//  Created by HaoYuhong on 2017/9/7.
//  Copyright © 2017年 HaoYuhong. All rights reserved.
//

import UIKit
import StoreKit
import SVProgressHUD

// testting

let Diamond60 = "ACS_Diamond_60"
class ViewController: UIViewController,SKProductsRequestDelegate, SKPaymentTransactionObserver {
    /// IN-APP Purchase
    var productRequest:SKProductsRequest?
    var currentPaymentItemID:String?
    override func viewDidLoad() {
        super.viewDidLoad()
       SKPaymentQueue.default().add(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func payAction(_ sender: Any) {
        buyDiamond()
    }


}
//MARK:- In-APP Purchase
extension ViewController {
    
    func buyDiamond()  {
        if SKPaymentQueue.canMakePayments() {
            currentPaymentItemID = Diamond60
            self.requestProductData(id: Diamond60)
        } else {
            self.showAlert("", "您的手机未开启允许内购服务", "确定")
        }
        SVProgressHUD.show()
    }
    func requestProductData(id:String) {
        let productIdSet = NSSet(object: id)
        productRequest = SKProductsRequest(productIdentifiers: productIdSet as! Set<String>)
        productRequest?.delegate = self
        productRequest?.start()
    }
    
    //MARK:- Product Request Delegate
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        if products.count == 0 {
            self.showAlert("", "未找到你所该买的产品", "确定")
            SVProgressHUD.dismiss()
            return
        }
        var paymentProduct:SKProduct?
        for product in products {
            print(product.localizedDescription)
            print(product.price)
            print(product.productIdentifier)
            if currentPaymentItemID! == product.productIdentifier {
                paymentProduct = product
            }
        }
        if let p = paymentProduct {
            let payment = SKPayment(product: p)
            SKPaymentQueue.default().add(payment)
        }else {
           SVProgressHUD.dismiss()
        }
    }
    func request(_ request: SKRequest, didFailWithError error: Error) {
        SVProgressHUD.dismiss()
        self.showAlert("", "购买失败", "确定")
    }
    
    func requestDidFinish(_ request: SKRequest) {
        print("requestDidFinish")
    }
    
    //MARK:- Transition Observe
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("交易完成")
                self.completeTransaction(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing:
                print("商品添加进列表")
            case .failed:
                print("交易失败")
                self.failedTransaction(transaction)
            case .restored:
                print("已经购买过此商品")
                restoredTransaction(transaction)
            default:
                break
            }
        }
    }
    func completeTransaction(_ transaction:SKPaymentTransaction)  {
        print("交易结束")
        let productId = transaction.payment.productIdentifier
        if !(productId.isEmpty) {
            // 通过存在沙盒的Url获取Data 提交到自己服务器验证
            RequestManager.request((Bundle.main.appStoreReceiptURL?.absoluteString)!, method: .post).responseData(completionHandler: { (data) in
                let transactionReceiptData = data.data
                let transactionReceiptString = transactionReceiptData?.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithLineFeed)
                // 提交自己服务器验证
                self.commitServer(transactionReceiptString)
                
            })
            
        }
    }
    func restoredTransaction(_ transaction:SKPaymentTransaction)  {
        
    }
    func failedTransaction(_ transaction:SKPaymentTransaction)  {
        SVProgressHUD.dismiss()
        if let nserror = transaction.error as NSError? {
            if nserror.code != SKError.Code.paymentCancelled.rawValue {
                self.showAlert("", (transaction.error?.localizedDescription)!, "确定")
            }
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    func commitServer(_ transactionReceiptString: String?) {
        if let string = transactionReceiptString {
            
        } else {
            print("未知错误")
        }
    }
}
