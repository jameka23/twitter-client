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
    
    override func viewDidAppear(_ animated: Bool) {
        // check that the userdefault is set for a specific key
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            // don't ask to login again, go ahead to seque
            performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    @IBAction func OnLoginButton(_ sender: Any) {
        
        let url = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: url, success: {
            // stay logged in when successful login happens
            // user default
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            
            // want user to go from login to home screen
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (Error) in
            // what happens when fail; print message
            print("Could not login!")
        })
    }
    

}
