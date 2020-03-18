//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Yao Yu on 3/3/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var liked: Bool = false
    var tweetID: Int = -1
    
    func setLike(_ isliked: Bool) {
        liked = isliked
        if (liked) {
            likeButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else {
            likeButton.setImage(UIImage(named: "favor-icon-1"), for: UIControl.State.normal)
        }
    }
    
    func setRetweet(_ isretweeted: Bool) {
        if (isretweeted) {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        }
        else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
 
    @IBAction func likeTweet(_ sender: Any) {
        let toBeLiked = !liked
        if (toBeLiked) {
            TwitterAPICaller.client?.likeTweet(tweetID: tweetID, success: {
                self.setLike(true)
            }, failure: { (error) in
                print("Like did not succeed: \(error)")
            })
        }
        else {
            TwitterAPICaller.client?.unlikeTweet(tweetID: tweetID, success: {
                self.setLike(false)
            }, failure: { (error) in
                print("Unlike did not succeed: \(error)")
            })
        }
    }
    
    
    @IBAction func retweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetID: tweetID, success: {
            self.setRetweet(true)
        }, failure: { (error) in
            print("Retweet did not succeed: \(error)")
        })
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
