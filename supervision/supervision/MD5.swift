//
//  MD5.swift
//  supervision
//
//  Created by waterway on 2017/1/5.
//  Copyright © 2017年 waterway. All rights reserved.
//

import Foundation

extension String{
    static func md5String(needMd5string str:String) -> String{
        let cStr = str.cString(using: String.Encoding.utf8)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr,(CC_LONG)(strlen(cStr!)),buffer)
        let md5String = NSMutableString()
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
}
