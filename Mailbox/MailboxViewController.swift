//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Alex Miles on 2/16/16.
//  Copyright © 2016 Dropbox. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var feedView: UIImageView!
    
    var rescheduleImageView: UIImageView?
    var listImageView: UIImageView?
    
    let mailboxGreen = UIColor(hue: 120/360, saturation: 54/100, brightness: 85/100, alpha: 1.0) /* #62d962 */
    let mailboxLightGray = UIColor(hue: 0.4722, saturation: 0, brightness: 0.92, alpha: 1.0)
    let mailboxRed =  UIColor(hue: 19/360, saturation: 95/100, brightness: 94/100, alpha: 1.0) /* #ef540b */
    let mailboxYellow = UIColor(hue: 48/360, saturation: 100/100, brightness: 100/100, alpha: 1.0) /* #ffcc00 */
    let mailboxBrown = UIColor(hue: 30/360, saturation: 46/100, brightness: 85/100, alpha: 1.0) /* #d8a675 */
    
    var initialCenter: CGPoint!
    var leftIconPosition: CGPoint!
    var rightIconPosition: CGPoint!
    
    enum Direction {
        case Left, Right
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    
    func onRescheduleTap(tapGestureRecognizerForReschedule: UITapGestureRecognizer){
        print("hit")
    }
    
    func onMessagePan(panGestureRecognizer: UIPanGestureRecognizer){
        // Absolute x,y coordinates in parent view
        // let point = panGestureRecognizer.locationInView(messageView)
        // let velocity = panGestureRecognizer.velocityInView(messageView)
        
        // Relative change in (x,y) coordinates from where gesture began
        let translation = panGestureRecognizer.translationInView(messageView)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            initialCenter = messageImage.center
            self.messageView.backgroundColor = self.mailboxLightGray
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            // Move message cell
            messageImage.center = CGPoint(x: translation.x + initialCenter.x, y: initialCenter.y)
            
            if translation.x > 0 {
                if translation.x <= 60 {
                    UIView.animateWithDuration(0.05, animations: { () -> Void in
                        self.messageView.backgroundColor = self.mailboxLightGray
                        self.leftIcon.image = UIImage(named: "archive_icon.png")
                    })
                    self.leftIcon.alpha = convertValue(translation.x, r1Min: 0, r1Max: 50, r2Min: 0, r2Max: 1)
                } else if translation.x >= 61 && translation.x <= 260 {
                    UIView.animateWithDuration(0.05, animations: { () -> Void in
                        self.messageView.backgroundColor = self.mailboxGreen
                        self.leftIcon.image = UIImage(named: "archive_icon.png")
                    })
                    self.leftIcon.center = CGPoint(x: translation.x - self.leftIconPosition.x, y: self.leftIconPosition.y)
                } else if translation.x >= 261 {
                    UIView.animateWithDuration(0.05, animations: { () -> Void in
                        self.messageView.backgroundColor = self.mailboxRed
                        self.leftIcon.image = UIImage(named: "delete_icon.png")
                    })
                    self.leftIcon.center = CGPoint(x: translation.x - self.leftIconPosition.x, y: self.leftIconPosition.y)
                }
            } else {
                if translation.x > -60 {
                    UIView.animateWithDuration(0.05, animations: { () -> Void in
                        self.messageView.backgroundColor = self.mailboxLightGray
                        self.rightIcon.image = UIImage(named: "later_icon.png")
                    })
                    self.rightIcon.alpha = convertValue(translation.x, r1Min: 0, r1Max: -50, r2Min: 0, r2Max: 1)
                } else if translation.x <= -60 && translation.x >= -260 {
                    UIView.animateWithDuration(0.05, animations: { () -> Void in
                        self.messageView.backgroundColor = self.mailboxYellow
                        self.rightIcon.image = UIImage(named: "later_icon.png")
                    })
                    self.rightIcon.center = CGPoint(x: 320 + 30 + translation.x, y: self.rightIconPosition.y)
                } else if translation.x <= -261 {
                    UIView.animateWithDuration(0.05, animations: { () -> Void in
                        self.messageView.backgroundColor = self.mailboxBrown
                        self.rightIcon.image = UIImage(named: "list_icon.png")
                    })
                    self.rightIcon.center = CGPoint(x: 320 + 30 + translation.x, y: self.rightIconPosition.y)
                }
            }
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            if translation.x > 0 {
                if translation.x <= 60 {
                    self.cancelMessageSlideOut()
                } else if translation.x >= 61 && translation.x <= 260 {
                    self.completeMessageSlideOut(Direction.Right, showScreen: nil)
                } else if translation.x >= 261 {
                    self.completeMessageSlideOut(Direction.Right, showScreen: nil)
                }
            } else {
                if translation.x > -60 {
                    self.cancelMessageSlideOut()
                } else if translation.x <= -60 && translation.x >= -260 {
                    self.completeMessageSlideOut(Direction.Left, showScreen: "reschedule")
                } else if translation.x <= -261 {
                    self.completeMessageSlideOut(Direction.Left, showScreen: "list")
                }
            }
        }
    }
    
    func cancelMessageSlideOut() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.messageImage.center = CGPoint(x: self.messageView.frame.width / 2, y: self.messageView.frame.height / 2)
        })
    }
    
    func completeMessageSlideOut(direction: Direction, showScreen: String?) {
        if direction == Direction.Right {
            // For archive and delete
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.messageImage.frame.origin.x = self.messageView.frame.size.width * 1.2
                self.leftIcon.frame.origin.x = self.messageImage.frame.origin.x - 40
            }, completion: { finished in
                    self.hideMessageView()
            })
        } else if direction == Direction.Left {
            // For list and reschedule
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.messageImage.frame.origin.x = -self.messageView.frame.size.width * 1.2
                self.rightIcon.frame.origin.x = self.messageImage.frame.origin.x + 320 + 15
            }, completion: { finished in
                if showScreen == "reschedule" {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.rescheduleImageView?.alpha = 1
                    })
                } else if showScreen == "list" {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.listImageView?.alpha = 1
                    })
                }
