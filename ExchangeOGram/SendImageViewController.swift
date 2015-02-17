//
//  SendImageViewController.swift
//  ExchangeOGram
//
//  Created by Ziyang Tan on 2/16/15.
//  Copyright (c) 2015 Ziyang Tan. All rights reserved.
//

import UIKit

class SendImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UITapGestureRecognizer(target: self, action: "displayImagePicker:")
        recognizer.numberOfTapsRequired = 1
        
        imageView.addGestureRecognizer(recognizer)
        
    }
    
    func displayImagePicker (recog:UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePicker, animated:true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func sendImage(sender: AnyObject) {
        
        let message = PFObject(className: "Message")
        message["textContent"] = messageTextView.text
        
        let imageData = UIImageJPEGRepresentation(imageView.image, 0.5)
        let messageImage = PFFile(data: imageData)
        
        messageImage.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
            
            if success {
                message["messageImage"] = messageImage
                message.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                })
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            }, progressBlock: { (progress:Int32) -> Void in
                var progressF:Float = (Float(progress) / 100)
                
                self.progressBar.setProgress(progressF, animated: true)
        })
    }
    
    @IBAction func dismissVC(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Image Picker Controller Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
