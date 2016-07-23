//
//  AutolayoutViewController.swift
//  cs193p
//
//  Created by Mr.Q.Young on 16/7/18.
//  Copyright © 2016年 Yorn. All rights reserved.
//

import UIKit

class AutolayoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func rotate() {
        let left = UIInterfaceOrientation.LandscapeLeft.rawValue    // 4
        let right = UIInterfaceOrientation.Portrait.rawValue    // 1
        if UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation) {
            UIDevice.currentDevice().setValue(left, forKey: "orientation")
        } else {
            UIDevice.currentDevice().setValue(right, forKey: "orientation")
        }
    }
    

    @IBAction func changeSecrue(sender: UISwitch) {
        passwordField?.secureTextEntry = sender.on
        passwordLabel?.text = sender.on ? "Secure Password" : "Password"
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
