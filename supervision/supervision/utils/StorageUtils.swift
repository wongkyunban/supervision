//
//  StorageUtils.swift
//  supervision
//
//  Created by waterway on 2017/1/5.
//  Copyright © 2017年 waterway. All rights reserved.
//

import Foundation
//
//  StorageSetting.swift
//  zf
//
//  Created by waterway on 2016/11/7.
//  Copyright © 2016年 waterway. All rights reserved.
//

import Foundation

class StorageUtils{
    
    //使用UserDefaults对普通数据对象进行存储
    class func setNormalDefault(keyName key:String,keyValue value:AnyObject?){
        if value == nil {
            UserDefaults.standard.removeObject(forKey: key)
        }else{
            UserDefaults.standard.set(value, forKey: key)
            //同步
            UserDefaults.standard.synchronize()
        }
    }
    
    //获取存储的值
    class func getNormalDefault(keyName key:String) -> AnyObject?{
        return UserDefaults.standard.value(forKey: key) as AnyObject?
    }
    
    //删除键值
    class func removeNormalUserDefault(keyName key:String?){
        if key != nil{
            UserDefaults.standard.removeObject(forKey: key!)
            UserDefaults.standard.synchronize()
        }
    }
}
