//
//  Extension.swift
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

extension UIButton{
    @objc func set(image anImage:UIImage?,title:String,titlePosition:UIViewContentMode,additionalSpacing:CGFloat,state:UIControlState){
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state)
        positionLabelRequestToImage(title,position:titlePosition,spacing:additionalSpacing)
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    private func positionLabelRequestToImage(_ title:String,position:UIViewContentMode,spacing:CGFloat){
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font
        let titleSize = title.size(attributes: [NSFontAttributeName:titleFont!])
        var titleInsets:UIEdgeInsets
        var imageInsets:UIEdgeInsets
        switch position {
        case .top:
            titleInsets = UIEdgeInsets(top:-(imageSize.height + titleSize.height + spacing),left:-(imageSize.width),bottom:0,right:0)
            imageInsets = UIEdgeInsets(top:0,left:0,bottom:0,right:-(titleSize.width))
        case .bottom:
            titleInsets = UIEdgeInsets(top:(imageSize.height + titleSize.height + spacing),left:-(imageSize.width),bottom:0,right:0)
            imageInsets = UIEdgeInsets(top:0,left:0,bottom:0,right:-titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top:0,left:-(imageSize.width * 2),bottom:0,right:0)
            imageInsets = UIEdgeInsets(top:0,left:0,bottom:0,right:-(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top:0,left:0,bottom:0,right:-spacing)
            imageInsets = UIEdgeInsets(top:0,left:0,bottom:0,right:0)
        default:
            titleInsets = UIEdgeInsets(top:0,left:0,bottom:0,right:0)
            imageInsets = UIEdgeInsets(top:0,left:0,bottom:0,right:0)
        }
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
    
    
}
//十六进制颜色值
extension UIColor{
    
    class func transform(fromHexString hex:String) ->UIColor {
        
        var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            let index = cString.index(cString.startIndex, offsetBy:1)
            cString = cString.substring(from: index)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.red
        }
        
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = cString.substring(to: rIndex)
        let otherString = cString.substring(from: rIndex)
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = otherString.substring(to: gIndex)
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bString = cString.substring(from: bIndex)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
}

//计算文字高度
extension String{
    func getHeightFromStringWith(stringFontSize fontSize:CGFloat,andWidth width:CGFloat) ->CGFloat{
        let font = UIFont.systemFont(ofSize: fontSize)
        let size = CGSize(width: width, height: 1000)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        let attributes = [NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy()]
        let text = self as NSString
        let rect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.size.height
    }
}

extension UIImage{
    //重设图片大小
    func reSizeImage(reSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale)
        self.draw(in: CGRect(x:0,y: 0,width:reSize.width,height:reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    //等比率缩放
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}

//所有视图都可以用，给视图的添加圆角，自定义任意一角为圆角
extension UIView{
    func addCorner(roundCorners:UIRectCorner,cornerSize:CGSize){
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundCorners, cornerRadii: cornerSize)
        let cornerLayer = CAShapeLayer()
        cornerLayer.frame = bounds
        cornerLayer.path = path.cgPath
        layer.mask = cornerLayer
    }
}

extension UIButton{
    func disable(){
        self.isEnabled = false
        self.alpha = 0.5
    }
    func enable(){
        self.isEnabled = true
        self.alpha = 1
    }
}

extension UITextField{
    var notEmpty:Bool{
        return self.text != ""
    }
    
    func validate(pattern regEx:String) -> Bool{
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self.text)
    }
    func validatePassword() -> Bool{
        return self.validate(pattern: "^[A-Z0-9a-z]{6,18}")
    }
}
//extension LoginViewController:SettingViewControllerDelegate{
 //   func setComebackSignal(forComeBack comeBack: Bool) {
 //       self.isFromSettingPage = comeBack
 //   }
//}

extension String{
    var notEmpty:Bool{
        return self.characters.count > 0
    }
    var justAllowNumber:Bool{
        
        if !self.notEmpty{
            return false
        }
        for c in self.characters{
            guard c > "0" && c < "9" else{
                return false
            }
        }
        return true
    }
}


