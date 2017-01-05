//
//  AnimationUtil.swift
//  zf
//
//  Created by waterway on 2016/11/8.
//  Copyright © 2016年 waterway. All rights reserved.
//
//弹窗动画
import Foundation

class AnimationUtil{
    static func getToastAnimation(duration durate:CFTimeInterval = 1.5) ->CAAnimation{
        //大小变化动画
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0,0.1,0.9,1]
        scaleAnimation.values = [0.5,1,1,0.5]
        scaleAnimation.duration = durate
        
        //透明度变化动画
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.keyTimes = [0,0.8,1]
        opacityAnimation.values = [0.5,1,0]
        opacityAnimation.duration = durate
        
        //动画组
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation,opacityAnimation]
        //动画的过渡效果
        //1. kCAMediaTimingFunctionLinear(线性)
        //2. kCAMediaTimingFunctionEaseIn(淡入)
        //3. kCAMediaTimingFunctionEaseOut(淡出)
        //4. kCAMediaTimingFunctionEaseInEaseOut(淡入淡出)
        //5. kCAMediaTimingFunctionDefault(默认)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = durate
        animation.repeatCount = 0
        animation.isRemovedOnCompletion = false
        return animation
    }
}
