//
//  Macro.swift
//  supervision
//
//  Created by waterway on 2017/1/5.
//  Copyright © 2017年 waterway. All rights reserved.
//
//
// ************************************************************************
// *                                                                      *
// *  __          __          __    ______     ___     __     _______     *
// *  \ \        /  \        / /   / ____ \    |  \   | |    / ______\    *
// *   \ \      / /\ \      / /   / /    \ \   |   \  | |   / /           *
// *    \ \    / /  \ \    / /    | |    | |   | |\ \ | |   | |   _____   *
// *     \ \  / /    \ \  / /     | |    | |   | | \ \| |   | |  |__   |  *
// *      \ \/ /      \ \/ /      \ \____/ /   | |  \   |   \ \____| | |  *
// *       \__/        \__/        \______/    |_|   \__|    \______/|_|  *
// *                                                                      *
// *                                                                      *
// ************************************************************************
//
import UIKit

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
//屏幕状态栏的高度,状态栏(status bar)：就是电量条，其高度为：40px；20点
let StateBarHeight:CGFloat = 20
//导航栏(navigation)：就是顶部条，其高度为：88px；44点
let NavBarHeight:CGFloat = 44
//主菜单栏(submenu，tab)：就是标签栏，底部条，其高度为：98px；49点
let SubmenuTabHeight:CGFloat = 49
//内容区域(content)：就是屏幕中间的区域，其高度为：1334px-40px-88px-98px=1108px
let ContentHeight:CGFloat = ScreenHeight - StateBarHeight - NavBarHeight - SubmenuTabHeight
//字体大小
let fontSize:CGFloat = 14
//数据查询展示的默认行高 目前不用了
let lineH:CGFloat = 30
//行距
let rowledge:CGFloat = 16
//计算单行行高
var rowHeight:CGFloat{
    let rowWord = "单行行高"
    return rowWord.getHeightFromStringWith(stringFontSize: fontSize, andWidth: ScreenWidth)
}
//字的高度
var wordHeight:CGFloat{
    let w = "字的高度"
    return w.getHeightFromStringWith(stringFontSize: fontSize, andWidth: ScreenWidth)
}

//获取接口地址
func getURLs() -> (LoginURL:String,ServiceURL:String,WebViewURL:String,AttachmentURL:String,CaseAuditURL:String,UpdateURL:String,IpaDownloadURL:String){
    let accessType = StorageUtils.getNormalDefault(keyName: "access")
    let rs = NetworkConfig.getNetworkConfig(accessType: accessType as! Int)
    return rs
}
//获取用户数据
func getUserData() -> UserData{
    let application = UIApplication.shared
    let delegate = application.delegate as! AppDelegate
    let userData = delegate.userData
    return userData
}
//从JSON文件中加载数据
func loadData(fromJSONFile file:String) -> [[String:String]]{
    guard let jsonPath = Bundle.main.path(forResource: file, ofType: "json")else{
        return [[:]]
    }
    guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath:jsonPath)) else{
        return [[:]]
    }
    guard let arr = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)else{
        return [[:]]
    }
    return arr as! [[String:String]]
}

//将数组或字典转化成json
func convertArrOrDicToJSON(_ dict:Dictionary<String, Any>?) ->String{
    let data = try? JSONSerialization.data(withJSONObject: dict!, options: .prettyPrinted)
    let jsonStr = String(data: data!, encoding: .utf8)
    return jsonStr! as String
}

//处理形如 /Date(1464067370921)/ 的字符串，将其转换成 yyyy-MM-dd的日期
func fixTimeForYYYYMMDD(_ string:String) ->String{
    let dateString:String? = string.replacingOccurrences(of: "/Date(", with: "").replacingOccurrences(of: ")/", with: "")
    if let timeinterval = dateString{
        let d = Date(timeIntervalSince1970: Double(timeinterval)!/1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dsss = formatter.string(from: d)
        return dsss
    }
    //一定要除以1000哦，swift里的 Date(timeIntervalSince1970: timeinterval)接受的是秒数
    
}

func fixTime(timeString time:String,withFormat format:String ) ->String{
    let dateString:String? = time.replacingOccurrences(of: "/Date(", with: "").replacingOccurrences(of: ")/", with: "")
    if let timeinterval = dateString{
        let d = Date(timeIntervalSince1970: Double(timeinterval)!/1000)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let dsss = formatter.string(from: d)
        return dsss
    }
    //一定要除以1000哦，swift里的 Date(timeIntervalSince1970: timeinterval)接受的是秒数
    
}


