//
//  RequestManager.swift
//  TexasPoker
//
//  Created by HaoYuhong on 2017/8/14.
//  Copyright © 2017年 aragon_mini2. All rights reserved.
//

import UIKit
import Alamofire

class RequestManager {
    public class func request(_ url:String,method:HTTPMethod = .get,
                        parameters: Parameters? = nil,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: HTTPHeaders? = nil) -> DataRequest {
        var newHeaders:HTTPHeaders = Dictionary()
        if (headers != nil) {
            for (headerKey, value) in headers!{
                newHeaders[headerKey] = value
            }
        }
        newHeaders["API_VERSION"] = "1.0"
        return Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: newHeaders)
    }
}

