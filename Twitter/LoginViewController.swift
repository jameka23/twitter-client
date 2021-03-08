//
//  LoginViewController.swift
//  Twitter
//
//  Created by Jameka Echols on 3/7/21.
//  Copyright © 2021 Dan. All rights reserved.
//

//This file will connect to the login screen


import UIKit

class LoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func OnLoginButton(_ sender: Any) {
        
        let url = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: url, success: {
            // want user to go from login to home screen
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (Error) in
            // what happens when fail; print message
            print("Could not login!")
        })
    }
    

}
