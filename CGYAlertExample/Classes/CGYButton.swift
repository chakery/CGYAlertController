//
//  CGYButton.swift
//  CGYAlertExample
//
//  Created by Chakery on 16/8/17.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

/// 按钮
public class CGYButton: UIButton {
    private var topOrder: CALayer?
    private var rightOrder: CALayer?
    private var bottomOrder: CALayer?
    private let OrderColor = UIColor(white: 0, alpha: 0.2).CGColor
    
    public init() {
        super.init(frame: CGRectZero)
        cgy_didSelectedBackgroundColor()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 顶部框
    public func showTopOrder() {
        guard topOrder == nil else { return }
        topOrder = CALayer()
        topOrder?.backgroundColor = OrderColor
        layer.addSublayer(topOrder!)
    }
    
    /// 右边框
    public func showRightOrder() {
        guard rightOrder == nil else { return }
        rightOrder = CALayer()
        rightOrder?.backgroundColor = OrderColor
        layer.addSublayer(rightOrder!)
    }
    
    /// 底部框
    public func showBottomOrder() {
        guard bottomOrder == nil else { return }
        bottomOrder = CALayer()
        bottomOrder?.backgroundColor = OrderColor
        layer.addSublayer(bottomOrder!)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let w = bounds.width
        let h = bounds.height
        topOrder?.frame = CGRect(x: 0, y: 0, width: w, height: 0.5)
        rightOrder?.frame = CGRect(x: w-0.5, y: 0, width: 0.5, height: h)
        bottomOrder?.frame = CGRect(x: 0, y: h-0.5, width: w, height: 0.5)
    }
}


private var NormalColorKey: Void?
private var HighlightedColorKey: Void?
public extension UIButton {
    
    private var normalColor: UIColor? {
        get{
            return objc_getAssociatedObject(self, &NormalColorKey) as? UIColor
        }
        set{
            objc_setAssociatedObject(self, &NormalColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var highlightedColor: UIColor? {
        get{
            return objc_getAssociatedObject(self, &HighlightedColorKey) as? UIColor
        }
        set{
            objc_setAssociatedObject(self, &HighlightedColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func cgy_didSelectedBackgroundColor(color: UIColor? = UIColor(white: 0, alpha: 0.2)) {
        normalColor = backgroundColor
        highlightedColor = color
        
        addTarget(self, action:#selector(UIButton.colorWithNormal(_:)), forControlEvents:.TouchUpInside)
        addTarget(self, action:#selector(UIButton.colorWithNormal(_:)), forControlEvents:.TouchUpOutside)
        addTarget(self, action:#selector(UIButton.colorWithHighlighted(_:)), forControlEvents:.TouchDown)
        addTarget(self, action:#selector(UIButton.colorWithNormal(_:)), forControlEvents:.TouchCancel)
    }
    
    @objc private func colorWithNormal(btn: UIButton) {
        self.backgroundColor = normalColor
    }
    
    @objc private func colorWithHighlighted(btn: UIButton) {
        self.backgroundColor = highlightedColor
    }
}






