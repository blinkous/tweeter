//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by stargaze on 3/1/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    // Get the tweets
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    // Adding the refresh control
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        
        // Refreshes the tweets
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    // Loading the tweets
    @objc func loadTweets(){
        
        numberOfTweets = 20
        
        // Call the API
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        // Only pull numberOfTweets tweets
        let myParam = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParam as [String : Any], success: { (tweets: [NSDictionary]) in
            
            // Clean the array before we add the tweets to it, we don't want the old list
            self.tweetArray.removeAll()
            
            // Add the tweets to our local array
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            
            //Stop refreshing: makes sure the refresh button doesn't stay forever
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets! oh noooo!!!")
        })
    }
    
    // Implement the inifinite scroll: Load the older tweets
    func loadMoreTweets(){
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        // Increasing num of tweets
        numberOfTweets += 20
        
        let myParam = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParam as [String : Any], success: { (tweets: [NSDictionary]) in
            
            // Clean the array before we add the tweets to it, we don't want the old list
            self.tweetArray.removeAll()
            
            // Add the tweets to our local array
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets! oh noooo!!!")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        // Dismiss the view when the user clicks the logout button
        self.dismiss(animated: true, completion: nil)
        
        // Set the default for "userLoggedIn" to false so that the user is no longer automatically logged in
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows for the tweets
        return tweetArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.usernameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        // Setting the image
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageURL!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }

}
