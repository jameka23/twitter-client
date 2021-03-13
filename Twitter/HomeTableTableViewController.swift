//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Jameka Echols on 3/7/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableTableViewController: UITableViewController {

    //store tweets in local container
    var tweetArray = [NSDictionary]() //array of dictionaries
    var numberOfTweets: Int!
    let myRefreshControl = UIRefreshControl()
    var userPic: Any!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTweets()
        
        // reload; spinner
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadTweets()
        
    }
    
    func loadMoreTweets(){
        // get more tweets; infinite scroll
        
        let myUrl = "https://api.twitter.com/1.1/statuses/user_timeline?screen_name=hashtagcoder1.json"
        numberOfTweets = numberOfTweets + 20
        
        let params = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: params,  success: { (tweets: [NSDictionary]) in
            //clean and repopulate
            self.tweetArray.removeAll()

            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("Could not retrieve tweet!")
        })
    }
    
    
    @objc func loadTweets(){
        numberOfTweets = 30
        
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        //let url = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let params = ["count": numberOfTweets]

        
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params, success: { (tweets: [NSDictionary]) in
            //clean and repopulate
            self.tweetArray.removeAll()

            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retrieve tweet! \(Error)")
        })
        
        
    }
    
    override func tableView(_ tableView:UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath:IndexPath){
        
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    
    @IBAction func OnLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        
        //screen will dismiss; disapper
        self.dismiss(animated: true, completion:nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCellTableViewCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        print(user)
        userPic = URL(string: (user["profile_image_url_https"] as? String)!)
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorited(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        return cell
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

    

}
