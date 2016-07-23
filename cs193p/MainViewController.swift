//
//  ViewController.swift
//  cs193p
//
//  Created by Mr.Q.Young on 16/7/16.
//  Copyright © 2016年 Yorn. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private struct SegueTarget {
        static let Calculator0 = "showCalc0"
        static let Calculator1 = "showCalc1"
        static let HappyFace = "showHappyFace"
        static let LayoutDemo = "showLayoutDemo"
        static let ZhihuDaily = "showZhihuDaily"
        static let AboutPopover = "showAboutPopover"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let targetId = segue.identifier {
            switch targetId {
            case SegueTarget.Calculator1:
                if let target = segue.destinationViewController as? CalcViewController {
                    target.calculatorStyle = 1
                }
            case SegueTarget.AboutPopover:
                if let ppc = segue.destinationViewController.popoverPresentationController {
                    ppc.delegate = self
                }
            default: break
            }
            print("Segue = \(targetId)")
        }
    }
    
    func adaptivePresentationStyleForPresentationController(c: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    //private let defaults = NSUserDefaults.standardUserDefaults()

}

