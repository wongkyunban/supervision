//
//  Error.swift
//  zf
//
//  Created by waterway on 2016/11/23.
//  Copyright © 2016年 waterway. All rights reserved.
//

import Foundation
enum MsgEnm:String
{
    // 访问成功，没有数据返回
    case Msg201 = "0201"
    
    //访问成功，操作成功
    case Msg202 = "0202"
    
    //以04开始代表常见的参数错误
    
    //访问失败，请求不合法
    case Msg400 = "0400"
    
    // 访问失败，请求信息错误。
    case Msg401 = "0401"
    
    //05以后代表业务、验证错误信息
    // 访问失败，用户不存在。
    case Msg500 = "0500"
    
    // 访问失败，查无此车辆信息。
    case Msg502 = "0502"
    
    // 访问失败，查无此业户信息。
    case Msg503 = "0503"
    
    // 访问失败，查无此人员信息。
    case Msg504 = "0504"
    
    // 访问失败，该条形码已存在。
    case Msg601 = "0601"
    
    // 以09开头代表程序、系统错误
    // 访问失败，系统错误。
    case Msg900 = "0900"
}
