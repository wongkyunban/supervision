//
//  UserData.swift
//  zf
//
//  Created by waterway on 2016/11/7.
//  Copyright © 2016年 waterway. All rights reserved.
//

import Foundation

class UserData{
    
    
    //用户ID
    var userId:String?
    //组织ID
    var orgId:String?
    //角色ID
    var roleId:String?
    //用户名
    var loginUser:String?
    //手机品牌
    var cellBrand:String? = "Apple"
    //ios版本
    var iOSVersion:String? = "iOS " + UIDevice.current.systemVersion
    //手机型号
    var cellModel:String? = UIDevice.current.model
    //app发布版本号
    var release:String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    //时间戳
    var timestamp:String?
    //个推使用的client ID
    var cid:String?
    //个推app id
    var appid:String?
    //个推app key
    var appKey:String?
    //访问方式内网1  外网2
    var accessType:Int?
    
    //加密请求数据
    func getJsonToWebService() -> String {
        let json1:String = "{\"UserId\":\"" + userId! + "\",\"OrgId\":\"" + orgId!
        let json2:String = "\",\"EquipmentBrand\":\"" + cellBrand! + "\",\"SystemVersion\":\"" + iOSVersion!
        let json3:String = "\",\"EquipmentModel\":\"" + cellModel! + "\",\"SoftwareVersion\":\"" + release!
        let json4:String = "\",\"CId\":\"\"}"
        let dateEncript:String = getCryptoCurrentTime()
        let jsonString:String = "_TE_" + json1 + json2 + json3 + json4 + "_TE_" + dateEncript
        return jsonString
    }
    
    
    //加密时间
    func getCryptoCurrentTime() -> String{
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = dateFormat.string(from: Date())
        let encryptString = DESHelper.encode(dateStr, key: "tesecret")
        return encryptString!
    }
    
    
}
