//
//  DetailViewController.swift
//  ExchangeOGram
//
//  Created by Ziyang Tan on 2/16/15.
//  Copyright (c) 2015 Ziyang Tan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var messageImageView: UIImageView!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    var detailItem: PFObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: PFObject = self.detailItem {
            
            if let textView = messageTextView {
                textView.text = detail["textContent"] as? String
            }
            
            let imageFile = detail["messageImage"] as PFFile
            
            imageFile.getDataInBackgroundWithBlock({ (data:NSData!, error:NSError!) -> Void in
                if error == nil {
                    let image = UIImage(data:data)
                    self.messageImageView.image = image
                }
                }, progressBlock: { (progress:Int32) -> Void in
                    println(progress)
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

