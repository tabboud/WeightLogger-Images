//
//  FullScreenPhoto_ViewController.swift
//  WeightLogger
//
//  Created by Tony on 10/14/14.
//  Copyright (c) 2014 Abbouds Corner. All rights reserved.
//

import UIKit

class FullScreenPhoto_ViewController: UIViewController {
    var photoFullURL: String!
    var date: String!
    var weight: String!
    
    
    @IBOutlet var photoFull: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        // Get photo from path URL and display it
        let noPhotoURL =  NSURL(fileURLWithPath: noPhotoPNG).absoluteString
        if(self.photoFullURL != noPhotoURL){
            let paths: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let documentsDir: NSString = paths.objectAtIndex(0) as! NSString
            
            let path: NSString = documentsDir.stringByAppendingString(self.photoFullURL)
            self.photoFull.image = UIImage(contentsOfFile: path as String)
        }else{
            self.photoFull.image = UIImage(named: noPhotoPNG)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
