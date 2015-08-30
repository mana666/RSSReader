//
//  TableViewController.swift
//  Livedoor
//
//  Created by mana on 8/28/15.
//  Copyright (c) 2015 mana. All rights reserved.
//

import UIKit

class TopTableViewController: UITableViewController, MWFeedParserDelegate{
    var entries = [MWFeedItem]()
    var menuNum = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func request(){
        var adrs = NSURL(string: "http://news.livedoor.com/topics/rss/top.xml")
        var feedParser = MWFeedParser(feedURL: adrs)
        feedParser.delegate = self
        feedParser.parse()
    }
    
    func feedParserDidStart(parser: MWFeedParser!) {
        entries = [MWFeedItem]()
    }
    
    func feedParserDidFinish(parser: MWFeedParser!) {
        self.tableView.reloadData()
    }
    
    func feedParser(parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        self.navigationItem.title = info.title
    }
    
    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        entries.append(item)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        request()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as! UITableViewCell
        
        let item = entries[indexPath.row] as MWFeedItem
        cell.textLabel?.text = item.title
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let webItem = entries[indexPath.row] as MWFeedItem
        let webBrowser = KINWebBrowserViewController()
        let url = NSURL(string: webItem.link)
        webBrowser.loadURL(url)
        self.navigationController?.pushViewController(webBrowser, animated: true)
    }
}
