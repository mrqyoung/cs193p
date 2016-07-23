//
//  StoryWebViewController.swift
//  cs193p
//
//  Created by Mr.Q.Young on 16/7/23.
//  Copyright © 2016年 Yorn. All rights reserved.
//

import UIKit

class StoryWebViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStory()

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

    @IBOutlet weak var storyWebview: UIWebView!
    
    var storyUrl: String?
    private let dailyHomeUrl = "http://daily.zhihu.com/"
    
    private func loadStory() {
        let urlString = self.storyUrl ?? dailyHomeUrl
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            self.storyWebview.loadRequest(request)
        }
    }
    
}
