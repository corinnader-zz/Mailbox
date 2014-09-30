//
//  FeedViewController.swift
//  Mailbox
//
//  Created by Corin Nader on 9/28/14.
//  Copyright (c) 2014 Corin Nader. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var messageView: UIView!
    @IBOutlet weak var deleteIconImage: UIImageView!
    @IBOutlet weak var laterIconImage: UIImageView!
    @IBOutlet weak var listIconImage: UIImageView!
    @IBOutlet weak var archiveIconImage: UIImageView!
    @IBOutlet var messageImage: UIImageView!
    @IBOutlet var messagePan: UIPanGestureRecognizer!
    @IBOutlet weak var rescheduleImage: UIImageView!
    @IBOutlet var feedImage: UIImageView!
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var resetView: UIView!
    

    var messageImageCenter: CGPoint!
    var laterIconImageCenter: CGPoint!
    var messageImageFrameOriginX: CGFloat!
    var laterIconImageFrameOriginX:CGFloat!
    
    let lightGray = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
    let brown = UIColor(red: 215/255, green: 165/255, blue: 120/255, alpha: 1)
    let green = UIColor(red: 116/255, green: 215/255, blue: 104/255, alpha: 1)
    let red = UIColor(red: 233/255, green: 85/255, blue: 59/255, alpha: 1)
    let yellow = UIColor(red: 249/255, green: 210/255, blue: 70/255, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteIconImage.alpha = 0
        laterIconImage.alpha = 0
        listIconImage.alpha = 0
        archiveIconImage.alpha = 0
        rescheduleImage.alpha = 0
        listImage.alpha = 0
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Pangesture
    @IBAction func onPanMessage(gestureRecognizer: UIPanGestureRecognizer) {
        
        var location = gestureRecognizer.locationInView(view)
        var translation = gestureRecognizer.translationInView(view)
        var velocity = gestureRecognizer.velocityInView(view)
        
        // Begin Pan
        if gestureRecognizer.state == UIGestureRecognizerState.Began{
            
            self.messageView.backgroundColor = lightGray
            messageImageCenter = messageImage.center
            
            
            UIView.animateWithDuration(0.75, animations: { () -> Void in
                self.laterIconImage.alpha = 1
                self.archiveIconImage.alpha = 1
            })
        }
            
        // During panning
        else if gestureRecognizer.state == UIGestureRecognizerState.Changed{
            messageImage.center.x = translation.x + messageImageCenter.x

            
            // Dragging left
            // Later clock icon yellow bg
            if (-260 <= translation.x) && (translation.x < -60) {
                self.messageView.backgroundColor = yellow
                // Later icon follows message view
                laterIconImage.transform = CGAffineTransformMakeTranslation(translation.x + 60, 0)
                
                // Don't show
                archiveIconImage.alpha = 0
                deleteIconImage.alpha = 0
            }
            
            // List icon brown bg
            else if (-320 <= translation.x) && (translation.x < -260){
                self.messageView.backgroundColor = brown
                listIconImage.transform = CGAffineTransformMakeTranslation(translation.x + 60, 0)
                listIconImage.alpha = 1
                laterIconImage.alpha = 0
                
            }
    
            // Dragging right
            // Archive check icon green
            else if (60 <= translation.x) && (translation.x < 260){
                self.messageView.backgroundColor = green
                archiveIconImage.transform = CGAffineTransformMakeTranslation(translation.x - 60, 0)
                archiveIconImage.alpha = 1
                
                // Don't show
                deleteIconImage.alpha = 0
                laterIconImage.alpha = 0
            }
                
            // Delete icon red
            else if (260 <= translation.x) && (translation.x < 320){
                self.messageView.backgroundColor = red
                deleteIconImage.transform = CGAffineTransformMakeTranslation(translation.x - 60, 0)
                deleteIconImage.alpha = 1
                archiveIconImage.alpha = 0
            }
                
        }
            
        // Pan End
        else if gestureRecognizer.state == UIGestureRecognizerState.Ended{
            self.deleteIconImage.alpha = 0
            self.laterIconImage.alpha = 0
            self.listIconImage.alpha = 0
            self.archiveIconImage.alpha = 0
            
            // Swipe left quickly
            if velocity.x < -500 {
                messageImage.transform = CGAffineTransformMakeTranslation(-320 , 0)
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.rescheduleImage.alpha = 1
                })
            }
            //Swipe right quickly
            else if velocity.x > 500{
                messageImage.transform = CGAffineTransformMakeTranslation(320 , 0)
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.listImage.alpha = 1
                })
                
            }
                
            //Swipe left and release
            else if (-320 <= translation.x) && (translation.x < -260){
                UIView.animateWithDuration(0.8, animations: { () -> Void in
                    self.messageImage.frame.origin.x = -self.messageImage.frame.size.width
                    self.archiveIconImage.alpha = 0
                    self.listImage.alpha = 1
                })
            }
                
            // Swipe right and release
            else if (260 <= translation.x) && (translation.x < 320){
                UIView.animateWithDuration(0.1,
                    animations: {
                        self.messageImage.frame.origin.x = self.messageImage.frame.size.width
                        self.deleteIconImage.transform = CGAffineTransformMakeTranslation(self.messageView.frame.size.width - 60, 0)
                    },
                    completion: { _ in
                        UIView.animateWithDuration(0.9,
                            animations: {
                                self.messageView.transform = CGAffineTransformMakeTranslation(0, -self.messageView.frame.size.height)
                                self.feedImage.transform = CGAffineTransformMakeTranslation(0, -self.messageImage.frame.size.height)
                                self.listImage.alpha = 0
                            },
                            completion: { _ in
                                self.messageImage.removeFromSuperview()
                        })
                    }
                )
            }
            
            // back to normal
            else {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageImage.frame.origin = CGPointMake (0 , 0)
                    self.deleteIconImage.transform = CGAffineTransformIdentity
                    self.listIconImage.transform = CGAffineTransformIdentity
                    self.archiveIconImage.transform = CGAffineTransformIdentity
                    self.laterIconImage.transform = CGAffineTransformIdentity
                })
                
            }
            
            
        }
    }
    
    @IBAction func onTapDismissReschedule(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.feedImage.transform = CGAffineTransformMakeTranslation(0, -self.messageImage.frame.size.height)
            self.rescheduleImage.alpha = 0
            self.messageView.removeFromSuperview()
        })
        
    }
    @IBAction func onTapDismissList(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.feedImage.transform = CGAffineTransformMakeTranslation(0, -self.messageImage.frame.size.height)
            self.listImage.alpha = 0
            self.messageView.removeFromSuperview()
        })
    }
    
    @IBAction func onTapReset(sender: UITapGestureRecognizer) {
        self.feedImage.transform = CGAffineTransformMakeTranslation(0, 0)
        self.scrollView.addSubview(self.messageView)
        self.messageImage.frame.origin = CGPointMake (0 , 0)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            
            
            
            self.deleteIconImage.transform = CGAffineTransformIdentity
            self.listIconImage.transform = CGAffineTransformIdentity
            self.archiveIconImage.transform = CGAffineTransformIdentity
            self.laterIconImage.transform = CGAffineTransformIdentity
            
            
        })
        
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
