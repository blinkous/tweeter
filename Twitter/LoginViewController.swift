//
//  LoginViewController.swift
//  Twitter
//
//  Created by stargaze on 3/1/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 20
    }
    
    // Configure how to nav from here to the next view controller
    @IBAction func onTapLogin(_ sender: Any) {
        let urlString = "https://api.twitter.com/oauth/request_token"
        // Calling the API
        TwitterAPICaller.client?.login(url: urlString, success: {
            // on login success, present homeTableVC
            
            // To allow user to stay logged in, we have to commit the login to memory via creating a user default
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            
            // string: loginToHome is the name of our segue btw login and the next view
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (Error) in
            // tell user that error has occurred
            print("Error, couldn't log in.")
            // set up an alert controller
            let title = "Error"
            let message = "An error has occured. Unable to log-in."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
}
