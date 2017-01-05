//
//  CheckUpdate.swift
//  supervision
//
//  Created by waterway on 2017/1/5.
//  Copyright © 2017年 waterway. All rights reserved.
//

import Foundation

class CheckUpdate:UINavigationController{
    var forceUpdate:Bool?
    var result:ComparisonResult?
    
    func checkUpdate(){
        //获取当前app上的版本
        let localVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let urls = getURLs()
        let uuid = UUID()
        let urlString = urls.UpdateURL+"?uuid=" + uuid.uuidString
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request){
            (data,response,error) in
            
            if error == nil {
                guard let rs = String(data:data!,encoding:.utf8) else{
                    return
                }
                let str = rs.replacingOccurrences(of: "\\r\\n", with: "").replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "#", with: "\\r\\n")
                if  let rsData = str.data(using: .utf8) {
                    guard let versionArr = try?  JSONSerialization.jsonObject(with: rsData, options: .mutableContainers) as! [[String:Any]] else{
                        return
                    }
                    
                    let serverVersion = versionArr[0]["version"] as! String
                    let description = versionArr[0]["description"] as! String
                     self.forceUpdate  = Bool(versionArr[0]["forceUpdate"] as! String)!
                    self.result = serverVersion.compare(localVersion)
                    
                    //线上app版本比当前版本大，应该提示更新
                    if self.result?.rawValue == 1{
                        DispatchQueue.global().async {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "发现新版本（\(serverVersion)）", message: description, preferredStyle: UIAlertControllerStyle.alert)
                                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                let updateAction = UIAlertAction(title: "更新", style: .default, handler: { (uiAlertAction) in
                                    //下载ipa
                                    
                                    //let url = URL(string: "itms-services://?action=download-manifest&url=https://gooddriver.sinaapp.com/zf.plist")
                                    let url = URL(string: "itms-services://?action=download-manifest&url=https%3A%2F%2Fwww.pgyer.com%2Fapiv1%2Fapp%2Fplist%3FaId%3D2cb2d5fd8c8062d80da2c98bf37ecaca%26_api_key%3D9063f2ccc81433f09234a120f49bd230")
                                    if #available(iOS 10.0, *){
                                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                    }else{
                                    UIApplication.shared.openURL(url!)
                                    }
                                })
                                alert.addAction(cancelAction)
                                alert.addAction(updateAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
                
            }else{
                DispatchQueue.global().async{
                    DispatchQueue.main.async {
                        ToastView.getInstance().showToast(content: "无法访问网络！",imageName: "toast")
                        let time:TimeInterval = 1
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: {
                            ToastView.getInstance().clear()
                        })
                    }
                }
                
            }
        }
        dataTask.resume()
        
    }
}
