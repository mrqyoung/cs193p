//
//  Story.swift
//  cs193p
//
//  Created by Mr.Q.Young on 16/7/20.
//  Copyright © 2016年 Yorn. All rights reserved.
//

import Foundation


struct Story {
    let id: Int?
    let title: String?
    let url: String?
    let share_url: String?
    let image_url: String?
    let thumbnail_url: String?
    let ga_prefix: String?
    
    init(id i: Int, title t: String, url u: String, share_url su: String, image img: String, thumb tn: String, prefix p: String) {
        self.id = i
        self.title = t
        self.url = u
        self.share_url = su
        self.image_url = img
        self.thumbnail_url = tn
        self.ga_prefix = p
    }
    
    init(dataDict: NSDictionary) {
        self.id = dataDict["id"] as? Int
        self.title = dataDict["title"] as? String
        self.url = dataDict["url"] as? String
        self.share_url = dataDict["share_url"] as? String
        self.image_url = dataDict["image"] as? String
        self.thumbnail_url = dataDict["thumbnail"] as? String
        self.ga_prefix = dataDict["ga_prefix"] as? String
    }
}

struct Page {
    let date: String?
    let display_date: String?
    let is_today: Bool?
    let news: [Story]?
    let top_stories: [Story]?
    
    init(date d: String, news n: [Story], isToday t: Bool, top5 t5: [Story], displayDate dd: String) {
        self.date = d
        self.news = n
        self.is_today = t
        self.top_stories = t5
        self.display_date = dd
    }
    
    init(pageDict: NSDictionary) {
        self.date = pageDict["date"] as? String
        self.display_date = pageDict["display_date"] as? String
        self.is_today = pageDict["is_today"] as? Bool
        self.news = [Story]()
        if let newsDictArray = pageDict["news"] as? Array<NSDictionary> {
            for newsDict in newsDictArray {
                self.news!.append(Story(dataDict: newsDict))
            }
        }
        // TODO top5
        self.top_stories = nil
    }
}


class PageRequest {
    private let url_latest = "http://news-at.zhihu.com/api/2/news/latest"
    private let url_before_prefix = "http://news-at.zhihu.com/api/2/news/before/"
    
    var dailyNews: NSDictionary?
    private var session: NSURLSession?
    
    init() {
        if self.session == nil {
            initSession()
        }
    }
    
    struct Error {
        static let TaskError = "Can't create a task"
        static let URLError = "Bad url"
        static let DataError = "Bad response data"
        static let UnknownError = "Can not fetch new things"
    }
    
    private func initSession() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 10
        self.session = NSURLSession(configuration: config)
    }
    
    private func getNewsData(session: NSURLSession, _ url: String) {
        if let url = NSURL(string: url) {
        let task = session.dataTaskWithURL(url, completionHandler: {(data, response, error) -> Void in
            if error == nil {
            if let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSDictionary {
                print("\(json)")
                self.dailyNews = json
            }
            } else { print("\(error)") }
        })
        task.resume()
        }
    }
    
    func fetchDaily(date: String?, handle: (page: Page?, error: String?) -> Void) {
        let urlString: String = (date == nil) ? url_latest : "\(url_before_prefix)\(Int(date!)! - 1)"
        if let url = NSURL(string: urlString) {
            let task = self.session?.dataTaskWithURL(url, completionHandler: {
                (data, response, error) -> Void in
                if error == nil {
                    if let jsonDict = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSDictionary {
                        let dailyPage = Page(pageDict: jsonDict!)
                        handle(page: dailyPage, error: nil)
                    } else {
                        print("\(String(data: data!, encoding: NSUTF8StringEncoding)) \n \(response)")
                        handle(page: nil, error: Error.DataError)
                    }
                } else {
                    print("\(error)")
                    handle(page: nil, error: error!.localizedDescription)
                }
            })
            if task != nil {
                task!.resume()
            } else { handle(page: nil, error: Error.TaskError) }
        } else { handle(page: nil, error: Error.URLError) }
    }
    
    func fetchStories(date: NSString?) -> Array<Story>? {
        let url: String = (date == nil) ? url_latest : url_before_prefix + (date! as String)
        getNewsData(self.session!, url)
        if let news = self.dailyNews!["news"] as? NSArray {
            var stories = [Story]()
            for n in news {
                let story = Story(dataDict: (n as? NSDictionary)!)
                stories.append(story)
            }
            return stories
        }
        return nil
    }
    
}

