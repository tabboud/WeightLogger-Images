//
//  WeightLogTableViewController.swift
//  WeightLogger
//
//  Created by Tony on 10/14/14.
//  Copyright (c) 2014 Abbouds Corner. All rights reserved.
//

import UIKit
import CoreData


class WeightLogTableViewController: UITableViewController {
    var totalEntries: Int = 0
    
    @IBOutlet var tblLog : UITableView?
    
    @IBAction func btnClearLog(sender : AnyObject) {
        let appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "UserWeights")
        request.returnsObjectsAsFaults = false
        do {
            let results: NSArray = try context.executeFetchRequest(request)
            for weightEntry: UserWeights in results as! [UserWeights]{
                let noPhotoURL =  NSURL(fileURLWithPath: noPhotoPNG).absoluteString
                if(weightEntry.photoFullURL != noPhotoURL){
                    let paths: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                    let documentsDir: NSString = paths.objectAtIndex(0) as! NSString
                    
                    //Delete the photo from the Doc. Dir using NSFileManager
                    let fileManager: NSFileManager = NSFileManager.defaultManager()
                    try fileManager.removeItemAtPath(documentsDir.stringByAppendingString(weightEntry.photoFullURL))
                    try fileManager.removeItemAtPath(documentsDir.stringByAppendingString(weightEntry.photoThumbURL))
                }
                context.deleteObject(weightEntry as NSManagedObject)
            }
            try context.save()
        } catch _ {
                
            }
        totalEntries = 0
        tblLog?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "UserWeights")
        request.returnsObjectsAsFaults = false
        
        totalEntries = context.countForFetchRequest(request, error: nil) as Int!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showFullScreenPhoto"){
            //Pass the data to the new viewController
            let controller: FullScreenPhoto_ViewController = segue.destinationViewController as! FullScreenPhoto_ViewController
            let indexPath: NSIndexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)!
            
            //Fetch the data from CoreData
            let appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
            let context = appDel.managedObjectContext
            let request = NSFetchRequest(entityName: "UserWeights")
            request.returnsObjectsAsFaults = false
            var results = NSArray()
            
            do{
                results = try context.executeFetchRequest(request)
            } catch {
                
            }
            //Get the data for selected cell
            let userData: UserWeights = results[indexPath.row] as! UserWeights
            
            // Pass the data to the next view controller
            controller.photoFullURL = userData.photoFullURL
            controller.weight = userData.weight
            controller.date = userData.date
        }
    }
    
    
    
    
//*** UITableViewDataSource Methods ***//
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalEntries
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 75.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let reuseIdentifier = "WeightLogItem"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as UITableViewCell!
        let appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "UserWeights")
        request.returnsObjectsAsFaults = false
        var results: NSArray = NSArray()
        do {
            results = try context.executeFetchRequest(request)
        }catch {
        
        }
        
        //get contents and put into cell
        let thisWeight: UserWeights = results[indexPath.row] as! UserWeights
        
        let weightLabel: UILabel = cell.viewWithTag(101) as! UILabel
        weightLabel.text = thisWeight.weight + " " + thisWeight.units
        
        let dateDetailLabel: UILabel = cell.viewWithTag(102) as! UILabel
        dateDetailLabel.text = thisWeight.date
        
        let thumbnailPhoto: UIImageView = cell.viewWithTag(100) as! UIImageView
        let noPhotoStr = NSURL(fileURLWithPath: noPhotoPNG).absoluteString
        if(thisWeight.photoFullURL != noPhotoStr){
            let paths: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let documentsDir: NSString = paths.objectAtIndex(0) as! NSString
            
            let path: NSString = documentsDir.stringByAppendingString(thisWeight.photoThumbURL)
            thumbnailPhoto.image = UIImage(contentsOfFile: path as String)
        }else{
            thumbnailPhoto.image = UIImage(named: noPhotoPNG)
        }
   
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        //delete object from entity, remove from list
        let reuseIdentifier = "WeightLogItem"
        _ = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
        let appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "UserWeights")
        request.returnsObjectsAsFaults = false
        var results = NSArray()
        do {
            results = try context.executeFetchRequest(request)
        } catch {
            
        }
        
        //Get value that is being deeleted
        let tmpObject: NSManagedObject = results[indexPath.row] as! NSManagedObject
        let delWeight = tmpObject.valueForKey("weight") as! String
        print("Deleted Weight: \(delWeight)")
        
        let noPhotoURL =  NSURL(fileURLWithPath: noPhotoPNG).absoluteString
        if(results[indexPath.row].photoFullURL != noPhotoURL){
            let paths: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let documentsDir: NSString = paths.objectAtIndex(0) as! NSString
            
            //Delete the photo from the Doc. Dir using NSFileManager
            let fileManager: NSFileManager = NSFileManager.defaultManager()
            do {
                try fileManager.removeItemAtPath(documentsDir.stringByAppendingString(results[indexPath.row].photoFullURL))
            } catch _ {
            }
            do {
                try fileManager.removeItemAtPath(documentsDir.stringByAppendingString(results[indexPath.row].photoThumbURL))
            } catch _ {
            }
            
        }
        context.deleteObject(results[indexPath.row] as! NSManagedObject)
        do{
            try context.save()
        } catch _ {
        }
        totalEntries = totalEntries - 1
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        print("Done")
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
//        // Force the segue to occur
//        self.performSegueWithIdentifier("showFullScreenPhoto", sender: tableView.cellForRowAtIndexPath(indexPath))
//    }

}





























