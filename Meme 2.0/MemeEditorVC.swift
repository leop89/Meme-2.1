//
//  MemeEditorVC.swift
//  Meme 2.0
//
//  Created by Leonid Pustilnik on 8/31/15.
//  Copyright (c) 2015 Leonid Pustilnik. All rights reserved.
//

import UIKit

class MemeEditorVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIToolbarDelegate ,UITextFieldDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memeMeAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSBackgroundColorAttributeName : UIColor.clearColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0,
        ]
        
        topText.text = "TOP TEXT HERE"
        topText.defaultTextAttributes = memeMeAttributes
        topText.delegate = self
        topText.textAlignment = NSTextAlignment.Center
        
        
        
        bottomText.text = "BOTTOM TEXT HERE"
        bottomText.defaultTextAttributes = memeMeAttributes
        bottomText.delegate = self
        bottomText.textAlignment = NSTextAlignment.Center
        
        
        topToolBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        topToolBar.shadowImage = UIImage()
        topToolBar.translucent = true
        
        bottomToolBar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.Bottom, barMetrics: UIBarMetrics.Default)
        bottomToolBar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.Bottom)
        bottomToolBar.translucent = true
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        shareButton.enabled = imageView.image != nil
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
        
    }
    
    @IBOutlet var topText: UITextField!
    @IBOutlet var bottomText: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var albumButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet var topToolBar: UINavigationBar!
    @IBOutlet var bottomToolBar: UIToolbar!
    
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func shareMemedImage(sender: AnyObject) {
        
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler  = {activity, success, items, error in
            if success {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func dismissMemeEditor(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = image
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue
        
        if bottomText.editing {
            return keyboardSize!.CGRectValue().height
        }
        else {
            return 0
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func save() {
        
        let memedImage = generateMemedImage()
        
        let meme = Meme(topText: topText.text, bottomText: bottomText.text, imageView: imageView.image!, memedImage: memedImage)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        topToolBar.hidden = true
        bottomToolBar.hidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        topToolBar.hidden = false
        bottomToolBar.hidden = false
        
        return memedImage
    }
}

