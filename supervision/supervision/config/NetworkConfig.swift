//
//  Properties.swift
//  zf
//
//  Created by waterway on 2016/11/4.
//  Copyright © 2016年 waterway. All rights reserved.
//

import Foundation





class NetworkConfig{
    
   private static let  Internet = 2
   private static let  Intranet = 1
    class func getNetworkConfig(accessType type:Int) ->(LoginURL:String,ServiceURL:String,WebViewURL:String,AttachmentURL:String,CaseAuditURL:String,UpdateURL:String,IpaDownloadURL:String){
        //获取json文件的路径
        guard let jsonPath = Bundle.main.path(forResource: "NetworkConfig", ofType: "json")else{
            return  (LoginURL:"",ServiceURL:"",WebViewURL:"",AttachmentURL:"",CaseAuditURL:"",UpdateURL:"",IpaDownloadURL:"")
        }
        
        //获取json的内容
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else{
            return (LoginURL:"",ServiceURL:"",WebViewURL:"",AttachmentURL:"",CaseAuditURL:"",UpdateURL:"",IpaDownloadURL:"")
        }
        //将jsonData转成数组
        guard let ar = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else{
            return (LoginURL:"",ServiceURL:"",WebViewURL:"",AttachmentURL:"",CaseAuditURL:"",UpdateURL:"",IpaDownloadURL:"")
        }
        
        //将数组每个元素转成字典
        guard let dict = ar as? Dictionary<String,String> else{
            return (LoginURL:"",ServiceURL:"",WebViewURL:"",AttachmentURL:"",CaseAuditURL:"",UpdateURL:"",IpaDownloadURL:"")
        }
        
        //遍历字典

            switch type {
            case Internet:
                return (LoginURL:dict["LoginURL"]!,ServiceURL:dict["ServiceURL"]!,WebViewURL:dict["WebViewURL"]!,AttachmentURL:dict["AttachmentURL"]!,CaseAuditURL:dict["CaseAuditURL"]!,UpdateURL:dict["UpdateURL"]!,IpaDownloadURL:dict["IpaDownloadURL"]!)
            case Intranet:
                return (LoginURL:dict["LoginURLLan"]!,ServiceURL:dict["ServiceURLLan"]!,WebViewURL:dict["WebViewURLLan"]!,AttachmentURL:dict["AttachmentURLLan"]!,CaseAuditURL:dict["CaseAuditURLLan"]!,UpdateURL:dict["UpdateURLLan"]!,IpaDownloadURL:dict["IpaDownloadURLLan"]!)
            default:
                return (LoginURL:"",ServiceURL:"",WebViewURL:"",AttachmentURL:"",CaseAuditURL:"",UpdateURL:"",IpaDownloadURL:"")
            }
        
    }
}

    
    
    

