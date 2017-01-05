//
//  LoginViewController.swift
//  zf
//
//  Created by waterway on 2016/10/24.
//  Copyright © 2016年 waterway. All rights reserved.
//

import UIKit
class LoginViewController: UIViewController{
    
    //执法大logo
    var zFLogo:UIImageView?
    //用户名输入框
    var userTextFiled:UITextField?
    //密码输入框
    var pwdTextFiled:UITextField?
    //登录按钮
    var loginBtn:UIButton?
    //内外网切换
    var changeNetworkBtn:UIButton?
    var loginUIView = UIView()
    //键盘与登录框中的高度差
    var dvalue:CGFloat?
    var centerYloginUIViewConstraint:NSLayoutConstraint?
    //当键盘弹出时，页面同时上移
    func keyboardWillShow(_ aNotification:Notification){
        let userInfo:Dictionary = aNotification.userInfo!
        let nsValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue
        let keyboardRec = nsValue?.cgRectValue
        let keyboardHeight = (keyboardRec?.height)! as CGFloat
        dvalue = self.loginUIView.frame.height + self.loginUIView.frame.origin.y - (self.view.frame.height-keyboardHeight)-24
        if Int(dvalue!) > 0{
            self.view.removeConstraint(centerYloginUIViewConstraint!)
            centerYloginUIViewConstraint = NSLayoutConstraint(item: loginUIView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: -dvalue!)
            self.view.addConstraint(centerYloginUIViewConstraint!)
            
        }
        
    }
    
