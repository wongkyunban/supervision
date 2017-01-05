//
//  ToastView.swift
//  zf
//
//  Created by waterway on 2016/11/8.
//  Copyright © 2016年 waterway. All rights reserved.
//

import Foundation
class ToastView:NSObject{
    static var instance:ToastView?
    var windows = UIApplication.shared.windows
    let rv:UIView? = UIApplication.shared.keyWindow?.subviews.first as UIView!
    
    static func getInstance() -> ToastView{
        if instance == nil{
           instance  = ToastView()
        }
        return instance!
    }
    //显示加载的圈圈
    func showLoadingview(){
        clear()
        //定义弹出的loading框的大小
        let frame = CGRect(x: 0, y: 0, width: 78, height: 78)
        let loadingContainerView = UIView(frame:frame)
        loadingContainerView.layer.cornerRadius = 12
        loadingContainerView.backgroundColor = UIColor(red:0,green:0,blue:0,alpha:0.6)
        let indicatorWidthHeight:CGFloat = 36
        let loadingIndicatorView = UIActivityIndicatorView(frame: CGRect(x: (frame.width - indicatorWidthHeight)/2, y: (frame.height - indicatorWidthHeight)/2, width: indicatorWidthHeight, height: indicatorWidthHeight))
        loadingIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        loadingIndicatorView.startAnimating()
        loadingContainerView.addSubview(loadingIndicatorView)
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        window.frame = frame
        window.windowLevel = UIWindowLevelAlert
        window.center = CGPoint(x: (rv?.center.x)!, y: (rv?.center.y)!)
        window.isHidden = false
        window.addSubview(loadingContainerView)
        windows.append(window)
    }
    
    //弹窗文字
    func showToast(content str:String,imageName img:String = "toast",duration durate:CFTimeInterval = 1.5){
        clear()
        let frame = CGRect(x:0,y:0,width:280,height:90)
        let toastContainerView = UIView(frame:frame)
        toastContainerView.layer.cornerRadius = 10
        toastContainerView.backgroundColor = UIColor(red:0,green:0,blue:0,alpha: 0.6)
        let iconWidthHeight:CGFloat = 36
        let toastIconView = UIImageView(frame:CGRect(x:(frame.width - iconWidthHeight)/2,y:15,width:iconWidthHeight,height:iconWidthHeight))
        toastIconView.image = UIImage(named: img)
        toastContainerView.addSubview(toastIconView)
        let toastContentView = UILabel(frame:CGRect(x: 0, y: iconWidthHeight + 5, width: frame.width, height: frame.height - iconWidthHeight))
        toastContentView.font = UIFont.systemFont(ofSize: 13)
        toastContentView.textColor = UIColor.white
        toastContentView.text = str
        toastContentView.textAlignment = NSTextAlignment.center
        toastContainerView.addSubview(toastContentView)
        let windowK = UIWindow(frame:frame)
        windowK.backgroundColor = UIColor.clear
        windowK.windowLevel = UIWindowLevelAlert
        windowK.center = CGPoint(x: (rv?.center.x)!, y: (rv?.center.y)!*16/10)
        windowK.isHidden = false
        windowK.addSubview(toastContainerView)
        windows.append(windowK)
        toastContainerView.layer.add(AnimationUtil.getToastAnimation(duration: durate), forKey: "animation")
        perform(#selector(removeToast(sender:)), with: windowK, afterDelay: durate)
    }
    
    //移除当前弹窗
    func removeToast(sender aSender:AnyObject){
        if let window = aSender as? UIWindow{
            if let index = windows.index(where: { (item) -> Bool in
                return item == window
            }){
                windows.remove(at: index)
            }
        }
        
    }
    
    // 清除所有弹窗
    func clear(){
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        windows.removeAll(keepingCapacity: false)
    }
    
}
