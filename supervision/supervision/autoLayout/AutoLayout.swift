//
//  AutoLayout.swift
//  supervision
//
//  Created by waterway on 2017/1/5.
//  Copyright © 2017年 waterway. All rights reserved.
//
//自动布局约束库
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


extension UIView {
    
    struct comit_AssociatedObjectKey {
        static var kRightConstraint        = "rightConstraint"
        static var kBottomConstraint       = "bottomConstraint"
        static var kEquelWidthConstraint   = "equelWidthConstraint"
        static var kAutoWidthConstraint    = "autoWidthConstraint"
        static var kSelfWidthConstraint    = "selfWidthConstraint"
        static var kEquelHeightConstraint  = "equelHeightConstraint"
        static var kAutoHeightConstraint   = "autoHeightConstraint"
        static var kSelfHeightConstraint   = "selfHeightConstraint"
        static var kWidthWeight            = "widthWeight"
        static var kHeightWeight           = "heightWeight"
        static var kCellBottomOffset       = "cellBottomOffset"
        static var kCellBottomView         = "cellBottomView"
        static var kCellBottomViews        = "cellBottomViews"
        static var kCellTableView          = "cellTableView"
        static var kCellTableViewWidth     = "TableViewWidth"
        static var kIsMonitorScreen        = "isMonitorScreen"
        static var kCacheHeightDictionary  = "cacheHeightDictionary"
        static var kLeftPadding            = "leftPadding"
        static var kRightPadding           = "rightPadding"
        static var kTopPadding             = "topPadding"
        static var kBottomPadding          = "bottomPadding"
        
        static var kFieldLeftPadding       = "fieldLeftPadding"
        static var kFieldRightPadding      = "fieldRightPadding"
        static var kFieldTopPadding        = "fieldTopPadding"
        static var kFieldBottomPadding     = "fieldBottomPadding"
        
        static var kKeepWidthConstraint    = "kKeepWidthConstraint"
        static var kKeepHeightConstraint    = "kKeepHeightConstraint"
        static var kKeepBottomConstraint    = "kKeepBottomConstraint"
        static var kKeepRightConstraint    = "kKeepRightConstraint"
        
        static var kCurrentConstraints     = "kCurrentConstraints"
    }
    