    func keyboardWillHiden(_ aNotification:Notification){
        let userInfo:Dictionary = aNotification.userInfo!
        let nsValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue
        let keyboardRec = nsValue?.cgRectValue
        let intersection = keyboardRec?.intersection(self.view.frame)
        let keyboardHeight = intersection?.height
        if keyboardHeight == 0{
            self.view.removeConstraint(centerYloginUIViewConstraint!)
            centerYloginUIViewConstraint = NSLayoutConstraint(item: loginUIView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
            self.view.addConstraint(centerYloginUIViewConstraint!)
            
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        let welVc = WelcomePageViewController()
        self.addChildViewController(welVc)
        self.view.addSubview(loginUIView)
        //监听键盘的高度变化
        let centerDefault = NotificationCenter.default
        centerDefault.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        centerDefault.addObserver(self, selector: #selector(keyboardWillHiden(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        //初始化默认值 默认记住密码、自动登录
        initAutoLoginAndRemPwd()
        //执法logo
        zFLogo = UIImageView(image:UIImage(named:"logo_bg"))
        zFLogo?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100)
        zFLogo?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100)
        zFLogo?.contentMode = .scaleAspectFit
        self.loginUIView.addSubview(zFLogo!)
        
        
        //创建用户名文本输入框
        userTextFiled = UITextField(frame: CGRect(x:20,y:210,width:UIScreen.main.bounds.size.width-40,height:60))
        userTextFiled?.borderStyle = UITextBorderStyle.roundedRect
        userTextFiled?.placeholder = "账号"
        userTextFiled?.clearButtonMode = UITextFieldViewMode.whileEditing
        userTextFiled?.returnKeyType = UIReturnKeyType.done
        userTextFiled?.delegate = self
        self.userTextFiled?.addTarget(self, action: #selector(textFiledListener), for: UIControlEvents.allEditingEvents)
        
        
        
        
        //用户名输入框的左侧的图标
        let userTextFieldUIView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        userTextFiled?.leftView = userTextFieldUIView
        let imgUser = UIImageView(image:UIImage(named: "user-img"))
        imgUser.frame = CGRect(x: 11, y: 11, width: 22, height: 22)
        imgUser.contentMode = UIViewContentMode.scaleAspectFit
        userTextFieldUIView.addSubview(imgUser)
        userTextFiled?.leftViewMode = UITextFieldViewMode.always
        
        self.loginUIView.addSubview(userTextFiled!)
        // self.userTextFiled?.addTarget(self, action: #selector(""), for: <#T##UIControlEvents#>)
        //创建密码输入框
        pwdTextFiled = UITextField(frame: CGRect(x:20,y:280,width:UIScreen.main.bounds.size.width-40,height:60))
        pwdTextFiled?.borderStyle = UITextBorderStyle.roundedRect
        pwdTextFiled?.placeholder = "密码"
        pwdTextFiled?.clearButtonMode = UITextFieldViewMode.whileEditing
        pwdTextFiled?.returnKeyType = UIReturnKeyType.done
        pwdTextFiled?.isSecureTextEntry = true
        
        //密码输入框左侧的图标
        let pwdTextFiledUIView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        pwdTextFiled?.leftView = pwdTextFiledUIView
        let imgPwd = UIImageView(image: UIImage(named: "pwd-img"))
        imgPwd.frame = CGRect(x:11,y:11,width:22,height:22)
        pwdTextFiledUIView.addSubview(imgPwd)
        imgPwd.contentMode = UIViewContentMode.scaleAspectFit
        pwdTextFiled?.leftViewMode = UITextFieldViewMode.always
        pwdTextFiled?.delegate = self
        self.loginUIView.addSubview(pwdTextFiled!)
        self.pwdTextFiled?.addTarget(self, action: #selector(textFiledListener), for: UIControlEvents.allEditingEvents)
        
        
        //登录按钮
        loginBtn = UIButton(type:.custom)
        loginBtn?.frame = CGRect(x:0,y:370,width:UIScreen.main.bounds.size.width * 0.88,height:44)
        loginBtn?.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: 380)
        loginBtn?.setTitle("登录", for: .normal)
        loginBtn?.setTitleColor(UIColor.white, for: .normal)
        loginBtn?.setTitleColor(UIColor.white, for: .highlighted)
        loginBtn?.backgroundColor = UIColor.transform(fromHexString: "#1b7dc9")
        loginBtn?.layer.cornerRadius = 8
        loginBtn?.addTarget(self, action: #selector(tapped(_:)), for: UIControlEvents.touchDown)
        loginBtn?.addTarget(self, action: #selector(tappedUp(_:)), for: UIControlEvents.touchUpInside)
        self.loginUIView.addSubview(loginBtn!)
        self.loginBtn?.disable()
        
        if let isRememberPasswd = StorageUtils.getNormalDefault(keyName: "isRemberPwd"){
            if !(isRememberPasswd as! Bool){
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        self.userTextFiled?.text = ""
                        self.pwdTextFiled?.text = ""
                    }
                }
                
            }
        }
        
        
        
        //初始化网络访问类型设置
        let initNetworkType = StorageUtils.getNormalDefault(keyName: "access") as AnyObject?
        if initNetworkType == nil {
            //keyValue 1  代表交通虚拟专网 2 代表互联网
            StorageUtils.setNormalDefault(keyName: "access", keyValue: 2 as AnyObject?)
        }
        
        //内外网切换按钮
        changeNetworkBtn = UIButton(type: UIButtonType.custom)
        changeNetworkBtn?.frame = CGRect(x: 0, y: 0, width: 300, height: 80)
        changeNetworkBtn?.center.x = self.view.bounds.width/2
        changeNetworkBtn?.center.y = 450
        changeNetworkBtn?.setTitleColor(UIColor.blue, for: UIControlState.normal)
        changeNetworkBtn?.addTarget(self, action: #selector(showDialog), for: UIControlEvents.touchDown)
        let cAccessType = StorageUtils.getNormalDefault(keyName: "access") as! Int
        switch cAccessType {
        case AccessTypeEnum.Internet.rawValue:
            self.changeNetworkBtn?.setTitle("互联网版", for: UIControlState.normal)
        case AccessTypeEnum.Intranet.rawValue:
            self.changeNetworkBtn?.setTitle("交通虚拟专网版", for: UIControlState.normal)
        default: break
        }
        self.loginUIView.addSubview(changeNetworkBtn!)
        
        
        userTextFiled?.translatesAutoresizingMaskIntoConstraints = false
        loginUIView.addConstraint(NSLayoutConstraint(item: userTextFiled!, attribute: .top, relatedBy: .equal, toItem: zFLogo, attribute: .bottom, multiplier: 1, constant: 8))
        loginUIView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[userTextFiled]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["userTextFiled":userTextFiled!]))
        loginUIView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[userTextFiled(44)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["userTextFiled":userTextFiled!]))
        
        pwdTextFiled?.translatesAutoresizingMaskIntoConstraints = false
        loginUIView.addConstraint(NSLayoutConstraint(item: pwdTextFiled!, attribute: .top, relatedBy: .equal, toItem: userTextFiled!, attribute: .bottom, multiplier: 1, constant: 8))
        loginUIView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[pwdTextFiled]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["pwdTextFiled":pwdTextFiled!]))
        loginUIView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[pwdTextFiled(44)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["pwdTextFiled":pwdTextFiled!]))
        
        loginBtn?.translatesAutoresizingMaskIntoConstraints = false
        loginUIView.addConstraint(NSLayoutConstraint(item: loginBtn!, attribute: .top, relatedBy: .equal, toItem: pwdTextFiled!, attribute: .bottom, multiplier: 1, constant: 8))
        loginUIView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[loginBtn]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["loginBtn":loginBtn!]))
        loginUIView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[loginBtn(44)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["loginBtn":loginBtn!]))
        
        changeNetworkBtn?.translatesAutoresizingMaskIntoConstraints = false
        loginUIView.addConstraint(NSLayoutConstraint(item: changeNetworkBtn!, attribute: .top, relatedBy: .equal, toItem: loginBtn, attribute: .bottom, multiplier: 1, constant: 16))
        loginUIView.addConstraint(NSLayoutConstraint(item: changeNetworkBtn!, attribute: .centerX, relatedBy: .equal, toItem: self.loginUIView, attribute: .centerX, multiplier: 1, constant: 0))
        loginUIView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[changeNetworkBtn(300)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["changeNetworkBtn":changeNetworkBtn!]))
        loginUIView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[changeNetworkBtn(44)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["changeNetworkBtn":changeNetworkBtn!]))
        
        
        let zFLogoHeight = (zFLogo?.frame.size.height)! as CGFloat
        let userTextFiledHeight = (userTextFiled?.frame.size.height)! as CGFloat
        let pwdTextFiledHeight = (pwdTextFiled?.frame.size.height)! as CGFloat
        let loginBtnHeight = (loginBtn?.frame.size.height)! as CGFloat
        let changeNetworkBtnHeight = (changeNetworkBtn?.frame.size.height)! as CGFloat
        let loginUIViewHeight = zFLogoHeight+userTextFiledHeight+pwdTextFiledHeight+loginBtnHeight+changeNetworkBtnHeight
        loginUIView.translatesAutoresizingMaskIntoConstraints = false
        
        //Y轴
        centerYloginUIViewConstraint = NSLayoutConstraint(item: loginUIView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraint(NSLayoutConstraint(item: loginUIView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(centerYloginUIViewConstraint!)
        self.view.addConstraint(NSLayoutConstraint(item: loginUIView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: loginUIView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:loginUIViewHeight))
        //自动登录
        DispatchQueue.global().sync {
            DispatchQueue.main.async {
                self.autoLogin()
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if (self.userTextFiled?.notEmpty)! && (self.pwdTextFiled?.notEmpty)! && (self.pwdTextFiled?.validatePassword())!{
            self.loginBtn?.enable()
        }else{
            self.loginBtn?.disable()
        }
    }
    
    enum AccessTypeEnum:Int{
        case Intranet = 1
        case Internet = 2
    }
    
    //切换网络访问方式
    func showDialog(){
        var msg:String?
        let currentAccessType = StorageUtils.getNormalDefault(keyName: "access") as! Int
        switch currentAccessType {
        case AccessTypeEnum.Internet.rawValue:
            msg = "请问是否要切换到交通虚拟专网访问！"
        case AccessTypeEnum.Intranet.rawValue:
            msg = "请问是否要切换到互联网访问！"
        default: break
            
        }
        
        let alertController = UIAlertController(title: "温馨提示", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let conform = UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive, handler: {(UIAlertAction) -> Void in
            if currentAccessType == 2{
                StorageUtils.setNormalDefault(keyName: "access", keyValue: 1 as AnyObject?)
                self.changeNetworkBtn?.setTitle("交通虚拟专网版", for: UIControlState.normal)
            }else{
                StorageUtils.setNormalDefault(keyName: "access", keyValue: 2 as AnyObject?)
                self.changeNetworkBtn?.setTitle("互联网版", for: UIControlState.normal)
            }
        })
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(conform)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    //弹出确定对话框
    func showAlertWithMessage(_ msg: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
    //监听UITextField
    func textFiledListener(){
        
        if (self.userTextFiled?.notEmpty)! && (self.pwdTextFiled?.notEmpty)! && (self.pwdTextFiled?.validatePassword())!{
            self.loginBtn?.enable()
        }else{
            self.loginBtn?.disable()
        }
    }
    
    //loginBtn按钮点击事件
    func tapped(_ button:UIButton){
        let lightBlue:UIColor? = UIColor.transform(fromHexString: "#4eaaf1")
        button.backgroundColor = lightBlue
    }
    
    
    func tappedUp(_ button:UIButton){
        button.backgroundColor = UIColor.transform(fromHexString: "#1b7dc9")
        self.userTextFiled?.resignFirstResponder()
        self.pwdTextFiled?.resignFirstResponder()
        //remember username and password
        let isRemberPwd1 = StorageUtils.getNormalDefault(keyName: "isRemberPwd") as AnyObject?
        if isRemberPwd1 as! Bool{
            StorageUtils.setNormalDefault(keyName: "userName", keyValue: self.userTextFiled?.text as AnyObject?)
            StorageUtils.setNormalDefault(keyName: "password", keyValue: self.pwdTextFiled?.text as AnyObject?)
        }
        //如果登录成功，即马上跳转到首页
        sessionLoadData()
    }
    func sessionLoadData(){
        
        //创建URL对象
        let userName = self.userTextFiled?.text
        let pwdTemp = String.md5String(needMd5string: (self.pwdTextFiled?.text)!)
        let password = String.md5String(needMd5string: pwdTemp.uppercased())
        let urls = getURLs()
        let userData = getUserData()
        let subURL1 = urls.LoginURL + "/Account/AndroidLoginByCId?userName=" + userName!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)! + "&password=" + password
        let subURL2 = "&cid=cid&appid=appid&appKey=appKey&SoftwareVersion=" + userData.release!
        let subURL3 = "&EquipmentModel=" + userData.cellModel!
        let subURL4 = "&SystemVersion=" + (userData.iOSVersion!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
        let subURL5 = "&EquipmentBrand=" + userData.cellBrand!
        let subURL6 = "&timestamp=" + userData.getCryptoCurrentTime()
        let ar = [subURL1 , subURL2 , subURL3 , subURL4 , subURL5 , subURL6]
        let urlString = ar.joined()
        
        //创建请求对象
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let reqURL = URL(string: urlString)
        let reqObj = URLRequest(url: reqURL!)
        let dataTask = session.dataTask(with: reqObj) {
            (data,response,error) -> Void in
            if error != nil{
                
                DispatchQueue.global().async{
                    DispatchQueue.main.async {
                        ToastView.getInstance().showToast(content: "无法访问网络！",imageName: "toast")
                        let time:TimeInterval = 1
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: {
                            ToastView.getInstance().clear()
                        })
                    }
                }
                
            }else{
                let str = String(data:data!,encoding:String.Encoding.utf8)
                if (str!).contains("很抱歉") || (str!) == "\"\""{
                    DispatchQueue.global().async{
                        DispatchQueue.main.async {
                            ToastView.getInstance().showToast(content: "账号或密码不正确，请重新输入！",imageName: "toast")
                            let time:TimeInterval = 1
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: {
                                ToastView.getInstance().clear()
                            })
                            
                        }
                    }
                    
                    
                    
                }else{
                    ToastView.getInstance().clear()
                    let mStr = str?.replacingOccurrences(of: "\"", with: "")
                    if (mStr?.contains("UserId"))! {
                        self.success(string: mStr!)
                    }
                }
            }
        }
        //使用resume方法启动任务
        dataTask.resume()
        //记录loading view
        if dataTask.state == URLSessionTask.State.running{
            //loading页面
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    ToastView.getInstance().showLoadingview()
                }
            }
            
        }
        
    }
    
    func success(string str:String){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                var attr:[String] = (str.components(separatedBy: "#"))
                let application = UIApplication.shared
                let appDelegate = application.delegate as! AppDelegate
                //用户ID
                appDelegate.userData.userId = attr[1]
                //组织ID
                appDelegate.userData.orgId = attr[2]
                //角色ID
                appDelegate.userData.roleId = attr[3]
                //用户名
                appDelegate.userData.loginUser = attr[4]
                
                
                //test
                let userData = getUserData()
                print("\(userData.cellBrand)")
                print("\(userData.cellModel)")
                print("\(userData.iOSVersion)")
                print("\(userData.release)")
                print("\(userData.getCryptoCurrentTime())")
                print("\(userData.getJsonToWebService())")
                
                
                
                let indexView = IndexViewController()
                self.present(indexView, animated: true, completion: nil)
                
            }
        }
    }
    //初始化默认值
    func initAutoLoginAndRemPwd(){
        
        //init autoUpdate
        let isAutoUpdate = StorageUtils.getNormalDefault(keyName: "isAutoUpdate") as AnyObject?
        if isAutoUpdate == nil{
            StorageUtils.setNormalDefault(keyName: "isAutoUpdate", keyValue: true as AnyObject?)
        }
        //init useCusKeyBoard
        let isUseCusKeyBoard = StorageUtils.getNormalDefault(keyName: "isUseCusKeyBoard") as AnyObject?
        if isUseCusKeyBoard == nil{
            StorageUtils.setNormalDefault(keyName: "isUseCusKeyBoard", keyValue: true as AnyObject?)
        }
        //remberPwdUISwitch
        let isRemberPwd = StorageUtils.getNormalDefault(keyName: "isRemberPwd") as AnyObject?
        if isRemberPwd == nil{
            StorageUtils.setNormalDefault(keyName: "isRemberPwd", keyValue: true as AnyObject?)
        }
        //autoLoginUISwitch
        let isAutoLogin = StorageUtils.getNormalDefault(keyName: "isAutoLogin") as AnyObject?
        if isAutoLogin == nil{
            StorageUtils.setNormalDefault(keyName: "isAutoLogin", keyValue: true as AnyObject?)
        }
    }
    
    var isFromSettingPage:Bool = false
    //自动登录
    func autoLogin(){
        let isRemberPwd = StorageUtils.getNormalDefault(keyName: "isRemberPwd") as AnyObject?
        let isAutoLogin = StorageUtils.getNormalDefault(keyName: "isAutoLogin") as AnyObject?
        guard isRemberPwd != nil else{
            return
        }
        guard isAutoLogin != nil else{
            return
        }
        let userName = StorageUtils.getNormalDefault(keyName: "userName") as? String
        let password = StorageUtils.getNormalDefault(keyName: "password") as? String
        if isRemberPwd as! Bool{
            self.userTextFiled?.text = userName
            self.pwdTextFiled?.text = password
        }
        guard (self.pwdTextFiled?.notEmpty)! else{
            return
        }
        guard (self.userTextFiled?.notEmpty)! else{
            return
        }
        self.loginBtn?.enable()
        guard self.isFromSettingPage == false else{
            return
        }
        if isAutoLogin as! Bool && isRemberPwd as! Bool {
            if userName != "" && password != ""{
                sessionLoadData()
            }
        }
    }
    
    
    //手指触碰到屏幕时，弹窗消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ToastView.getInstance().clear()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit{
        //移除通知中心
        NotificationCenter.default.removeObserver(self)
    }
}
extension LoginViewController:UITextFieldDelegate{
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return true
    }
}
extension LoginViewController:SettingViewControllerDelegate{
    func setComebackSignal(forComeBack comeBack: Bool) {
        self.isFromSettingPage = comeBack
    }
}
