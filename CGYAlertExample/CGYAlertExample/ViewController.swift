//
//  ViewController.swift
//  CGYAlertExample
//
//  Created by Chakery on 16/8/17.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orangeColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func AlertEvent(sender: AnyObject) {
        // CGYAlertController
        CGYAlertController(title: "提示", message: "这是一个简单的提示", preferredStyle: .Alert, actions:
            CGYAlertAction(title: "取消", style: .Cancel),
            CGYAlertAction(title: "确定", style: .Default) { action in
                print(action.title)
            }
        ).show()
        
        
        
        // UIAlertController
//        let alert = UIAlertController(title: "提示", message: "这是一个简单的提示", preferredStyle: .Alert)
//        let cancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
//        let ok = UIAlertAction(title: "确定", style: .Cancel) { _ in
//            print("确定")
//        }
//        alert.addAction(cancel)
//        alert.addAction(ok)
//        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func ActionSheetEvent(sender: AnyObject) {
        CGYAlertController(title: "警告", message: "马蓉在哪里?", preferredStyle: .ActionSheet, actions:
            CGYAlertAction(title: "中国", style: .Default) { action in
                print(action.title)
            },
            CGYAlertAction(title: "美国", style: .Default) { action in
                print(action.title)
            },
            CGYAlertAction(title: "日本", style: .Default) { action in
                print(action.title)
            },
            CGYAlertAction(title: "新加坡", style: .Default) { action in
                print(action.title)
            },
            CGYAlertAction(title: "取消", style: .Cancel)
            ).show()
    }
}

