//
//  TweetViewController.swift
//  Twitter
//
//  Created by Jameka Echols on 3/8/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tell text to be a first responder
        tweetTextView.becomeFirstResponder()
        tweetTextView.layer.borderColor = UIColor.lightGray.cgColor
        tweetTextView.layer.borderWidth = 2.3
        tweetTextView.layer.cornerRadius = 15
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty){
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (Error) in
                print("Error posting tweet \(Error)")
            })
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
}
