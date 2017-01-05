//
//  SettingViewController.swift
//  zf
//
//  Created by waterway on 2016/11/3.
//  Copyright © 2016年 waterway. All rights reserved.
//

import UIKit
@objc protocol SettingViewControllerDelegate:NSObjectProtocol{
    @objc optional func setComebackSignal(forComeBack comeBack:Bool )
}
class SettingViewController: UIViewController {
    //navigation bar
    var navigationBar:UINavigationBar?
    //navigation bar item
    var navItem:UINavigationItem?
    //navigation bar item left button
    var navLeftBtn:UIBarButtonItem?
    let bannerTitle = "系统设置"
    //delegate
    var settingDelegate:SettingViewControllerDelegate?
    //logo uiview
    var logoUIView:UIView?
    var imageView:UIImageView?
    var versionLabel:UILabel?
    //scrollView
    var scrollview:UIScrollView?
    //updateUIview
    var updateUIView:UIView?
    var checkUpdateLabel:UIButton?
    var checkUpdateLine:UIView?
    var autoUpdateLabel:UILabel?
    var autoUpdateLine:UIView?
    var useCusKeyBoardLabel:UILabel?
    //检测更新 自动更新 启用虚拟键盘
    let autoUpdateUISwitch = UISwitch()
    let useCusKeyboardUISwitch = UISwitch()
    //secondUIView
    var secondUIView:UIView?
    //记住密码、自动登录、启用专网
    let remberPwdLabel = UILabel()
    let autoLoginLabel = UILabel()
    let useIntranetLabel = UILabel()
    let remberPwdLine = UIView()
    let autoLoginLine = UIView()
    let remberPwdUISwitch = UISwitch()
    let autoLoginUISwitch = UISwitch()
    let networkUISwitch = UISwitch()
    //注销按钮
    var logoutBtn:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64))
        self.navigationBar?.barTintColor = UIColor.transform(fromHexString: "#1b7dc9")
        //navigation bar item andd title
        self.navItem = UINavigationItem(title: self.bannerTitle)
        //navigation button item left button angel left
        let labUIView = UIView(frame: CGRect(x: 0, y: 0, width: 88, height: 64))
        let lab = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 64))
        lab.font = UIFont(name: "FontAwesome", size: 30.0)
        lab.setFAIcon(icon: .FAAngleLeft, iconSize: 30.0)
        lab.textColor = UIColor.white
        labUIView.addSubview(lab)
        self.navItem?.leftBarButtonItem = UIBarButtonItem(customView: labUIView)
        labUIView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goBack)))
        //push the navigation item to the navigation bar
        self.navigationBar?.pushItem(self.navItem!, animated: true)
        //navigation bar title color
        self.navigationBar?.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont(name:"Heiti SC",size:18)!]
        self.view.addSubview(self.navigationBar!)
        //logoUIView
        self.logoUIView = UIView(frame:CGRect(x:0,y:64,width:ScreenWidth,height:130))
        self.view.addSubview(self.logoUIView!)
        self.logoUIView?.backgroundColor = UIColor.transform(fromHexString: "#1b7dc9")
        self.imageView = UIImageView()
        self.logoUIView?.addSubview(self.imageView!)
        self.imageView?.image = UIImage(named: "zfbs")
        self.versionLabel = UILabel()
        self.logoUIView?.addSubview(self.versionLabel!)
        self.versionLabel?.textColor = UIColor.white
        let userData = getUserData()
        self.versionLabel?.text = "版本：\(userData.release!)"
        self.versionLabel?.font = UIFont.systemFont(ofSize: fontSize)
        //Scrollview
        self.scrollview = UIScrollView()
        self.view.addSubview(self.scrollview!)
        self.scrollview?.backgroundColor = UIColor.transform(fromHexString: "#F0EFF5")
        //updateUIView
        self.updateUIView = UIView()
        self.scrollview?.addSubview(self.updateUIView!)
        self.checkUpdateLabel = UIButton()
        self.autoUpdateLabel = UILabel()
        self.useCusKeyBoardLabel = UILabel()
        self.updateUIView?.addSubview(self.checkUpdateLabel!)
        self.updateUIView?.addSubview(self.autoUpdateLabel!)
        self.updateUIView?.addSubview(self.useCusKeyBoardLabel!)
        self.updateUIView?.addSubview(self.autoUpdateUISwitch)
        self.updateUIView?.addSubview(self.useCusKeyboardUISwitch)
        self.autoUpdateUISwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.useCusKeyboardUISwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.checkUpdateLabel?.setTitle("检测更新", for: .normal)
        self.checkUpdateLabel?.contentHorizontalAlignment = .left
        self.checkUpdateLabel?.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        self.checkUpdateLabel?.setTitleColor(UIColor.black, for: .normal)
        self.checkUpdateLabel?.addTarget(self, action: #selector(clickDown(_:)), for: .touchDown)
        self.checkUpdateLabel?.addTarget(self, action: #selector(clickUp(_:)), for: .touchUpInside)
        self.autoUpdateLabel?.font = UIFont.systemFont(ofSize: fontSize)
        self.useCusKeyBoardLabel?.font = UIFont.systemFont(ofSize: fontSize)
        self.checkUpdateLine = UIView()
        self.updateUIView?.addSubview(self.checkUpdateLine!)
        self.checkUpdateLine?.backgroundColor = UIColor.transform(fromHexString: "#C0C0C0")
        self.autoUpdateLabel?.text = "自动更新"
        self.autoUpdateLine = UIView()
        self.updateUIView?.addSubview(self.autoUpdateLine!)
        self.autoUpdateLine?.backgroundColor = UIColor.transform(fromHexString: "#C0C0C0")
        self.useCusKeyBoardLabel?.text = "启用虚拟键盘"
        self.updateUIView?.backgroundColor = UIColor.white
        self.updateUIView?.layer.cornerRadius = 8
        //secondUIView
        self.secondUIView = UIView()
        self.scrollview?.addSubview(self.secondUIView!)
        self.secondUIView?.backgroundColor = UIColor.white
        self.secondUIView?.layer.cornerRadius = 8
        //记住密码、自动登录、启用专网
        self.remberPwdLabel.text = "记住密码"
        self.secondUIView?.addSubview(self.remberPwdLabel)
        self.remberPwdLine.backgroundColor = UIColor.transform(fromHexString: "#C0C0C0")
        self.secondUIView?.addSubview(self.remberPwdLine)
        self.remberPwdLabel.font = UIFont.systemFont(ofSize: fontSize)
        self.autoLoginLabel.text = "自动登录"
        self.secondUIView?.addSubview(self.autoLoginLabel)
        self.autoLoginLine.backgroundColor = UIColor.transform(fromHexString: "#C0C0C0")
        self.secondUIView?.addSubview(self.autoLoginLine)
        self.autoLoginLabel.font = UIFont.systemFont(ofSize: fontSize)
        self.useIntranetLabel.text = "启用交通虚拟专网访问"
        self.secondUIView?.addSubview(self.useIntranetLabel)
        self.useIntranetLabel.font = UIFont.systemFont(ofSize: fontSize)
        self.remberPwdUISwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.autoLoginUISwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.networkUISwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.secondUIView?.addSubview(self.remberPwdUISwitch)
        self.secondUIView?.addSubview(self.autoLoginUISwitch)
        self.secondUIView?.addSubview(self.networkUISwitch)
        //autoUpdate
        let isAutoUpdate = StorageUtils.getNormalDefault(keyName: "isAutoUpdate") as AnyObject?
        if isAutoUpdate == nil{
            StorageUtils.setNormalDefault(keyName: "isAutoUpdate", keyValue: true as AnyObject?)
            self.autoUpdateUISwitch.isOn = true
        }else{
            self.autoUpdateUISwitch.isOn = isAutoUpdate as! Bool
        }
        //useCusKeyboard
        let isUseCusKeyBoard = StorageUtils.getNormalDefault(keyName: "isUseCusKeyBoard") as AnyObject?
        if isUseCusKeyBoard == nil{
            StorageUtils.setNormalDefault(keyName: "isUseCusKeyBoard", keyValue: true as AnyObject?)
            self.useCusKeyboardUISwitch.isOn = true
        }else{
            self.useCusKeyboardUISwitch.isOn = isAutoUpdate as! Bool
        }
        //remberPwdUISwitch
        let isRemberPwd = StorageUtils.getNormalDefault(keyName: "isRemberPwd") as AnyObject?
        if isRemberPwd == nil{
            StorageUtils.setNormalDefault(keyName: "isRemberPwd", keyValue: true as AnyObject?)
            self.remberPwdUISwitch.isOn = true
        }else{
            self.remberPwdUISwitch.isOn = isRemberPwd as! Bool
        }
        //autoLoginUISwitch
        let isAutoLogin = StorageUtils.getNormalDefault(keyName: "isAutoLogin") as AnyObject?
        if isAutoLogin == nil{
            StorageUtils.setNormalDefault(keyName: "isAutoLogin", keyValue: true as AnyObject?)
            self.autoLoginUISwitch.isOn = true
        }else{
            self.autoLoginUISwitch.isOn = isAutoLogin as! Bool
        }
        //初始化网络访问类型设置
        let initNetworkType = StorageUtils.getNormalDefault(keyName: "access") as AnyObject?
        if initNetworkType == nil {
            //keyValue 1  代表交通虚拟专网 2 代表互联网
            StorageUtils.setNormalDefault(keyName: "access", keyValue: 2 as AnyObject?)
            self.networkUISwitch.isOn = false
        }else{
            switch initNetworkType as! Int {
            case 1:
                self.networkUISwitch.isOn = true
            default:
                self.networkUISwitch.isOn = false
            }
        }
        //loginbutton
        //注销按钮
        self.logoutBtn = UIButton()
        self.scrollview?.addSubview(self.logoutBtn!)
        //注销按钮
        //self.logoutBtn = UIButton(type:.custom)
        self.logoutBtn?.setTitle("注销登录", for: .normal)
        self.logoutBtn?.setTitleColor(UIColor.white, for: .normal)
        self.logoutBtn?.backgroundColor = UIColor.transform(fromHexString: "#1b7dc9")
        self.logoutBtn?.layer.cornerRadius = 8
        self.logoutBtn?.addTarget(self, action: #selector(tapped(_:)), for: UIControlEvents.touchDown)
        self.logoutBtn?.addTarget(self, action: #selector(tappedUp(_:)), for: UIControlEvents.touchUpInside)
        self.autoUpdateUISwitch.tag = 2
        self.useCusKeyboardUISwitch.tag = 3
        self.remberPwdUISwitch.tag = 4
        self.autoLoginUISwitch.tag = 5
        self.networkUISwitch.tag = 6
        self.autoUpdateUISwitch.addTarget(self, action: #selector(switchOnorOff(_:)), for: UIControlEvents.valueChanged)
        self.useCusKeyboardUISwitch.addTarget(self, action: #selector(switchOnorOff(_:)), for: UIControlEvents.valueChanged)
        self.remberPwdUISwitch.addTarget(self, action: #selector(switchOnorOff(_:)), for: UIControlEvents.valueChanged)
        self.autoLoginUISwitch.addTarget(self, action: #selector(switchOnorOff(_:)), for: UIControlEvents.valueChanged)
        self.networkUISwitch.addTarget(self, action: #selector(switchOnorOff(_:)), for: UIControlEvents.valueChanged)
    }
    override func viewDidLayoutSubviews() {
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.logoUIView?.addConstraint(NSLayoutConstraint(item: self.imageView!, attribute: .centerX, relatedBy: .equal, toItem: self.logoUIView, attribute: .centerX, multiplier: 1, constant: 0))
        self.logoUIView?.addConstraint(NSLayoutConstraint(item: self.imageView!, attribute: .centerY, relatedBy: .equal, toItem: self.logoUIView, attribute: .centerY, multiplier: 1, constant: 0))
        self.logoUIView?.addConstraint(NSLayoutConstraint(item: self.imageView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80))
        self.logoUIView?.addConstraint(NSLayoutConstraint(item: self.imageView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90))
        self.versionLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.logoUIView?.addConstraint(NSLayoutConstraint(item: self.versionLabel!, attribute: .bottom, relatedBy: .equal, toItem: self.logoUIView!, attribute: .bottom, multiplier: 1, constant: 0))
        self.logoUIView?.addConstraint(NSLayoutConstraint(item: self.versionLabel!, attribute: .centerX, relatedBy: .equal, toItem: self.logoUIView!, attribute: .centerX, multiplier: 1, constant: 0))
        
        //scrollview content
        self.scrollview?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollview]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["scrollview":self.scrollview!]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[logoUIView][scrollview]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["logoUIView":self.logoUIView!,"scrollview":self.scrollview!]))
        
        self.updateUIView?.translatesAutoresizingMaskIntoConstraints = false
        self.scrollview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[updateUIView(\(ScreenWidth-16))]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["updateUIView":self.updateUIView!]))
        self.scrollview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(8)-[updateUIView]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["updateUIView":self.updateUIView!]))
        
        self.checkUpdateLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.updateUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[checkUpdateLabel]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["checkUpdateLabel":self.checkUpdateLabel!]))
        self.updateUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(8)-[checkUpdateLabel(33)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["checkUpdateLabel":self.checkUpdateLabel!]))
        
        self.checkUpdateLine?.translatesAutoresizingMaskIntoConstraints = false
        self.updateUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[checkUpdateLine]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["checkUpdateLine":self.checkUpdateLine!]))
        self.updateUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[checkUpdateLabel]-(8)-[checkUpdateLine(0.5)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["checkUpdateLabel":self.checkUpdateLabel!,"checkUpdateLine":self.checkUpdateLine!]))
        
        self.autoUpdateLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.updateUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[autoUpdateLabel]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["autoUpdateLabel":self.autoUpdateLabel!]))
        self.updateUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[checkUpdateLine]-(8)-[autoUpdateLabel(33)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["checkUpdateLine":self.checkUpdateLine!,"autoUpdateLabel":self.autoUpdateLabel!]))
        
        self.autoUpdateUISwitch.translatesAutoresizingMaskIntoConstraints = false
        self.updateUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[autoUpdateUISwitch]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["autoUpdateUISwitch":self.autoUpdateUISwitch]))
        self.updateUIView?.addConstraint(NSLayoutConstraint(item: self.autoUpdateUISwitch, attribute: .centerY, relatedBy: .equal, toItem: self.autoUpdateLabel, attribute: .centerY, multiplier: 1, constant: 0))
        
        self.autoUpdateLine?.translatesAutoresizingMaskIntoConstraints = false
        self.updateUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[autoUpdateLine]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["autoUpdateLine":self.autoUpdateLine!]))
        self.updateUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[autoUpdateLabel]-(8)-[autoUpdateLine(0.5)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["autoUpdateLabel":self.autoUpdateLabel!,"autoUpdateLine":self.autoUpdateLine!]))
        
        self.useCusKeyBoardLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.updateUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[useCusKeyBoardLabel]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["useCusKeyBoardLabel":self.useCusKeyBoardLabel!]))
        self.updateUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[autoUpdateLine]-(8)-[useCusKeyBoardLabel(33)]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["autoUpdateLine":self.autoUpdateLine!,"useCusKeyBoardLabel":self.useCusKeyBoardLabel!]))
        
        self.useCusKeyboardUISwitch.translatesAutoresizingMaskIntoConstraints = false
        self.updateUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[useCusKeyboardUISwitch]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["useCusKeyboardUISwitch":self.useCusKeyboardUISwitch]))
        self.updateUIView?.addConstraint(NSLayoutConstraint(item: self.useCusKeyboardUISwitch, attribute: .centerY, relatedBy: .equal, toItem: self.useCusKeyBoardLabel, attribute: .centerY, multiplier: 1, constant: 0))
        
        //secondUIView
        self.secondUIView?.translatesAutoresizingMaskIntoConstraints = false
        self.scrollview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[secondUIView]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["secondUIView":self.secondUIView!]))
        self.scrollview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[updateUIView]-(8)-[secondUIView]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["updateUIView":self.updateUIView!,"secondUIView":self.secondUIView!]))
        
        //remember password
        self.remberPwdLabel.translatesAutoresizingMaskIntoConstraints = false
        self.secondUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[remberPwdLabel]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["remberPwdLabel":self.remberPwdLabel]))
        self.secondUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(8)-[remberPwdLabel(33)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["remberPwdLabel":self.remberPwdLabel]))
        
        self.remberPwdUISwitch.translatesAutoresizingMaskIntoConstraints = false
        self.secondUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[remberPwdUISwitch]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["remberPwdUISwitch":self.remberPwdUISwitch]))
        self.secondUIView?.addConstraint(NSLayoutConstraint(item: self.remberPwdUISwitch, attribute: .centerY, relatedBy: .equal, toItem: self.remberPwdLabel, attribute: .centerY, multiplier: 1, constant: 0))
        
        self.remberPwdLine.translatesAutoresizingMaskIntoConstraints = false
        self.secondUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[remberPwdLine]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["remberPwdLine":self.remberPwdLine]))
        self.secondUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[remberPwdLabel]-(8)-[remberPwdLine(0.5)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["remberPwdLabel":self.remberPwdLabel,"remberPwdLine":self.remberPwdLine]))
        
        //autologin
        self.autoLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        self.secondUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[autoLoginLabel]", options:NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["autoLoginLabel":self.autoLoginLabel]))
        self.secondUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[remberPwdLine]-(8)-[autoLoginLabel(33)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["remberPwdLine":self.remberPwdLine,"autoLoginLabel":self.autoLoginLabel]))
        
        self.autoLoginUISwitch.translatesAutoresizingMaskIntoConstraints = false
        self.secondUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[autoLoginUISwitch]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["autoLoginUISwitch":self.autoLoginUISwitch]))
        self.secondUIView?.addConstraint(NSLayoutConstraint(item: self.autoLoginUISwitch, attribute: .centerY, relatedBy: .equal, toItem: self.autoLoginLabel, attribute: .centerY, multiplier: 1, constant: 0))
        
        self.autoLoginLine.translatesAutoresizingMaskIntoConstraints = false
        self.secondUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[autoLoginLine]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["autoLoginLine":self.autoLoginLine]))
        self.secondUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[autoLoginLabel]-(8)-[autoLoginLine(0.5)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["autoLoginLabel":self.autoLoginLabel,"autoLoginLine":self.autoLoginLine]))
        
        self.useIntranetLabel.translatesAutoresizingMaskIntoConstraints = false
        self.secondUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[useIntranetLabel]", options:NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["useIntranetLabel":self.useIntranetLabel]))
        self.secondUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[autoLoginLine]-(8)-[useIntranetLabel(33)]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["autoLoginLine":self.autoLoginLine,"useIntranetLabel":self.useIntranetLabel]))
        
        self.networkUISwitch.translatesAutoresizingMaskIntoConstraints = false
        self.secondUIView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[networkUISwitch]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["networkUISwitch":self.networkUISwitch]))
        self.secondUIView?.addConstraint(NSLayoutConstraint(item: self.networkUISwitch, attribute: .centerY, relatedBy: .equal, toItem: self.useIntranetLabel, attribute: .centerY, multiplier: 1, constant: 0))
        
        
        self.logoutBtn?.translatesAutoresizingMaskIntoConstraints = false
        self.scrollview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[logoutBtn]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["logoutBtn":self.logoutBtn!]))
        self.scrollview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[secondUIView]-(8)-[logoutBtn(44)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["secondUIView":self.secondUIView!,"logoutBtn":self.logoutBtn!]))
        
        //给检查更新的背景，添加左上圆角和右上圆角
        self.checkUpdateLabel?.addCorner(roundCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], cornerSize: CGSize(width: 8, height: 8))
        
    }
    
    func clickDown(_ button:UIButton){
        button.backgroundColor = UIColor.transform(fromHexString: "#F0EFF5")
    }
    func clickUp(_ button:UIButton){
        button.backgroundColor = UIColor.white
        
        checkUpdate()
    }
    
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
                if let rsData = str.data(using: .utf8) {
                    guard let versionArr = try?  JSONSerialization.jsonObject(with: rsData, options: .mutableContainers) as! [[String:Any]] else{
                        return
                    }
                    let serverVersion = versionArr[0]["version"] as! String
                    let description = versionArr[0]["description"] as! String
                    let result = serverVersion.compare(localVersion)
                    //线上app版本比当前版本大，应该提示更新
                    if result.rawValue == 1 {
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
                        
                    }else if serverVersion == localVersion{
                        DispatchQueue.global().async {
                            DispatchQueue.main.async {
                                ToastView.getInstance().showToast(content: "已是最新版本！")
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
    
    func switchOnorOff(_ sw:UISwitch){
        switch sw.tag{
        case SwitchType.AutoUpdate.rawValue:
            let autoUpdate = self.autoUpdateUISwitch.isOn
            StorageUtils.setNormalDefault(keyName: "isAutoUpdate", keyValue: autoUpdate as AnyObject?)
        case SwitchType.RemberPwdUISwitch.rawValue:
            let yorn = self.remberPwdUISwitch.isOn
            StorageUtils.setNormalDefault(keyName: "isRemberPwd", keyValue: yorn as AnyObject?)
            if !yorn {
                StorageUtils.setNormalDefault(keyName: "userName", keyValue: "" as AnyObject?)
                StorageUtils.setNormalDefault(keyName: "password", keyValue:  "" as AnyObject?)
            }
            
            
        case SwitchType.AutoLoginSwitch.rawValue:
            let ooc = self.autoLoginUISwitch.isOn
            StorageUtils.setNormalDefault(keyName: "isAutoLogin", keyValue: ooc as AnyObject?)
        case SwitchType.NetworkSwitch.rawValue:
            let inOrOut = self.networkUISwitch.isOn
            if inOrOut {
                StorageUtils.setNormalDefault(keyName: "access", keyValue: 1 as AnyObject?)
                
            }else{
                StorageUtils.setNormalDefault(keyName: "access", keyValue: 2 as AnyObject?)
            }
        default:
            break
        }
    }
    //loginBtn按钮点击事件
    func tapped(_ button:UIButton){
        let lightBlue:UIColor? = UIColor.transform(fromHexString: "#4eaaf1")
        button.backgroundColor = lightBlue
        //如果登录成功，即马上跳转到首页
    }
    func tappedUp(_ button:UIButton){
        let lv = LoginViewController()
        self.settingDelegate = lv
        self.settingDelegate?.setComebackSignal!(forComeBack: true)
        self.present(lv, animated: true, completion: nil)
        button.backgroundColor = UIColor.transform(fromHexString: "#1b7dc9")
    }
    
    @objc private func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
enum SwitchType:Int{
    case AutoUpdate = 2
    case UseCusKeyboard = 3
    case RemberPwdUISwitch = 4
    case AutoLoginSwitch = 5
    case NetworkSwitch = 6
}
