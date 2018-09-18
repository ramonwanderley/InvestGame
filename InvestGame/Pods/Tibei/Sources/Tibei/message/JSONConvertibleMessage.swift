//
//  JSONConvertibleMessage.swift
//  Pods
//
//  Created by DANIEL J OLIVEIRA on 12/7/16.
//
//

import Foundation

public protocol JSONConvertibleMessage {
    init(jsonObject:[String:Any])
    
    func toJSONObject() -> [String:Any]
}

extension JSONConvertibleMessage {
    static var type: String {
        return String(describing: Self.self)
    }
}