    override open class func initialize() {
        struct comit_AutoLayoutLoad {
            static var token: Int = 0
        }
        if comit_AutoLayoutLoad.token == 0 {
            comit_AutoLayoutLoad.token = 1
            let addConstraint = class_getInstanceMethod(self, #selector(UIView.addConstraint(_:)))
            let comit_AddConstraint = class_getInstanceMethod(self, #selector(UIView.comit_AddConstraint(_:)))
            method_exchangeImplementations(addConstraint, comit_AddConstraint)
        }
    }
    
    /// 当前添加的约束对象
    fileprivate var currentConstraint: NSLayoutConstraint! {
        set {
            objc_setAssociatedObject(self, &comit_AssociatedObjectKey.kCurrentConstraints, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            let value = objc_getAssociatedObject(self, &comit_AssociatedObjectKey.kCurrentConstraints)
            if value != nil {
                return value as! NSLayoutConstraint
            }
            return nil
        }
    }
    
    //MARK: - 移除约束 -
    
    /**
     * 说明:移除约束
     * @param attribute 约束类型
     */
    @discardableResult
    public func comit_RemoveConstraint(_ attribute: NSLayoutAttribute) -> UIView {
        for constraint in self.constraints {
            if constraint.firstAttribute == attribute &&
                constraint.secondItem == nil {
                self.removeConstraint(constraint)
            }
        }
        return self
    }
    
    /**
     * 说明:移除约束
     * @param attribute 约束类型
     * @param item 关联第一个约束视图
     */
    @discardableResult
    public func comit_RemoveConstraint(_ attribute: NSLayoutAttribute, item: UIView!) -> UIView {
        if item == nil {
            self.comit_RemoveConstraint(attribute)
        }else {
            for constraint in self.constraints {
                if constraint.firstAttribute == attribute &&
                    constraint.firstItem === item  &&
                    constraint.secondItem === self {
                    self.removeConstraint(constraint)
                }
            }
        }
        return self
    }
    
    /**
     * 说明:移除约束
     * @param attribute 约束类型
     * @param item 关联第一个约束视图
     * @param toItem 关联第二个约束视图
     */
    @discardableResult
    public func comit_RemoveConstraint(_ attribute: NSLayoutAttribute, item: UIView!, toItem: UIView!) -> UIView {
        for constraint in self.constraints {
            if constraint.firstAttribute == attribute &&
                constraint.firstItem === item  &&
                constraint.secondItem === toItem {
                self.removeConstraint(constraint)
            }
        }
        return self
    }
    
    //MARK: - 设置当前约束优先级 -
    /**
     * 说明:设置当前约束的低优先级
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_PriorityLow() -> UIView {
        self.currentConstraint?.priority = UILayoutPriorityDefaultLow
        return self
    }
    
    /**
     * 说明:设置当前约束的高优先级
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_PriorityHigh() -> UIView {
        self.currentConstraint?.priority = UILayoutPriorityDefaultHigh
        return self
    }
    
    /**
     * 说明:设置当前约束的默认优先级
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_PriorityRequired() -> UIView {
        self.currentConstraint?.priority = UILayoutPriorityRequired
        return self
    }
    
    /**
     * 说明:设置当前约束的合适优先级
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_PriorityFitting() -> UIView {
        self.currentConstraint?.priority = UILayoutPriorityFittingSizeLevel
        return self
    }
    
    /**
     * 说明:设置当前约束的优先级
     * @param value: 优先级大小(0-1000)
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Priority(_ value: CGFloat) -> UIView {
        self.currentConstraint?.priority = Float(value)
        return self
    }
    
    //MARK: -自动布局公开接口api-
    
    /**
     * 说明:设置左边距(默认相对父视图)
     * @param space: 左边距
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Left(_ space: CGFloat) -> UIView {
        self.constraintWithItem(self.superview, attribute: .left, constant: space)
        return self
    }
    
    /**
     * 说明:设置左边距
     * @param space: 左边距
     * @param toView: 相对参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Left(_ space: CGFloat, toView: UIView!) -> UIView {
        var toAttribute = NSLayoutAttribute.right
        if toView.superview == nil {
            toAttribute = .left
        }else if toView.superview !== self.superview {
            toAttribute = .left
        }
        self.constraintWithItem(self, attribute: .left, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: space)
        return self
    }
    
    /**
     * 说明：设置左边距相等
     * @param view 左边距相等视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_LeftEqual(_ view: UIView) -> UIView {
        return self.comit_LeftEqual(view, offset: 0)
    }
    
    /**
     * 说明：设置左边距相等
     * @param view 左边距相等视图
     * @param offset 偏移量
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_LeftEqual(_ view: UIView, offset: CGFloat) -> UIView {
        var toAttribute = NSLayoutAttribute.left
        self.constraintWithItem(self, attribute: .left, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: offset)
        return self
    }
    
    /**
     * 说明:设置右边距(默认相对父视图)
     * @param space: 右边距
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Right(_ space: CGFloat) -> UIView {
        self.constraintWithItem(self.superview, attribute: .right, constant: 0 - space)
        return self
    }
    
    /**
     * 说明:设置右边距
     * @param space: 右边距
     * @param toView: 设置右边距参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Right(_ space: CGFloat, toView: UIView!) -> UIView {
        var toAttribute = NSLayoutAttribute.left
        if toView.superview == nil {
            toAttribute = .right
        }else if toView.superview !== self.superview {
            toAttribute = .right
        }
        self.constraintWithItem(self, attribute: .right, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: 0 - space)
        return self
    }
    
    /**
     * 说明: 设置右边距相等
     * @param view 右边距相等参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_RightEqual(_ view: UIView) -> UIView {
        return self.comit_RightEqual(view, offset: 0)
    }
    
    /**
     * 说明: 设置右边距相等
     * @param view 右边距相等参考视图
     * @param offset 偏移量
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_RightEqual(_ view: UIView, offset: CGFloat) -> UIView {
        var toAttribute = NSLayoutAttribute.right
        self.constraintWithItem(self, attribute: .right, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: 0.0 - offset)
        return self
    }
    
    /**
     * 说明:设置右边距(默认相对父视图)
     * @param space: 右边距
     * @param keepWidthConstraint: 是否保留宽度约束
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Right(_ space: CGFloat, keepWidthConstraint: Bool) -> UIView {
        self.setKeepWidthConstraint(keepWidthConstraint)
        return self.comit_Right(space)
    }
    
    /**
     * 说明:设置右边距
     * @param space: 右边距
     * @param toView: 设置右边距参考视图
     * @param keepWidthConstraint: 是否保留宽度约束
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Right(_ space: CGFloat, toView: UIView!, keepWidthConstraint: Bool) -> UIView {
        self.setKeepWidthConstraint(keepWidthConstraint)
        return self.comit_Right(space, toView: toView)
    }
    
    /**
     * 说明: 设置右边距相等
     * @param view 右边距相等参考视图
     * @param keepWidthConstraint: 是否保留宽度约束
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_RightEqual(_ view: UIView, keepWidthConstraint: Bool) -> UIView {
        self.setKeepWidthConstraint(keepWidthConstraint)
        return self.comit_RightEqual(view)
    }
    
    /**
     * 说明: 设置右边距相等
     * @param view 右边距相等参考视图
     * @param offset 偏移量
     * @param keepWidthConstraint: 是否保留宽度约束
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_RightEqual(_ view: UIView, offset: CGFloat, keepWidthConstraint: Bool) -> UIView {
        self.setKeepWidthConstraint(keepWidthConstraint)
        return comit_RightEqual(view, offset: offset)
    }
    
    
    /**
     * 说明: 设置左边距(默认相对父视图)
     * @param leading 左边距
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Leading(_ space: CGFloat) -> UIView {
        self.constraintWithItem(self.superview, attribute: .leading, constant: space)
        return self
    }
    
    /**
     * 说明：设置左边距
     * @param leading 左边距
     * @param toView 左边距相对参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Leading(_ space: CGFloat, toView: UIView!) -> UIView {
        var toAttribute = NSLayoutAttribute.trailing
        if toView.superview == nil {
            toAttribute = .leading
        }else if toView.superview !== self.superview {
            toAttribute = .leading
        }
        self.constraintWithItem(self, attribute: .leading, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: space)
        return self
    }
    
    /**
     * 说明：设置左边距相等
     * @param view 左边距相等参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_LeadingEqual(_ view: UIView) -> UIView {
        return self.comit_LeadingEqual(view, offset: 0)
    }
    
    /**
     * 说明：设置左边距相等
     * @param view 左边距相等参考视图
     * @param offset 偏移量
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_LeadingEqual(_ view: UIView, offset: CGFloat) -> UIView {
        var toAttribute = NSLayoutAttribute.leading
        self.constraintWithItem(self, attribute: .leading, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: offset)
        return self
    }
    
    /**
     * 说明: 设置右对齐(默认相对父视图)
     * @param trailing 右边距
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Trailing(_ space: CGFloat) -> UIView {
        self.constraintWithItem(self.superview, attribute: .trailing, constant: 0.0 - space)
        return self
    }
    
    /**
     * 说明：设置右对齐
     * @param trailing 右边距
     * @param toView 右边距相对视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Trailing(_ space: CGFloat, toView: UIView!) -> UIView {
        var toAttribute = NSLayoutAttribute.leading
        if toView.superview == nil {
            toAttribute = .trailing
        }else if toView.superview !== self.superview {
            toAttribute = .trailing
        }
        self.constraintWithItem(self, attribute: .trailing, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: 0 - space)
        return self
    }
    
    /**
     * 说明：设置右对齐相等
     * @param view 右对齐相等参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_TrailingEqual(_ view: UIView) -> UIView {
        return self.comit_TrailingEqual(view, offset: 0)
    }
    
    /**
     * 说明：设置右对齐相等
     * @param view 右对齐相等参考视图
     * @param offset 偏移量
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_TrailingEqual(_ view: UIView, offset: CGFloat) -> UIView {
        var toAttribute = NSLayoutAttribute.trailing
        self.constraintWithItem(self, attribute: .trailing, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: 0.0 - offset)
        return self
    }
    
    /**
     * 说明:设置顶边距(默认相对父视图)
     * @param top: 顶边距
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Top(_ space: CGFloat) -> UIView {
        self.constraintWithItem(self.superview, attribute: .top, constant: space)
        return self
    }
    
    /**
     * 说明:设置顶边距
     * @param top: 顶边距
     * @param toView: 顶边距相对参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Top(_ space: CGFloat, toView: UIView!) -> UIView {
        var toAttribute = NSLayoutAttribute.bottom
        if toView.superview == nil {
            toAttribute = .top
        }else if toView.superview !== self.superview {
            toAttribute = .top
        }
        self.constraintWithItem(self, attribute: .top, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: space)
        return self
    }
    
    /**
     * 说明：设置顶边距相等
     * @param view 顶边距相等参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_TopEqual(_ view: UIView) -> UIView {
        return self.comit_TopEqual(view, offset: 0)
    }
    
    /**
     * 说明：设置顶边距相等
     * @param view 顶边距相等参考视图
     * @param offset 偏移量
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_TopEqual(_ view: UIView, offset: CGFloat) -> UIView {
        var toAttribute = NSLayoutAttribute.top
        self.constraintWithItem(self, attribute: .top, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: offset)
        return self
    }
    
    /**
     * 说明:设置底边距(默认相对父视图)
     * @param bottom: 底边距
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Bottom(_ space: CGFloat) -> UIView {
        self.constraintWithItem(self.superview, attribute: .bottom, constant: 0 - space)
        return self
    }
    
    /**
     * 说明:设置底边距
     * @param bottom: 底边距
     * @param toView: 底边距相对参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Bottom(_ space: CGFloat, toView: UIView!) -> UIView {
        var toAttribute = NSLayoutAttribute.top
        self.constraintWithItem(self, attribute: .bottom, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: space)
        return self
    }
    
    /**
     * 说明：设置底边距相等
     * @param view 底边距相等参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_BottomEqual(_ view: UIView) -> UIView {
        return self.comit_BottomEqual(view, offset: 0)
    }
    
    /**
     * 说明：设置底边距相等
     * @param view 底边距相等参考视图
     * @param offset 偏移量
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_BottomEqual(_ view: UIView, offset: CGFloat) -> UIView {
        var toAttribute = NSLayoutAttribute.bottom
        self.constraintWithItem(self, attribute: .bottom, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: offset)
        return self
    }
    
    /**
     * 说明:设置底边距(默认相对父视图)
     * @param bottom: 底边距
     * @param keepHeightConstraint: 是否保留高度约束
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Bottom(_ space: CGFloat, keepHeightConstraint: Bool) -> UIView {
        self.setKeepHeightConstraint(keepHeightConstraint)
        return self.comit_Bottom(space)
    }
    
    /**
     * 说明:设置底边距
     * @param bottom: 底边距
     * @param toView: 底边距相对参考视图
     * @param keepHeightConstraint: 是否保留高度约束
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Bottom(_ space: CGFloat, toView: UIView!, keepHeightConstraint: Bool) -> UIView {
        self.setKeepHeightConstraint(keepHeightConstraint)
        return self.comit_Bottom(space, toView: toView)
    }
    
    /**
     * 说明：设置底边距相等
     * @param view 底边距相等参考视图
     * @param keepHeightConstraint: 是否保留高度约束
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_BottomEqual(_ view: UIView, keepHeightConstraint: Bool) -> UIView {
        self.setKeepHeightConstraint(keepHeightConstraint)
        return self.comit_BottomEqual(view)
    }
    
    /**
     * 说明：设置底边距相等
     * @param view 底边距相等参考视图
     * @param offset 偏移量
     * @param keepHeightConstraint: 是否保留高度约束
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_BottomEqual(_ view: UIView, offset: CGFloat, keepHeightConstraint: Bool) -> UIView {
        self.setKeepHeightConstraint(keepHeightConstraint)
        return self.comit_BottomEqual(view, offset: offset)
    }
    
    
    /**
     * 说明:设置宽度
     * @param width: 宽度
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Width(_ width: CGFloat) -> UIView {
        var toAttribute = NSLayoutAttribute.notAnAttribute
        self.constraintWithItem(self, attribute: .width, related: .equal, toItem: nil, toAttribute: &toAttribute, multiplier: 1, constant: width)
        return self
    }
    
    /**
     * 说明:设置宽度相等
     * @param view: 宽度相等参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_WidthEqual(_ view: UIView!) -> UIView {
        self.constraintWithItem(view, attribute: .width, constant: 0)
        return self
    }
    
    /**
     * 说明:设置宽度相等
     * @param ratio: 宽度相等比例
     * @param view: 宽度相等参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_WidthEqual(_ view: UIView!, ratio: CGFloat) -> UIView {
        self.constraintWithItem(view, attribute: .width, multiplier: ratio, constant: 0)
        return self
    }
    
    /**
     * 说明:设置自动宽度
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_WidthAuto() -> UIView {
        if self is UILabel {
            let selfLabel = self as! UILabel
            if selfLabel.numberOfLines == 0 {
                selfLabel.numberOfLines = 1
            }
        }
        var toAttribute = NSLayoutAttribute.notAnAttribute
        self.constraintWithItem(self, attribute: .width, related: .greaterThanOrEqual, toItem: nil, toAttribute: &toAttribute, multiplier: 1, constant: 0)
        return self
    }
    
    /**
     * 说明:设置宽度
     * @param width: 宽度
     * @parma keepRightConstraint: 是否保留右边距约束
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Width(_ width: CGFloat, keepRightConstraint: Bool) -> UIView {
        self.setKeepRightConstraint(keepRightConstraint)
        return self.comit_Width(width)
    }
    
    /**
     * 说明:设置宽度相等
     * @param view: 宽度相等参考视图
     * @parma keepRightConstraint: 是否保留右边距约束
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_WidthEqual(_ view: UIView!, keepRightConstraint: Bool) -> UIView {
        self.setKeepRightConstraint(keepRightConstraint)
        return self.comit_WidthEqual(view)
    }
    
    /**
     * 说明:设置宽度相等
     * @param ratio: 宽度相等比例
     * @param view: 宽度相等参考视图
     * @parma keepRightConstraint: 是否保留右边距约束
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_WidthEqual(_ view: UIView!, ratio: CGFloat, keepRightConstraint: Bool) -> UIView {
        self.setKeepRightConstraint(keepRightConstraint)
        return self.comit_WidthEqual(view, ratio: ratio)
    }
    
    /**
     * 说明:设置自动宽度
     * @parma keepRightConstraint: 是否保留右边距约束
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_WidthAutoKeepRightConstraint(_ keepRightConstraint: Bool) -> UIView {
        self.setKeepRightConstraint(keepRightConstraint)
        return self.comit_WidthAuto()
    }
    
    
    /**
     * 说明: 设置视图自身高度与宽度的比
     * @param ratio 视图自身高度与宽度的比
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_HeightWidthRatio(_ ratio: CGFloat) -> UIView {
        var toAttribute = NSLayoutAttribute.width
        self.constraintWithItem(self, attribute: .height, related: .equal, toItem: self, toAttribute: &toAttribute, multiplier: ratio, constant: 0)
        return self;
    }
    
    /**
     * 说明:设置高度
     * @param height: 高度
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Height(_ height: CGFloat) -> UIView {
        self.constraintWithItem(nil, attribute: .height, constant: height)
        return self
    }
    
    /**
     * 说明:设置高度相等
     * @param view: 高度相等参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_HeightEqual(_ view: UIView!) -> UIView {
        self.constraintWithItem(view, attribute: .height, constant: 0)
        return self
    }
    
    /**
     * 说明:设置高度相等
     * @param ratio: 高度相等比例
     * @param view: 高度相等参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_HeightEqual(_ view: UIView!, ratio: CGFloat) -> UIView {
        self.constraintWithItem(view, attribute: .height, multiplier: ratio, constant: 0)
        return self
    }
    
    /**
     * 说明:设置自动高度
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_HeightAuto() -> UIView {
        if self is UILabel {
            let selfLabel = self as! UILabel
            if selfLabel.numberOfLines != 0 {
                selfLabel.numberOfLines = 0
            }
        }
        var toAttribute = NSLayoutAttribute.notAnAttribute
        self.constraintWithItem(self, attribute: .height, related: .greaterThanOrEqual, toItem: nil, toAttribute: &toAttribute, multiplier: 1, constant: 0)
        return self
    }
    
    /**
     * 说明:设置高度
     * @param height: 高度
     * @param keepBottomConstraint: 是否保留底边距约束
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Height(_ height: CGFloat, keepBottomConstraint: Bool) -> UIView {
        self.setKeepBottomConstraint(keepBottomConstraint)
        return self.comit_Height(height)
    }
    
    /**
     * 说明:设置高度相等
     * @param view: 高度相等参考视图
     * @param keepBottomConstraint: 是否保留底边距约束
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_HeightEqual(_ view: UIView!, keepBottomConstraint: Bool) -> UIView {
        self.setKeepBottomConstraint(keepBottomConstraint)
        return self.comit_HeightEqual(view)
    }
    
    /**
     * 说明:设置高度相等
     * @param ratio: 高度相等比例
     * @param view: 高度相等参考视图
     * @param keepBottomConstraint: 是否保留底边距约束
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_HeightEqual(_ view: UIView!, ratio: CGFloat, keepBottomConstraint: Bool) -> UIView {
        self.setKeepBottomConstraint(keepBottomConstraint)
        return self.comit_HeightEqual(view, ratio: ratio)
    }
    
    /**
     * 说明:设置自动高度
     * @param keepBottomConstraint: 是否保留底边距约束
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_HeightAutoKeepBottomConstraint(_ keepBottomConstraint: Bool) -> UIView {
        self.setKeepBottomConstraint(keepBottomConstraint)
        return self.comit_HeightAuto()
    }
    
    
    /**
     * 说明: 设置视图自身宽度与高度的比
     * @param ratio 视图自身宽度与高度的比
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_WidthHeightRatio(_ ratio: CGFloat) -> UIView {
        var toAttribute = NSLayoutAttribute.height
        self.constraintWithItem(self, attribute: .width, related: .equal, toItem: self, toAttribute: &toAttribute, multiplier: ratio, constant: 0)
        return self;
    }
    
    /**
     * 说明:设置中心x(默认相对父视图)
     * @param centerX: 中心x偏移量
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_CenterX(_ x: CGFloat) -> UIView {
        self.constraintWithItem(self.superview, attribute: .centerX, constant: x)
        return self
    }
    
    /**
     * 说明:设置中心x相等
     * @param view 中心x相等参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_CenterXEqual(_ view: UIView!) -> UIView {
        self.constraintWithItem(view, attribute: .centerX, constant: 0)
        return self
    }
    
    /**
     * 说明:设置中心x相等
     * @param view 中心x相等参考视图
     * @param offset 中心x偏移量
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_CenterXEqual(_ view: UIView, offset: CGFloat) -> UIView {
        self.constraintWithItem(view, attribute: .centerX, constant: offset)
        return self
    }
    
    /**
     * 说明:设置中心x与相对视图中心的偏移 centerX = 0 与相对视图中心x重合
     * @param centerX: 中心x坐标偏移
     * @param toView: 相对参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_CenterX(_ x: CGFloat, toView: UIView!) -> UIView {
        self.constraintWithItem(toView, attribute: .centerX, constant: x)
        return self
    }
    
    /**
     * 说明:设置中心y偏移(默认相对父视图)
     * @param centerY: 中心y坐标偏移量
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_CenterY(_ y: CGFloat) -> UIView {
        self.constraintWithItem(self.superview, attribute: .centerY, constant: y)
        return self
    }
    
    /**
     * 说明:设置中心y相等
     * @param view 相等参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_CenterYEqual(_ view: UIView!) -> UIView {
        self.constraintWithItem(view, attribute: .centerY, constant: 0)
        return self
    }
    
    /**
     * 说明: 设置中心y相等
     * @param view 相等参考视图
     * @param offset 偏移量
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_CenterYEqual(_ view: UIView!, offset: CGFloat) -> UIView {
        self.constraintWithItem(view, attribute: .centerY, constant: offset)
        return self
    }
    
    /**
     * 说明:设置中心y与相对视图中心的偏移 centerY = 0 与相对视图中心y重合
     * @param y: 中心y坐标偏移
     * @param toView: 相对参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_CenterY(_ y: CGFloat, toView: UIView!) -> UIView {
        self.constraintWithItem(toView, attribute: .centerY, constant: y)
        return self
    }
    
    /**
     * 说明:设置基线边距(默认相对父视图,相当于y)
     * @param space: 底部偏移量
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_BaseLine(_ space: CGFloat) -> UIView {
        self.constraintWithItem(self.superview, attribute: .lastBaseline, constant: 0 - space)
        return self
    }
    
    /**
     * 说明:设置基线边距
     * @param space: 底部偏移
     * @param toView: 基线相对视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_BaseLine(_ space: CGFloat, toView: UIView!) -> UIView {
        var toAttribute = NSLayoutAttribute.top
        self.constraintWithItem(self, attribute: .lastBaseline, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: 0 - space)
        return self
    }
    
    /**
     * 说明:设置基线边距相等
     * @param view: 相等参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_BaseLineEqual(_ view: UIView!) -> UIView {
        return self.comit_BaseLineEqual(view, offset: 0)
    }
    
    /**
     * 说明:设置基线边距相等
     * @param view: 相等参考视图
     * @param offset: 偏移量
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_BaseLineEqual(_ view: UIView!, offset: CGFloat) -> UIView {
        self.constraintWithItem(view, attribute: .lastBaseline, constant: 0.0 - offset)
        return self
    }
    
    /**
     * 说明:设置中心偏移(默认相对父视图)x,y = 0 与父视图中心重合
     * @param x,y: 中心偏移量
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Center(_ x: CGFloat, y: CGFloat) -> UIView {
        return self.comit_CenterX(x).comit_CenterY(y)
    }
    
    /**
     * 说明:设置中心偏移(默认相对父视图)x,y = 0 与父视图中心重合
     * @param x,y: 中心偏移量
     * @param toView: 相对参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Center(_ x: CGFloat, y: CGFloat, toView: UIView!) -> UIView {
        return self.comit_CenterX(x, toView: toView).comit_CenterY(y, toView: toView)
    }
    
    /**
     * 说明:设置中心相等
     * @param view 相等参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_CenterEqual(_ view: UIView!) -> UIView {
        return self.comit_CenterXEqual(view).comit_CenterYEqual(view)
    }
    
    /**
     * 说明:设置中心相等
     * @param view 相等参考视图
     * @param offsetx 中心x偏移量
     * @param offsety 中心y偏移量
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_CenterEqual(_ view: UIView!, offsetX: CGFloat, offsetY: CGFloat) -> UIView {
        return self.comit_CenterXEqual(view, offset: offsetX).comit_CenterYEqual(view, offset: offsetY)
    }
    
    /**
     * 说明:设置frame(默认相对父视图)
     * @param left 左边距
     * @param top 顶边距
     * @param width 宽度
     * @param height 高度
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Frame(_ left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat) -> UIView {
        return self.comit_Left(left).comit_Top(top).comit_Width(width).comit_Height(height)
    }
    
    /**
     * 说明:设置frame
     * @param left 左边距
     * @param top 顶边距
     * @param width 宽度
     * @param height 高度
     * @param toView frame参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Frame(_ left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat, toView: UIView!) -> UIView {
        return self.comit_Left(left, toView: toView).comit_Top(top, toView: toView).comit_Width(width).comit_Height(height)
    }
    
    /**
     * 说明: 设置size
     * @param width 宽度
     * @param height 高度
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_Size(_ width: CGFloat, height: CGFloat) -> UIView {
        return self.comit_Width(width).comit_Height(height)
    }
    
    /**
     * 说明: 设置size相等
     * @param view size相等参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_SizeEqual(_ view: UIView!) -> UIView {
        self.comit_WidthEqual(view).comit_HeightEqual(view)
        return self
    }
    
    /**
     * 说明:设置frame (默认相对父视图)
     * @param left 左边距
     * @param top 顶边距
     * @param right 右边距
     * @param bottom 底边距
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_AutoSize(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) -> UIView {
        return self.comit_Left(left).comit_Top(top).comit_Right(right).comit_Bottom(bottom)
    }
    
    /**
     * 说明:设置frame
     * @param left 左边距
     * @param top 顶边距
     * @param right 右边距
     * @param bottom 底边距
     * @param toView frame参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_AutoSize(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat, toView: UIView!) -> UIView {
        return self.comit_Left(left, toView: toView).comit_Top(top, toView: toView).comit_Right(right, toView: toView).comit_Bottom(bottom, toView: toView)
    }
    
    /**
     * 说明:设置frame (默认相对父视图)
     * @param left 左边距
     * @param top 顶边距
     * @param right 右边距
     * @param height 高度
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_AutoWidth(left: CGFloat, top: CGFloat, right: CGFloat, height: CGFloat) -> UIView {
        return self.comit_Left(left).comit_Top(top).comit_Right(right).comit_Height(height)
    }
    
    /**
     * 说明:设置frame
     * @param left 左边距
     * @param top 顶边距
     * @param right 右边距
     * @param height 高度
     * @param toView frame参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_AutoWidth(left: CGFloat, top: CGFloat, right: CGFloat, height: CGFloat, toView: UIView!) -> UIView {
        return self.comit_Left(left, toView: toView).comit_Top(top, toView: toView).comit_Right(right, toView: toView).comit_Height(height)
    }
    
    /**
     * 说明:设置frame (默认相对父视图)
     * @param left 左边距
     * @param top 顶边距
     * @param width 宽度
     * @param bottom 底边距
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_AutoHeight(left: CGFloat, top: CGFloat, width: CGFloat, bottom: CGFloat) -> UIView {
        return self.comit_Left(left).comit_Top(top).comit_Width(width).comit_Bottom(bottom)
    }
    
    /**
     * 说明:设置frame (默认相对父视图)
     * @param left 左边距
     * @param top 顶边距
     * @param width 宽度
     * @param bottom 底边距
     * @param toView frame参考视图
     * @return 返回当前视图
     */
    @discardableResult
    public func comit_AutoHeight(left: CGFloat, top: CGFloat, width: CGFloat, bottom: CGFloat, toView: UIView!) -> UIView {
        return self.comit_Left(left, toView: toView).comit_Top(top, toView: toView).comit_Width(width).comit_Bottom(bottom, toView: toView)
    }
    
    //MARK: -私有方法-
    
    fileprivate func handleXibConstraint(_ attribute:NSLayoutAttribute) {
        let constraintArray = self.superview?.constraints
        if constraintArray != nil {
            for constraint in constraintArray! {
                if NSStringFromClass(constraint.classForCoder) == "NSIBPrototypingLayoutConstraint" &&
                    constraint.firstAttribute == attribute &&
                    constraint.firstItem === self &&
                    constraint.secondItem == nil {
                    self.superview?.removeConstraint(constraint)
                    return
                }
            }
        }
    }
    
    @objc fileprivate func comit_AddConstraint(_ constraint: NSLayoutConstraint) {
        let constraintClassString = NSStringFromClass(constraint.classForCoder)
        if constraintClassString.hasPrefix("NS") {
            switch constraint.firstAttribute {
            case .height:
                if constraintClassString == "NSContentSizeLayoutConstraint" {
                    for selfConstraint in self.constraints {
                        if selfConstraint.firstAttribute == .height &&
                            selfConstraint.relation == constraint.relation &&
                            NSStringFromClass(selfConstraint.classForCoder) == "NSContentSizeLayoutConstraint" {
                            return
                        }
                    }
                    self.comit_AddConstraint(constraint)
                    return
                }else {
                    /*handleXibConstraint(NSLayoutAttribute.height)*/
                    switch constraint.relation {
                    case .equal:
                        if constraint.secondItem == nil {
                            self.setSelfHeightConstraint(constraint)
                        }else {
                            (constraint.firstItem as! UIView).setEquelHeightConstraint(constraint)
                        }
                    case .greaterThanOrEqual:
                        self.setAutoHeightConstraint(constraint)
                    default:
                        break
                    }
                }
            case .width:
                if NSStringFromClass(constraint.classForCoder) == "NSContentSizeLayoutConstraint" {
                    for selfConstraint in self.constraints {
                        if selfConstraint.firstAttribute == .width &&
                            selfConstraint.relation == constraint.relation &&
                            NSStringFromClass(selfConstraint.classForCoder) == "NSContentSizeLayoutConstraint" {
                            return
                        }
                    }
                    self.comit_AddConstraint(constraint)
                    return
                }else {
                    /*handleXibConstraint(NSLayoutAttribute.width)*/
                    switch constraint.relation {
                    case .equal:
                        if constraint.secondItem == nil {
                            self.setSelfWidthConstraint(constraint)
                        }else {
                            (constraint.firstItem as! UIView).setEquelWidthConstraint(constraint)
                        }
                    case .greaterThanOrEqual:
                        self.setAutoWidthConstraint(constraint)
                    default:
                        break
                    }
                }
            case .right:
                (constraint.firstItem as! UIView).setRightConstraint(constraint)
            case .bottom:
                (constraint.firstItem as! UIView).setBottomConstraint(constraint)
            default:
                break
            }
        }
        self.comit_AddConstraint(constraint)
    }
    
    fileprivate func setRightConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &comit_AssociatedObjectKey.kRightConstraint, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func rightConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &comit_AssociatedObjectKey.kRightConstraint) as? NSLayoutConstraint
    }
    
    fileprivate func setBottomConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &comit_AssociatedObjectKey.kBottomConstraint, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func bottomConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &comit_AssociatedObjectKey.kBottomConstraint) as? NSLayoutConstraint
    }
    
    fileprivate func setEquelWidthConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &comit_AssociatedObjectKey.kEquelWidthConstraint, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func equelWidthConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &comit_AssociatedObjectKey.kEquelWidthConstraint) as? NSLayoutConstraint
    }
    
    fileprivate func setAutoWidthConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &comit_AssociatedObjectKey.kAutoWidthConstraint, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func autoWidthConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &comit_AssociatedObjectKey.kAutoWidthConstraint) as? NSLayoutConstraint
    }
    
    fileprivate func setSelfWidthConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &comit_AssociatedObjectKey.kSelfWidthConstraint, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func selfWidthConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &comit_AssociatedObjectKey.kSelfWidthConstraint) as? NSLayoutConstraint
    }
    
    fileprivate func setEquelHeightConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &comit_AssociatedObjectKey.kEquelHeightConstraint, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func equelHeightConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &comit_AssociatedObjectKey.kEquelHeightConstraint) as? NSLayoutConstraint
    }
    
    fileprivate func setAutoHeightConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &comit_AssociatedObjectKey.kAutoHeightConstraint, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func autoHeightConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &comit_AssociatedObjectKey.kAutoHeightConstraint) as? NSLayoutConstraint
    }
    
    fileprivate func setSelfHeightConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &comit_AssociatedObjectKey.kSelfHeightConstraint, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func selfHeightConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &comit_AssociatedObjectKey.kSelfHeightConstraint) as? NSLayoutConstraint
    }
    
    fileprivate func setKeepWidthConstraint(_ isKeep: Bool) {
        objc_setAssociatedObject(self, &comit_AssociatedObjectKey.kKeepWidthConstraint, NSNumber(value: isKeep as Bool), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func keepWidthConstraint() -> Bool {
        let value = objc_getAssociatedObject(self, &comit_AssociatedObjectKey.kKeepWidthConstraint) as? NSNumber
        return value != nil ? value!.boolValue : false
    }
    
    fileprivate func setKeepHeightConstraint(_ isKeep: Bool) {
        objc_setAssociatedObject(self, &comit_AssociatedObjectKey.kKeepHeightConstraint, NSNumber(value: isKeep as Bool), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func keepHeightConstraint() -> Bool {
        let value = objc_getAssociatedObject(self, &comit_AssociatedObjectKey.kKeepHeightConstraint) as? NSNumber
        return value != nil ? value!.boolValue : false
    }
    
    fileprivate func setKeepBottomConstraint(_ isKeep: Bool) {
        objc_setAssociatedObject(self, &comit_AssociatedObjectKey.kKeepBottomConstraint, NSNumber(value: isKeep as Bool), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func keepBottomConstraint() -> Bool {
        let value = objc_getAssociatedObject(self, &comit_AssociatedObjectKey.kKeepBottomConstraint) as? NSNumber
        return value != nil ? value!.boolValue : false
    }
    
    fileprivate func setKeepRightConstraint(_ isKeep: Bool) {
        objc_setAssociatedObject(self, &comit_AssociatedObjectKey.kKeepRightConstraint, NSNumber(value: isKeep as Bool), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func keepRightConstraint() -> Bool {
        let value = objc_getAssociatedObject(self, &comit_AssociatedObjectKey.kKeepRightConstraint) as? NSNumber
        return value != nil ? value!.boolValue : false
    }
    
    fileprivate func constraintWithItem(_ item: UIView!,
                                        attribute: NSLayoutAttribute,
                                        constant: CGFloat) {
        var toAttribute = attribute
        self.constraintWithItem(self,
                                attribute: attribute,
                                toItem: item,
                                toAttribute: &toAttribute,
                                constant: constant)
    }
    
    fileprivate func constraintWithItem(_ item: UIView!,
                                        attribute: NSLayoutAttribute,
                                        multiplier: CGFloat,
                                        constant: CGFloat) {
        var toAttribute = attribute
        self.constraintWithItem(self,
                                attribute: attribute,
                                toItem: item,
                                toAttribute: &toAttribute ,
                                multiplier: multiplier,
                                constant: constant)
    }
    
    fileprivate func constraintWithItem(_ item: UIView!,
                                        attribute: NSLayoutAttribute,
                                        toItem: UIView!,
                                        toAttribute: inout NSLayoutAttribute,
                                        constant: CGFloat) {
        self.constraintWithItem(item,
                                attribute: attribute,
                                toItem: toItem,
                                toAttribute: &toAttribute,
                                multiplier: 1,
                                constant: constant)
    }
    
    fileprivate func constraintWithItem(_ item: UIView!,
                                        attribute: NSLayoutAttribute,
                                        toItem: UIView!,
                                        toAttribute: inout NSLayoutAttribute,
                                        multiplier: CGFloat,
                                        constant: CGFloat) {
        self.constraintWithItem(item,
                                attribute: attribute,
                                related: .equal,
                                toItem: toItem,
                                toAttribute: &toAttribute,
                                multiplier: multiplier,
                                constant: constant)
    }
    
    fileprivate func constraintWithItem(_ item: UIView!,
                                        attribute: NSLayoutAttribute,
                                        related: NSLayoutRelation,
                                        toItem: UIView!,
                                        toAttribute: inout NSLayoutAttribute,
                                        multiplier: CGFloat,
                                        constant: CGFloat) {
        var currentSuperView = item.superview
        if toItem != nil {
            if toItem.superview == nil {
                currentSuperView = toItem
            }else if toItem.superview !== item.superview {
                currentSuperView = toItem
            }
        }else {
            currentSuperView = item
            toAttribute = .notAnAttribute
        }
        if self.translatesAutoresizingMaskIntoConstraints {
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        if ((item?.translatesAutoresizingMaskIntoConstraints) != nil) {
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        let originConstraint = self.getOriginConstraintWithMainView(currentSuperView,
                                                                    view: item,
                                                                    attribute: attribute,
                                                                    related: related,
                                                                    toView: toItem,
                                                                    toAttribute: toAttribute,
                                                                    multiplier: multiplier,
                                                                    constant: constant)
        if originConstraint == nil {
            let constraint = NSLayoutConstraint(item: item,
                                                attribute: attribute,
                                                relatedBy: related,
                                                toItem: toItem,
                                                attribute: toAttribute,
                                                multiplier: multiplier,
                                                constant: constant)
            currentSuperView?.addConstraint(constraint)
            self.currentConstraint = constraint
        }else {
            self.currentConstraint = originConstraint
            if originConstraint?.constant != constant {
                originConstraint?.constant = constant
            }
        }
        
        /// reset keep constraint
        self.setKeepBottomConstraint(false)
        self.setKeepHeightConstraint(false)
        self.setKeepWidthConstraint(false)
        self.setKeepRightConstraint(false)
    }
    
    fileprivate func getOriginConstraintWithMainView(_ mainView: UIView!,
                                                     view: UIView!,
                                                     attribute: NSLayoutAttribute,
                                                     related: NSLayoutRelation,
                                                     toView: UIView!,
                                                     toAttribute: NSLayoutAttribute,
                                                     multiplier: CGFloat,
                                                     constant: CGFloat) -> NSLayoutConstraint! {
        if mainView == nil {
            print("mainView not nil")
            return nil
        }
        var originConstraint: NSLayoutConstraint! = nil
        let constraintArray = mainView.constraints
        for constraint in constraintArray {
            if constraint.firstItem === view {
                switch attribute {
                case .left:
                    if constraint.firstAttribute == .centerX ||
                        constraint.firstAttribute == .leading ||
                        constraint.firstAttribute == .trailing {
                        mainView.removeConstraint(constraint)
                    }
                case .centerX:
                    if constraint.firstAttribute == .left ||
                        constraint.firstAttribute == .leading ||
                        constraint.firstAttribute == .trailing {
                        mainView.removeConstraint(constraint)
                    }
                case .leading:
                    if constraint.firstAttribute == .left ||
                        constraint.firstAttribute == .centerX ||
                        constraint.firstAttribute == .trailing {
                        mainView.removeConstraint(constraint)
                    }
                case .trailing:
                    if constraint.firstAttribute == .left ||
                        constraint.firstAttribute == .centerX ||
                        constraint.firstAttribute == .leading {
                        mainView.removeConstraint(constraint)
                    }
                case .top:
                    if constraint.firstAttribute == .centerY ||
                        constraint.firstAttribute == .lastBaseline {
                        mainView.removeConstraint(constraint)
                    }
                case .centerY:
                    if constraint.firstAttribute == .top ||
                        constraint.firstAttribute == .lastBaseline {
                        mainView.removeConstraint(constraint)
                    }
                case .lastBaseline:
                    if constraint.firstAttribute == .top ||
                        constraint.firstAttribute == .centerY {
                        mainView.removeConstraint(constraint)
                    }
                case .right:
                    if constraint.firstAttribute == .width &&
                        NSStringFromClass(constraint.classForCoder) == "NSIBPrototypingLayoutConstraint" {
                        mainView.removeConstraint(constraint)
                    }
                    if !self.keepWidthConstraint() {
                        let equelWidthConstraint = view.equelWidthConstraint()
                        if equelWidthConstraint != nil {
                            mainView.removeConstraint(equelWidthConstraint!)
                            view.setEquelWidthConstraint(nil)
                        }
                        let selfWidthConstraint = view.selfWidthConstraint()
                        if selfWidthConstraint != nil {
                            view.removeConstraint(selfWidthConstraint!)
                            view.setSelfWidthConstraint(nil)
                        }
                        let autoWidthConstraint = view.autoWidthConstraint()
                        if autoWidthConstraint != nil {
                            view.removeConstraint(autoWidthConstraint!)
                            view.setAutoWidthConstraint(nil)
                        }
                    }
                case .width:
                    if !self.keepRightConstraint() {
                        let rightConstraint = view.rightConstraint()
                        if rightConstraint != nil {
                            view.superview?.removeConstraint(rightConstraint!)
                            view.setRightConstraint(nil)
                        }
                    }
                    if toView == nil {
                        let equelWidthConstraint = view.equelWidthConstraint()
                        if equelWidthConstraint != nil {
                            view.superview?.removeConstraint(equelWidthConstraint!)
                            view.setEquelWidthConstraint(nil)
                        }
                        switch related {
                        case .equal:
                            let autoWidthConstraint = view.autoWidthConstraint()
                            if autoWidthConstraint != nil && NSStringFromClass((autoWidthConstraint?.classForCoder)!) == "NSLayoutConstraint" {
                                view.removeConstraint(autoWidthConstraint!)
                                view.setAutoWidthConstraint(nil)
                            }
                        case .greaterThanOrEqual:
                            let selfWidthConstraint = view.selfWidthConstraint()
                            if selfWidthConstraint != nil && NSStringFromClass((selfWidthConstraint?.classForCoder)!) == "NSLayoutConstraint" {
                                view.removeConstraint(selfWidthConstraint!)
                                view.setSelfWidthConstraint(nil)
                            }
                        default:
                            break
                        }
                    }else {
                        let selfWidthConstraint = view.selfWidthConstraint()
                        if selfWidthConstraint != nil {
                            view.removeConstraint(selfWidthConstraint!)
                            view.setSelfWidthConstraint(nil)
                        }
                    }
                case .bottom:
                    if constraint.firstAttribute == .height &&
                        NSStringFromClass(constraint.classForCoder) == "NSIBPrototypingLayoutConstraint" {
                        mainView.removeConstraint(constraint)
                    }
                    if !self.keepHeightConstraint() {
                        let equelHeightConstraint = view.equelHeightConstraint()
                        if equelHeightConstraint != nil {
                            mainView.removeConstraint(equelHeightConstraint!)
                            view.setEquelHeightConstraint(nil)
                        }
                        let selfHeightConstraint = view.selfHeightConstraint()
                        if selfHeightConstraint != nil {
                            view.removeConstraint(selfHeightConstraint!)
                            view.setSelfHeightConstraint(nil)
                        }
                        let autoHeightConstraint = view.autoHeightConstraint()
                        if autoHeightConstraint != nil {
                            view.removeConstraint(autoHeightConstraint!)
                            view.setAutoHeightConstraint(nil)
                        }
                    }
                case .height:
                    if !self.keepBottomConstraint() {
                        let bottomConstraint = view.bottomConstraint()
                        if bottomConstraint != nil {
                            view.superview?.removeConstraint(bottomConstraint!)
                            view.setBottomConstraint(nil)
                        }
                    }
                    if toView != nil {
                        let selfHeightConstraint = view.selfHeightConstraint()
                        if selfHeightConstraint != nil {
                            view.removeConstraint(selfHeightConstraint!)
                            view.setSelfHeightConstraint(nil)
                        }
                    }else {
                        let equelHeightConstraint = view.equelHeightConstraint()
                        if equelHeightConstraint != nil {
                            view.superview?.removeConstraint(equelHeightConstraint!)
                            view.setEquelHeightConstraint(nil)
                        }
                        switch related {
                        case .equal:
                            let autoHeightConstraint = view.autoHeightConstraint()
                            if autoHeightConstraint != nil && NSStringFromClass((autoHeightConstraint?.classForCoder)!) == "NSLayoutConstraint" {
                                view.removeConstraint(autoHeightConstraint!)
                                view.setAutoHeightConstraint(nil)
                            }
                        case .greaterThanOrEqual:
                            let selfHeightConstraint = view.selfHeightConstraint()
                            if selfHeightConstraint != nil && NSStringFromClass((selfHeightConstraint?.classForCoder)!) == "NSLayoutConstraint" {
                                view.removeConstraint(selfHeightConstraint!)
                                view.setSelfHeightConstraint(nil)
                            }
                        default:
                            break
                        }
                    }
                default:
                    break
                }
                if toView != nil {
                    if constraint.firstAttribute == attribute &&
                        constraint.secondItem === toView &&
                        constraint.secondAttribute == toAttribute {
                        if constraint.multiplier == multiplier {
                            originConstraint = constraint
                        }else {
                            mainView.removeConstraint(constraint)
                        }
                    }else if constraint.firstAttribute == attribute {
                        mainView.removeConstraint(constraint)
                    }
                }else {
                    if constraint.firstAttribute == attribute &&
                        related == constraint.relation {
                        let className = NSStringFromClass(constraint.classForCoder)
                        switch related {
                        case .equal:
                            if className == "NSLayoutConstraint" {
                                originConstraint = constraint
                            }
                        case .greaterThanOrEqual:
                            originConstraint = constraint
                        default:
                            break
                        }
                    }
                }
            }
        }
        return originConstraint
    }
    
    class comit_Line: UIView {
        
    }
    
    struct comit_Tag {
        static let kLeftLine = 100000
        static let kRightLine = kLeftLine + 1
        static let kTopLine = kRightLine + 1
        static let kBottomLine = kTopLine + 1
    }
    
    fileprivate func createLineWithTag(_ lineTag: Int)  -> comit_Line! {
        var line: comit_Line!
        for view in self.subviews {
            if view is comit_Line && view.tag == lineTag {
                line = view as! comit_Line
                break
            }
        }
        if line == nil {
            line = comit_Line()
            line.tag = lineTag
            self.addSubview(line)
        }
        return line
    }
    
    //MARK: -自动添加底部线和顶部线-
    @discardableResult
    public func comit_AddBottomLine(_ height: CGFloat, color: UIColor) -> UIView {
        return self.comit_AddBottomLine(height, color: color, marge: 0)
    }
    
    @discardableResult
    public func comit_AddBottomLine(_ height: CGFloat, color: UIColor, marge: CGFloat) -> UIView {
        let line = self.createLineWithTag(comit_Tag.kBottomLine)
        line?.backgroundColor = color
        return line!.comit_Right(marge).comit_Left(marge).comit_Height(height).comit_BaseLine(0)
    }
    
    @discardableResult
    public func comit_AddTopLine(_ height: CGFloat, color: UIColor) -> UIView {
        return self.comit_AddTopLine(height, color: color, marge: 0)
    }
    
    @discardableResult
    public func comit_AddTopLine(_ height: CGFloat, color: UIColor, marge: CGFloat) -> UIView {
        let line = self.createLineWithTag(comit_Tag.kTopLine)
        line?.backgroundColor = color
        return line!.comit_Right(marge).comit_Left(marge).comit_Height(height).comit_Top(0)
    }
    
}

