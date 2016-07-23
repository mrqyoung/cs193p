//
//  StoryTableViewCell.swift
//  cs193p
//
//  Created by Mr.Q.Young on 16/7/19.
//  Copyright © 2016年 Yorn. All rights reserved.
//

import UIKit
import ObjectiveC

class StoryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // cell border
        let layer = self.contentView.layer
        layer.cornerRadius = 4.0
        layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).CGColor
        layer.borderWidth = 0.5
    }
    
    
    override func layoutSubviews() {/* should keep this empty func here to make it work! strange!
        let frame0 = contentView.frame
        let frame1 = UIEdgeInsetsInsetRect(frame0, UIEdgeInsetsMake(4, 8, 4, 8))
        contentView.frame = frame1
        
        contentView.layer.shadowOffset = CGSizeMake(0, 1)
        contentView.layer.shadowColor = UIColor.blackColor().CGColor
        contentView.layer.shadowRadius = 1
        contentView.layer.shadowOpacity = 0.6
        //contentView.clipsToBounds = false

        let shadowFrame: CGRect = contentView.layer.bounds
        let shadowPath: CGPathRef = UIBezierPath(rect: shadowFrame).CGPath
        contentView.layer.shadowPath = shadowPath
        */
    }
    
    

    @IBOutlet weak var itemTitle: UILabel!
    
    
    @IBOutlet weak var itemImage: UIImageView!
    
    
    var story: Story? {
        didSet { updateUI() }
    }
    
    var thumbImage: UIImage? {
        didSet {
            self.itemImage.image = thumbImage
        }
    }
    
    private func updateUI() {
        self.itemTitle.text = self.story?.title
        //if self.thumbImage == nil { getTheImage() }
    }
    
    func getTheImage(handle: (UIImage?) -> Void) {
        if let imgUrl: NSURL = NSURL(string: (self.story?.thumbnail_url)!) {
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            config.timeoutIntervalForRequest = 10
            let session = NSURLSession(configuration: config)
            let task = session.dataTaskWithURL(imgUrl) {
                (data, response, error) -> Void in
                if error == nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        let thumb = UIImage(data: data!)
                        self.thumbImage = thumb
                        handle(thumb)
                    }
                } else {
                    print("\(error)")
                }
            }
            task.resume()
        }
    }
    
    
}

/*
extension Story {
    var image: UIImage?
    var thumb: UIImage?
}
*/
