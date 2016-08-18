//
//  CGYSheetView.swift
//  CGYAlertExample
//
//  Created by Chakery on 16/8/17.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

public class CGYSheetView: UIView {
    private let defaultTag = 100
    private let cancelTag = 200
    
    private var titleLabel: UILabel?
    private var messageLabel: UILabel?
    
    private var defaultView: UIView?
    private var cancelView: UIView?
    
    private var defaultButtons: [CGYButton] = []
    private var cancelButtons: [CGYButton] = []
    
    private var defaultActions: [CGYAlertAction] = []
    private var cancelActions: [CGYAlertAction] = []
    
    private var actions: [CGYAlertAction] = []
    private var buttonBlock: CGYAlertViewBlock? //按钮回调
    
    
    
    
    public init(title: String?, message: String?, actions: [CGYAlertAction]) {
        self.actions = actions
        super.init(frame: CGRectZero)
        initData(actions)
        setupView(title: title, message: message)
        backgroundColor = UIColor.clearColor()
        layer.backgroundColor = UIColor.clearColor().CGColor
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func buttonDidSelectedCallBack(callBack: CGYAlertViewBlock) {
        buttonBlock = callBack
    }
    
    private func initData(actions: [CGYAlertAction]) {
        actions.forEach { [weak self] action in
            guard let `self` = self else { return }
            if action.style == .Cancel {
                self.cancelActions.append(action)
            } else {
                self.defaultActions.append(action)
            }
        }
    }
    
    private func setupView(title title: String?, message: String?) {
        if cancelActions.count > 0 {
            cancelView = UIView()
            cancelView?.backgroundColor = cgy_whiteColor
            cancelView?.layer.backgroundColor = cgy_whiteColor.CGColor
            cancelView?.layer.cornerRadius = cgy_cornerRadius
            cancelView?.translatesAutoresizingMaskIntoConstraints = false
            cancelView?.layer.masksToBounds = true
            addSubview(cancelView!)
            let hLayout = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[cancelView]-10-|", options: [], metrics: nil, views: ["cancelView":cancelView!])
            let vLayout = NSLayoutConstraint.constraintsWithVisualFormat("V:[cancelView(>=0)]-10-|", options: [], metrics: nil, views: ["cancelView":cancelView!])
            addConstraints(hLayout)
            addConstraints(vLayout)
        }
        
        defaultView = UIView()
        defaultView?.backgroundColor = cgy_whiteColor
        defaultView?.layer.backgroundColor = cgy_whiteColor.CGColor
        defaultView?.layer.cornerRadius = cgy_cornerRadius
        defaultView?.translatesAutoresizingMaskIntoConstraints = false
        defaultView?.layer.masksToBounds = true
        addSubview(defaultView!)
        var vStr = ""
        var vParams: [String:AnyObject] = [:]
        
        if let cancelView = cancelView {
            vStr = "V:[defaultView(>=0)]-10-[cancelView]"
            vParams = ["cancelView":cancelView, "defaultView":defaultView!]
        } else {
            vStr = "V:[defaultView(>=0)]-10-|"
            vParams = ["defaultView":defaultView!]
        }

        let hLayout = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[defaultView]-10-|", options: [], metrics: nil, views: ["defaultView":defaultView!])
        let vLayout = NSLayoutConstraint.constraintsWithVisualFormat(vStr, options: [], metrics: nil, views: vParams)
        addConstraints(hLayout)
        addConstraints(vLayout)
        
        if let title = title {
            var vEndLayout = ""
            if message == nil && defaultActions.count == 0 {
                vEndLayout = "-10-|"
            }
            
            titleLabel = UILabel()
            titleLabel?.text = title
            titleLabel?.textAlignment = .Center
            titleLabel?.textColor = UIColor(white: 0, alpha: 0.3)
            titleLabel?.font = UIFont.systemFontOfSize(13)
            titleLabel?.translatesAutoresizingMaskIntoConstraints = false
            defaultView?.addSubview(titleLabel!)
            let hLayout = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[titleLabel]-|", options: [], metrics: nil, views: ["titleLabel":titleLabel!])
            let vLayout = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[titleLabel(==16)]" + vEndLayout, options: [], metrics: nil, views: ["titleLabel":titleLabel!])
            addConstraints(hLayout)
            addConstraints(vLayout)
        }
        
        if let message = message {
            var vEndLayout = ""
            if defaultActions.count == 0 {
                vEndLayout = "-10-|"
            }
            messageLabel = UILabel()
            messageLabel?.text = message
            messageLabel?.textAlignment = .Center
            messageLabel?.numberOfLines = 0
            messageLabel?.textColor = UIColor(white: 0, alpha: 0.3)
            messageLabel?.font = UIFont.systemFontOfSize(12)
            messageLabel?.translatesAutoresizingMaskIntoConstraints = false
            defaultView?.addSubview(messageLabel!)
            var vStr = ""
            var vParams: [String:AnyObject] = [:]
            
            if let titleLabel = titleLabel {
                vStr = "V:[titleLabel]-0-[messageLabel(==16)]"
                vParams = ["titleLabel":titleLabel, "messageLabel":messageLabel!]
            } else {
                vStr = "V:|-10-[messageLabel(==16)]"
                vParams = ["messageLabel":messageLabel!]
                
            }
            
            let hLayout = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[messageLabel]-10-|", options: [], metrics: nil, views: ["messageLabel":messageLabel!])
            let vLayout = NSLayoutConstraint.constraintsWithVisualFormat(vStr + vEndLayout, options: [], metrics: nil, views: vParams)
            addConstraints(hLayout)
            addConstraints(vLayout)
        }
        
        let defaultCount = defaultActions.count
        (0..<defaultCount).forEach { [weak self] i in
            guard let `self` = self else { return }
            let action = self.defaultActions[i]
            let btn = CGYButton()
            btn.tag = i + self.defaultTag
            btn.backgroundColor = UIColor.clearColor()
            btn.titleLabel?.font = cgy_defaultBtnFont
            btn.setTitle(action.title, forState: .Normal)
            btn.setTitleColor(cgy_btnTitleColor, forState: .Normal)
            btn.addTarget(self, action: #selector(CGYSheetView.defaultButtonEvent(_:)), forControlEvents: .TouchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
            self.defaultView?.addSubview(btn)
            self.defaultButtons.append(btn)
            
            var topConstant: CGFloat = 0
            var toItem: AnyObject? = nil
            var toItemAttribute: NSLayoutAttribute = .Top
            if i == 0 {
                if let messageLabel = self.messageLabel {
                    btn.showTopOrder()
                    topConstant = 10
                    toItem = messageLabel
                    toItemAttribute = .Bottom
                } else if let titleLabel = self.titleLabel {
                    topConstant = 10
                    btn.showTopOrder()
                    toItem = titleLabel
                    toItemAttribute = .Bottom
                } else {
                    topConstant = 0
                    toItem = self.defaultView!
                    toItemAttribute = .Top
                }
            } else {
                topConstant = 0
                btn.showTopOrder()
                toItem = self.defaultButtons[i-1]
                toItemAttribute = .Bottom
            }
            if i == defaultCount-1 {
                let bLayout = NSLayoutConstraint(item: btn, attribute: .Bottom, relatedBy: .Equal, toItem: self.defaultView!, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
                self.defaultView?.addConstraint(bLayout)
            }
            let lLayout = NSLayoutConstraint(item: btn, attribute: .Left, relatedBy: .Equal, toItem: self.defaultView!, attribute: .Left, multiplier: 1.0, constant: 0.0)
            let rLayout = NSLayoutConstraint(item: btn, attribute: .Right, relatedBy: .Equal, toItem: self.defaultView!, attribute: .Right, multiplier: 1.0, constant: 0.0)
            let hLayout = NSLayoutConstraint(item: btn, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 44)
            let tLayout = NSLayoutConstraint(item: btn, attribute: .Top, relatedBy: .Equal, toItem: toItem, attribute: toItemAttribute, multiplier: 1.0, constant: topConstant)
            self.defaultView?.addConstraint(lLayout)
            self.defaultView?.addConstraint(rLayout)
            self.defaultView?.addConstraint(tLayout)
            self.defaultView?.addConstraint(hLayout)
        }
        
        
        let cancelCount = cancelActions.count
        (0..<cancelCount).forEach { [weak self] i in
            guard let `self` = self else { return }
            let action = self.cancelActions[i]
            let btn = CGYButton()
            btn.tag = i + self.cancelTag
            btn.backgroundColor = UIColor.clearColor()
            btn.titleLabel?.font = cgy_cancelBtnFont
            btn.setTitle(action.title, forState: .Normal)
            btn.setTitleColor(cgy_btnTitleColor, forState: .Normal)
            btn.addTarget(self, action: #selector(CGYSheetView.cancelButtonEvent(_:)), forControlEvents: .TouchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
            self.cancelView?.addSubview(btn)
            self.cancelButtons.append(btn)
            
            
            var topItem: AnyObject? = nil
            var topAttribute: NSLayoutAttribute = .Top
            if i == 0 {
                topItem = self.cancelView
                topAttribute = .Top
            } else {
                btn.showTopOrder()
                topItem = self.cancelButtons[i-1]
                topAttribute = .Bottom
            }
            if i == cancelCount-1 {
                let bLayout = NSLayoutConstraint(item: btn, attribute: .Bottom, relatedBy: .Equal, toItem: self.cancelView!, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
                self.cancelView?.addConstraint(bLayout)
            }
            let tLayout = NSLayoutConstraint(item: btn, attribute: .Top, relatedBy: .Equal, toItem: topItem, attribute: topAttribute, multiplier: 1.0, constant: 0.0)
            let lLayout = NSLayoutConstraint(item: btn, attribute: .Left, relatedBy: .Equal, toItem: self.cancelView!, attribute: .Left, multiplier: 1.0, constant: 0.0)
            let rLayout = NSLayoutConstraint(item: btn, attribute: .Right, relatedBy: .Equal, toItem: self.cancelView!, attribute: .Right, multiplier: 1.0, constant: 0.0)
            let hLayout = NSLayoutConstraint(item: btn, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 44)
            self.cancelView?.addConstraint(tLayout)
            self.cancelView?.addConstraint(lLayout)
            self.cancelView?.addConstraint(rLayout)
            self.cancelView?.addConstraint(hLayout)
        }
    }
    
    
    @objc func defaultButtonEvent(btn: UIButton) {
        let index = btn.tag % defaultTag
        if index < 0 || index > defaultActions.count { return }
        let action = defaultActions[index]
        buttonBlock?(action, index)
        action.handler?(action)
    }
    
    @objc func cancelButtonEvent(btn: UIButton) {
        let index = btn.tag % cancelTag
        if index < 0 || index > cancelActions.count { return }
        let action = cancelActions[index]
        buttonBlock?(action, index)
        action.handler?(action)
    }
}








