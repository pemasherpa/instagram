//
//  ViewController.swift
//  Instagram
//
//  Created by Pema Sherpa on 1/31/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var instagram: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 320
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "getInstagramData", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refreshControl, atIndex: 0)
        getInstagramData()
        
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let instagram = instagram {
            return instagram.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("photoTableViewCell", forIndexPath: indexPath) as! photoTableViewCell

        let photo = instagram![indexPath.section]
        let images = (photo["images"] as! NSDictionary)["standard_resolution"] as! NSDictionary
        let photoUrl = NSURL(string: images["url"] as! String)
        cell.pictureView.setImageWithURL(photoUrl!)
        
        return cell
    }
    
    func getInstagramData() {
        
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.instagram = responseDictionary["data"] as? [NSDictionary]
                            
                            self.tableView.reloadData()
                            self.refreshControl.endRefreshing() 
                    }
                }
                
               
        });
        task.resume()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        
        let photo = instagram![section]
        let user = photo["user"] as! NSDictionary
        let photoUrl = NSURL(string: user["profile_picture"] as! String)
        
        profileView.setImageWithURL(photoUrl!)
            
        let usernameView = UILabel(frame: CGRect(x: 50, y: 10, width: 200, height: 30))
        usernameView.clipsToBounds = true
        usernameView.textColor = UIColor(red:0.022, green:0.21, blue:0.396, alpha:1)
        
        let username = user["username"] as! String
        usernameView.text = username
        
        headerView.addSubview(profileView)
        headerView.addSubview(usernameView)
        
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}

