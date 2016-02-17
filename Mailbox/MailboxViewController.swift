//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Alex Miles on 2/16/16.
//  Copyright © 2016 Dropbox. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var rightIcon: UIImageView!

    
    let mailboxGreen = UIColor(hue: 120/360, saturation: 54/100, brightness: 85/100, alpha: 1.0) /* #62d962 */
    let mailboxLightGray = UIColor(hue: 0.4722, saturation: 0, brightness: 0.92, alpha: 1.0)
    let mailboxRed =  UIColor(hue: 19/360, saturation: 95/100, brightness: 94/100, alpha: 1.0) /* #ef540b */
    let mailboxYellow = UIColor(hue: 48/360, saturation: 100/100, brightness: 100/100, alpha: 1.0) /* #ffcc00 */
    
    var initialCenter: CGPoint!
    
    
    func onMessagePan(panGestureRecognizer: UIPanGestureRecognizer){
        // Absolute x,y coordinates in parent view
        let point = panGestureRecognizer.locationInView(messageView)
        
        // Relative change in (x,y) coordinates from where gesture began
        let translation = panGestureRecognizer.translationInView(messageView)
//        let velocity = panGestureRecognizer.velocityInView(messageView)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            initialCenter = messageImage.center
            self.messageView.backgroundColor = self.mailboxLightGray
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            messageImage.center = CGPoint(x: translation.x + initialCenter.x, y: initialCenter.y)

            
            if translation.x <= 60 {
                UIView.animateWithDuration(0.05, animations: { () -> Void in
                    self.messageView.backgroundColor = self.mailboxLightGray
                    self.leftIcon.image = UIImage(named: "archive_icon.png")
                    self.leftIcon.alpha = convertValue(translation.x, r1Min: 0, r1Max: 59, r2Min: 0, r2Max: 1)
                    print(self.leftIcon.alpha)
//                    print(self.leftIcon.alpha)
//                    print(translation.x)
                })
            } else if translation.x >= 61 && translation.x <= 260 {
                UIView.animateWithDuration(0.05, animations: { () -> Void in
                    self.messageView.backgroundColor = self.mailboxGreen
                    self.leftIcon.image = UIImage(named: "archive_icon.png")
                })
            } else if translation.x >= 261 {
                UIView.animateWithDuration(0.05, animations: { () -> Void in
                    self.messageView.backgroundColor = self.mailboxRed
                    self.leftIcon.image = UIImage(named: "delete_icon.png")
                })
            }

        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
//            print("Gesture ended at: \(point)")
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.messageImage.center = CGPoint(x: self.messageView.frame.width / 2, y: self.messageView.frame.height / 2)
            })
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 320, height: 1245)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onMessagePan:")
        
        messageView.addGestureRecognizer(panGestureRecognizer)
        messageView.backgroundColor = mailboxLightGray
        
        var leftIconPosition = CGPoint(x: 30, y: messageView.frame.size.height / 2)
        leftIcon.center = leftIconPosition
        leftIcon.alpha = 0
        
        leftIcon.image = UIImage(named: "archive_icon")
        
        
        var rightIconPosition = CGPoint(x: 320 - 30, y: messageView.frame.size.height / 2)
        rightIcon.center = rightIconPosition
        rightIcon.alpha = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
