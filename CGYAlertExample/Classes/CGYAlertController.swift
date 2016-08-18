//
//  CGYAlertController.swift
//  CGYAlertExample
//
//  Created by Chakery on 16/8/17.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

public enum CGYAlertStyle {
    case ActionSheet
    case Alert
}

public enum CGYAlertActionStyle {
    case Default
    case Cancel
}

public struct CGYAlertAction {
    public private(set) var title: String
    public private(set) var style: CGYAlertActionStyle
    public private(set) var handler: (CGYAlertAction -> Void)?
    
    public init(title: String, style: CGYAlertActionStyle, handing: (CGYAlertAction -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handing
    }
}

public class CGYAlertController: UIViewController {
    private var actions: [CGYAlertAction] = []
    private var alertTitle: String?
    private var alertMessage: String?
    private var alertType: CGYAlertStyle
    private var rootVC: UIViewController?
    
    private var alertView: CGYAlertView?
    private var sheetView: CGYSheetView?
    
    
    public override func viewWillAppear(animated: Bool) {
        animationHanlder(show: true)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public init(title: String?, message: String?, preferredStyle: CGYAlertStyle, actions: CGYAlertAction...) {
        self.alertTitle = title
        self.alertMessage = message
        self.alertType = preferredStyle
        self.actions = actions
        super.init(nibName: nil, bundle: nil)
        self.rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        self.view.backgroundColor = UIColor.clearColor()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if DEBUG
        print("CGYAlertController deinit")
        #endif
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let sheetView = sheetView else { return }
        if case .ActionSheet = alertType {
            guard let events = event?.touchesForView(sheetView) where events.count > 0 else { return }
            actionSheetAnimation(show: false) { [weak self] _ in
                guard let `self` = self else { return }
                self.dismiss()
            }
        }
    }
    
    public func addAction(action: CGYAlertAction) {
        actions.append(action)
    }
    
    public func show() {
        initViewBeforeShow()
        self.modalPresentationStyle = .OverCurrentContext
        dispatch_async(dispatch_get_main_queue()) {
            self.rootVC?.presentViewController(self, animated: false, completion: nil)
        }
    }
    
    private func dismiss() {
        self.alertView?.removeFromSuperview()
        self.sheetView?.removeFromSuperview()
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    private func initViewBeforeShow() {
        if alertType == .Alert {
            alertView = CGYAlertView(title: alertTitle, message: alertMessage, actions: actions)
            alertView!.center = view.center
            alertView!.buttonDidSelectedCallBack { [weak self] action, index in
                guard let `self` = self else { return }
                self.backgroundAnimation(show: false) { _ in
                    self.dismiss()
                }
            }
            view.addSubview(alertView!)
        } else {
            sheetView = CGYSheetView(title: alertTitle, message: alertMessage, actions: actions)
            sheetView!.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height)
            sheetView!.buttonDidSelectedCallBack { [weak self] _, _ in
                guard let `self` = self else { return }
                self.actionSheetAnimation(show: false) { _ in
                    self.dismiss()
                }
            }
            view.addSubview(sheetView!)
        }
    }
    
    private func animationHanlder(show show: Bool, callBack: (Bool -> Void)? = nil) {
        if alertType == .Alert {
            backgroundAnimation(show: show, callBack: callBack)
        } else {
            actionSheetAnimation(show: show, callBack: callBack)
        }
    }
    
    private func backgroundAnimation(duration: NSTimeInterval = 0.1, show: Bool, callBack: (Bool -> Void)? = nil) {
        UIView.animateWithDuration(duration, animations: {
            self.view.backgroundColor = UIColor(white: 0.0, alpha: show ? 0.3 : 0.0)
        }, completion: callBack)
    }

    private func actionSheetAnimation(duration: NSTimeInterval = 0.3, show: Bool, callBack: (Bool -> Void)? = nil) {
        UIView.animateWithDuration(duration, animations: {
            self.view.backgroundColor = UIColor(white: 0.0, alpha: show ? 0.3 : 0.0)
            self.sheetView?.frame = show ? self.view.bounds : CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: callBack)
    }
    
}





















