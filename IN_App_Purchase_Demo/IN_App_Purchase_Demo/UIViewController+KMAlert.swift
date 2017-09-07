//
//  UIViewController+KMAlert.swift
//  Kukoo-math
//
//  Created by HaoYuhong on 17/5/31.
//  Copyright © 2017年 HaoYuhong. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {

    func showAlert(_ title: String? = nil, _ message: String? = nil, _ cancelTitle: String? = "确定", handle:((UIAlertAction) -> Swift.Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: handle)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    func showAlert(_ title: String? = nil, _ message: String? = nil, _ cancelTitle: String? = "取消", handle:((UIAlertAction) -> Swift.Void)? = nil, sureTitle: String? = "确定", sureHandle:((UIAlertAction) -> Swift.Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: handle)
        alertVC.addAction(alertAction)
        let sureAction = UIAlertAction(title: sureTitle, style: .default, handler: sureHandle)
        alertVC.addAction(sureAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}
