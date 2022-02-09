//
//  DataEncoding.swift
//  FFMymFacialMo
//
//  Created by Facia on 2021/12/28.
//  Copyright © 2021 faci. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit

class ExchangeManage: NSObject {
    class func exchangeWithSSK(objcetID: String, completion: @escaping (PurchaseResult) -> Void) {        
        SwiftyStoreKit.purchaseProduct(objcetID) { a in
            completion(a)
        }
    }
}