//                    self.hideMessageView()
                
            })
        }
    }
    
    func hideMessageView() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.feedView.frame.origin.y -= 86
        }, completion: { finished in
            self.showMessageView()
        })
    }
    
    func showMessageView() {
        messageImage.center = CGPoint(x: messageView.frame.width / 2, y: messageView.frame.height / 2)
        UIView.animateWithDuration(0.2, delay: 0.5, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.feedView.frame.origin.y += 86
        }, completion: {finished in
            
        })
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 320, height: 1245)
        
        let tapGestureRecognizerForReschedule = UITapGestureRecognizer(target: self, action: "onRescheduleTap:")
        tapGestureRecognizerForReschedule.delegate = self
        rescheduleImageView?.userInteractionEnabled = true
        rescheduleImageView?.addGestureRecognizer(tapGestureRecognizerForReschedule)
        
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onMessagePan:")
        panGestureRecognizer.delegate = self
        messageView.addGestureRecognizer(panGestureRecognizer)
        messageView.backgroundColor = mailboxLightGray
        
        leftIconPosition = CGPoint(x: 30, y: messageView.frame.size.height / 2)
        leftIcon.center = leftIconPosition
        leftIcon.alpha = 0
        leftIcon.image = UIImage(named: "archive_icon")
        
        rightIconPosition = CGPoint(x: 320 - 30, y: messageView.frame.size.height / 2)
        rightIcon.center = rightIconPosition
        rightIcon.alpha = 0
        
        let listImage: UIImage = UIImage(named: "list")!
        listImageView = UIImageView(image: listImage)
        listImageView!.frame = CGRect(x: 0, y: 0, width: 320, height: 568)
        self.view.addSubview(listImageView!)
        listImageView?.alpha = 0
        
        let rescheduleImage: UIImage = UIImage(named: "reschedule")!
        rescheduleImageView = UIImageView(image: rescheduleImage)
        rescheduleImageView!.frame = CGRect(x: 0, y: 0, width: 320, height: 568)
        self.view.addSubview(rescheduleImageView!)
        rescheduleImageView?.alpha = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
