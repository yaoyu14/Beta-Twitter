//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Yao Yu on 3/3/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArr = [NSDictionary]()
    var numOfTweets: Int!
    @IBOutlet var tweetTable: UITableView!
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        self.tweetTable.rowHeight = UITableView.automaticDimension
        self.tweetTable.estimatedRowHeight = 150
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTweets()
    }
    
    @objc func loadTweets() {
        
        numOfTweets = 20
        let params = ["count": numOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: "https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: params, success: { (tweets: [NSDictionary]) in
            
            self.tweetArr.removeAll()
            for tweet in tweets {
                self.tweetArr.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Could not retreive tweets.")
        })
    }
    
    func loadMoreTweets() {
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        numOfTweets = numOfTweets + 20
        let params = ["count": numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: "https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: params, success: { (tweets: [NSDictionary]) in
            
            self.tweetArr.removeAll()
            for tweet in tweets {
                self.tweetArr.append(tweet)
            }
            
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("Could not retreive tweets.")
        })
        
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArr.count {        // when the user get to the end of a table view
            loadMoreTweets()
        }
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
                
        let user = tweetArr[indexPath.row]["user"] as! NSDictionary
        
        cell.usernameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArr[indexPath.row]["text"] as? String
        cell.timeLabel.text = getTime(timeString: (tweetArr[indexPath.row]["created_at"] as! String))
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as! String))
        
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
    cell.setLike(tweetArr[indexPath.row]["favorited"] as! Bool)
    cell.setRetweet(tweetArr[indexPath.row]["retweeted"] as! Bool)
    cell.tweetID = tweetArr[indexPath.row]["id"] as! Int
        
        
        
        return cell
    }
    
    func getTime(timeString: String) -> String{
        let time: Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        time = dateFormatter.date(from: timeString)!
        return time.timeAgoDisplay()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArr.count
    }
    


}
extension Date {
      func timeAgoDisplay() -> String {
          let secondsAgo = Int(Date().timeIntervalSince(self))
          let minute = 60
          let hour = 60 * minute
          let day = 24 * hour
          let week = 7 * day
          if secondsAgo < minute {
              return "\(secondsAgo) sec ago"
          } else if secondsAgo < hour {
              return "\(secondsAgo / minute) min ago"
          } else if secondsAgo < day {
              return "\(secondsAgo / hour) hr ago"
          } else if secondsAgo < week {
              return "\(secondsAgo / day) day(s) ago"
          }
          return "\(secondsAgo / week) week(s) ago"
      }
  }
