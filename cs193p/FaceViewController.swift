//
//  FaceViewController.swift
//  cs193p
//
//  Created by Mr.Q.Young on 16/7/17.
//  Copyright © 2016年 Yorn. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController, FaceViewDataSource {

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
    
    var happiness: Int = 80 {
        didSet{
            happiness = min(max(happiness, 0), 100)
            updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.faceViewDataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "zoom:"))
        }
    }
    
    @IBAction func changeHappiness(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = sender.translationInView(faceView)
            let offset = Int(translation.y / 4)
            if offset != 0 {
                happiness += offset
                sender.setTranslation(CGPointZero, inView: faceView)
            }
        default: break
        }
    }
    
    func updateUI() { faceView.setNeedsDisplay() }
    
    func getHappiness(sender: FaceView) -> Double? {
        return Double(happiness - 50) / 50
    }
    
    

}
