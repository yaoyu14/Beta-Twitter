//
//  TweetViewController.swift
//  Twitter
//
//  Created by Yao Yu on 3/9/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.becomeFirstResponder()
        
        charRemain.text = "140"

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var tweetTextView: UITextView!
    
    @IBOutlet weak var charRemain: UILabel!
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: Any) {
        
        if(!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Error posting tweet \(error)")
                self.dismiss(animated: true, completion: nil)
            })
        }
        else {
            let alert = UIAlertController(title: "Tweet cannot be empty!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let characterLimit = 140
        let charsInTextView = -tweetTextView.text.count
        let remainingChar = characterLimit + charsInTextView
        
        if remainingChar < 0 {
            let alert = UIAlertController(title: "Too many words in tweet!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func checkRemainingChar() {
        
        let characterLimit = 140
        let charsInTextView = -tweetTextView.text.count
        let remainingChar = characterLimit + charsInTextView
        charRemain.text = String(remainingChar)
        
        if remainingChar <= 10 {
            charRemain.textColor = UIColor.red
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkRemainingChar()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
