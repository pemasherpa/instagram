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

    var instagram: [NSDictionary]?
    
    @IBOutlet weak var photoTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        photoTableView.delegate = self
        photoTableView.dataSource = self
        photoTableView.rowHeight = 320
        
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
                            
                            self.photoTableView.reloadData()
                    }
                }
        })
        task.resume()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let instagram = instagram {
            return instagram.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = photoTableView.dequeueReusableCellWithIdentifier("photoCell", forIndexPath: indexPath) as! photoCell
    
        let photo = instagram![indexPath.row]
        let photoUrl = photo.valueForKeyPath("images.low_resolution.url") as? String
        
        cell.pictureView.setImageWithURL(NSURL(string: photoUrl!)!)
        
        return cell
    }
 

}

