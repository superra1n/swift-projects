//
//  MasterViewController.swift
//  Project 7
//
//  Created by LiangTzu Chun on 3/4/16.
//  Copyright © 2016 Jim. All rights reserved.
//

import UIKit

extension String  {
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        var hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.dealloc(digestLen)
        
        return String(format: hash as String)
    }
}

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [[String: String]]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let urlString: String
        let productSN = 105
        let language = "1" // 1: CHT, 2: CHS, 3: ENG
        var timeStamp = (NSDate().timeIntervalSince1970).description
        print(timeStamp)
        timeStamp = timeStamp.substringToIndex(timeStamp.rangeOfString(".")!.startIndex)
        let privateKey = "kikirace"
        let key = md5(string: timeStamp + privateKey)
        
        print(key)
        
        
        if navigationController?.tabBarItem.tag == 0 {
            //urlString = "http://kikistore.csmuse.com/kikistore/api/getProductDetail.php?" + "ProductSN=" + productSN.description + "&Language=" + language + "&Time=" + currentTime + "&Key=" + md5CheckSum
            urlString = "http://kikistore.csmuse.com/kikistore/api/kikirace_getProductDetail.php?" + "Key=" + key + "&Language=" + language + "&ProductSN=" + productSN.description + "&Time=" + timeStamp
            print(urlString)
        } else {
            urlString = "http://kikistore.csmuse.com/kikistore/api/getProductDetail.php?"
        }
        
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                
                if json["ErrorCode"].intValue == 0 {
                    // we're OK to parse!
                    parseJSON(json)
                }
                else {
                    parseErrorJSON(json)
                }
            }
            else {
                showError()
            }
        }
        else {
            showError()
        }
    }
    
    func parseJSON(json: JSON) {
        for result in json["Product"].arrayValue {
            let title = result["ProductVendor"].stringValue
            let body = result["ProductTitle"].stringValue
            let sigs = result["SellPrice"].stringValue
            let obj = ["title": title, "body": body, "sigs": sigs]
            objects.append(obj)
        }
        
        tableView.reloadData()
    }
    
    func parseErrorJSON(json: JSON) {
            let title = json["ErrorCode"].stringValue
            let body = json["ErrorMsg"].stringValue
            let sigs = json["ErrorCode"].stringValue
            let obj = ["title": title, "body": body, "sigs": sigs]
            objects.append(obj)
        
    tableView.reloadData()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object["title"]
        cell.detailTextLabel!.text = object["body"]
        return cell
    }

    func md5(string string: String) -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }

}

