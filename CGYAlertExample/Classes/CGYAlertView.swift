//
//  CGYAlertView.swift
//  CGYAlertExample
//
//  Created by Chakery on 16/8/17.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

private let minWidth: CGFloat = 270
private let minHeight: CGFloat = 130

public class CGYAlertView: UIView {
    private var hLine: CALayer! //横线
    private var titleLabel: UILabel? //标题
    private var messageLabel: UILabel? //消息
    private var buttons: [CGYButton] = [] //按钮
    private var actions: [CGYAlertAction] = [] //事件
    private var buttonBlock: CGYAlertViewBlock? //按钮回调
    
    public init(title: String?, message: String?, actions: [CGYAlertAction]) {
        self.actions = actions
        super.init(frame: CGRect(x: 0, y: 0, width: minWidth, height: minHeight))
        initView()
        setupView(title, message: message, actions: actions)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func buttonDidSelectedCallBack(callBack: CGYAlertViewBlock) {
        buttonBlock = callBack
    }
    
    private func initView() {
        backgroundColor = cgy_whiteColor
        layer.backgroundColor = cgy_whiteColor.CGColor
        layer.cornerRadius = cgy_cornerRadius
        layer.masksToBounds = true
    }
    
    private func setupView(title: String?, message: String?, actions: [CGYAlertAction]) {
        if let title = title {
            titleLabel = UILabel()
            titleLabel!.text = title
            titleLabel!.textColor = UIColor(white: 0, alpha: 1)
            titleLabel!.font = UIFont.boldSystemFontOfSize(15)
            titleLabel!.textAlignment = .Center
            titleLabel!.translatesAutoresizingMaskIntoConstraints = false
            addSubview(titleLabel!)
            let hLayout = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[titleLabel(>=0)]-|", options: [], metrics: nil, views: ["titleLabel":titleLabel!])
            let vLayout = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[titleLabel(16)]", options: [], metrics: nil, views: ["titleLabel":titleLabel!])
            addConstraints(hLayout)
            addConstraints(vLayout)
        }
        
        if let message = message {
            messageLabel = UILabel()
            messageLabel!.text = message
            messageLabel!.textColor = UIColor(white: 0, alpha: 1)
            messageLabel!.font = UIFont.systemFontOfSize(12)
            messageLabel!.textAlignment = .Center
            messageLabel!.numberOfLines = 0
            messageLabel!.translatesAutoresizingMaskIntoConstraints = false
            addSubview(messageLabel!)
            var vStr = "" //垂直方向的VLF
            var parms: [String:AnyObject] = [:] //约束的参数
            if let titleLabel = titleLabel {
                vStr = "V:[titleLabel]-10-[messageLabel(>=16)]"
                parms = ["titleLabel":titleLabel, "messageLabel":messageLabel!]
            } else {
                vStr = "V:|-20-[messageLabel(>=16)]"
                parms = ["messageLabel":messageLabel!]
            }
            let hLayout = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[messageLabel]-10-|", options: [], metrics: nil, views: ["messageLabel":messageLabel!])
            let vLayout = NSLayoutConstraint.constraintsWithVisualFormat(vStr, options: [], metrics: nil, views: parms)
            addConstraints(hLayout)
            addConstraints(vLayout)
        }
        
        if actions.count > 0 {
            if hLine == nil {
                hLine = CALayer()
                hLine.backgroundColor = UIColor(white: 0, alpha: 0.2).CGColor
                layer.addSublayer(hLine)
            }
            
            buttons.removeAll()
            (0..<actions.count).forEach { [weak self] i in
                guard let `self` = self else { return }
                let action = actions[i]
                let btn = CGYButton()
                btn.tag = i
                btn.backgroundColor = UIColor.clearColor()
                if action.style == .Cancel {
                    btn.titleLabel?.font = cgy_cancelBtnFont
                } else {
                    btn.titleLabel?.font = cgy_defaultBtnFont
                }
                btn.setTitle(action.title, forState: .Normal)
                btn.setTitleColor(cgy_btnTitleColor, forState: .Normal)
                btn.addTarget(self, action: #selector(CGYAlertView.buttonEvent(_:)), forControlEvents: .TouchUpInside)
                btn.translatesAutoresizingMaskIntoConstraints = false
                if i < actions.count - 1 {
                    btn.showRightOrder()
                }
                self.addSubview(btn)
                self.buttons.append(btn)
                var toItem: AnyObject? = nil
                var toItemAttribute: NSLayoutAttribute = .Left
                if i <= 0 {
                    toItem = self
                    toItemAttribute = .Left
                } else {
                    toItem = self.buttons[i-1]
                    toItemAttribute = .Right
                }
                let xLayout = NSLayoutConstraint(item: btn, attribute: .Left, relatedBy: .Equal, toItem: toItem, attribute: toItemAttribute, multiplier: 1.0, constant: 0.0)
                let bLayout = NSLayoutConstraint(item: btn, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
                let wLayout = NSLayoutConstraint(item: btn, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0/CGFloat(actions.count), constant: 0.0)
                let hLayout = NSLayoutConstraint(item: btn, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 44)
                self.addConstraint(xLayout)
                self.addConstraint(bLayout)
                self.addConstraint(wLayout)
                self.addConstraint(hLayout)
            }
        }
    }
    
    @objc func buttonEvent(btn: CGYButton) {
        let action = actions[btn.tag]
        buttonBlock?(action, btn.tag)
        action.handler?(action)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let w = bounds.width
        let h = bounds.height
        
        hLine?.frame = CGRect(x: 0, y: h-44, width: w, height: 0.5)
    }
    
}