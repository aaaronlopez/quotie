//
//  ViewController.swift
//  QuotieAaron2
//
//  Created by Aaron Lopez on 7/13/17.
//  Copyright © 2017 Aaron Lopez. All rights reserved.
//

import UIKit
import Social
import Branch

class ViewController: UIViewController, UITextFieldDelegate, BranchShareLinkDelegate {

    @IBOutlet weak var quote: UILabel!
    
    @IBOutlet weak var rewardTotal: UITextField!
    @IBOutlet weak var link: UILabel!
    @IBOutlet weak var userIDTextField: UITextField!
    
    var branchUniversalObject: BranchUniversalObject!
    var branchSharedlink: BranchShareLink?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIDTextField.delegate = self;
        updateQuote()
        
        let sessionParams = Branch.getInstance().getLatestReferringParams()
        print("LATEST SESSION PARAMS")
        print(sessionParams)
        if (sessionParams?["quote"]) != nil {
            quote.text = sessionParams?["quote"] as? String
        } else {
            updateQuote()
        }
        
        let firstsessionParams = Branch.getInstance().getFirstReferringParams()
        print("FIRST SESSION PARAMS")
        print(firstsessionParams)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("hi")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let sessionParams = Branch.getInstance().getLatestReferringParams()
        print("SESSION PARAMS")
        print(sessionParams)
        if (sessionParams?["quote"]) != nil {
            quote.text = sessionParams?["quote"] as? String
        } else {
            updateQuote()
        }
        
        let firstsessionParams = Branch.getInstance().getFirstReferringParams()
        print("SESSION PARAMS")
        print(firstsessionParams)
    }
    
    func updateQuote() {
        let newQuote = changeQuote()
        
        branchUniversalObject = BranchUniversalObject()
        branchUniversalObject.title = "ShareSheet"
        branchUniversalObject.contentDescription = "My Content Description"
        branchUniversalObject.imageUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/SNice.svg/1200px-SNice.svg.png"
        //branchUniversalObject.canonicalUrl = "https://facebook.com"
        branchUniversalObject.addMetadataKey("quote", value: newQuote)
        branchUniversalObject.addMetadataKey("$twitter_image_url", value: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/SNice.svg/1200px-SNice.svg.png")
        
        let BUO: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: "item/12345")
        BUO.title = "My Content Title"
        BUO.contentDescription = "My Content Description"
        BUO.imageUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/SNice.svg/1200px-SNice.svg.png"
        BUO.canonicalUrl = "https://facebook.com"
        BUO.addMetadataKey("quote", value: newQuote)
        BUO.addMetadataKey("$twitter_image_url", value: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/SNice.svg/1200px-SNice.svg.png")
        
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.feature = "sharing"
        linkProperties.channel = "facebook"
        BUO.getShortUrl(with: linkProperties) { (url, error) in
            if error == nil {
                print("GETSHORTURL: got my Branch link to share: %@", url!)
                self.link.text = url
            } else {
                print("Error: %@", url!)
            }
        }
        
        branchUniversalObject.registerView()
        quote.text = changeQuote()
    }

    func changeQuote() -> String {
        var quotes: [String] = ["Hi", "Bye", "Goodbye", "Hey"]
        return quotes[Int(arc4random_uniform(UInt32(Int(quotes.count))))]
    }
    
    func refreshRewardsBalanceOfBucket() {
        rewardTotal.isHidden = true
        //activityIndicator.startAnimating()
        let branch = Branch.getInstance()
        branch?.loadRewards { (changed, error) in
            if (error == nil) {
                print("REWARDS")
                if self.rewardTotal.text == "" {
                    print("1")
                    self.rewardTotal.text = String(format: "%ld", (branch?.getCredits())!)
                } else {
                    print("2")
                    self.rewardTotal.text = String(format: "%ld", (branch?.getCreditsForBucket(self.rewardTotal.text))!)
                }
                let credits = Branch.getInstance().getCredits()
                print("credit: \(credits)")

                Branch.getInstance().redeemRewards(5, callback: {(success, error) in
                    if success {
                        print("Redeemed 5 credits!")
                    }
                    else {
                        print("Failed to redeem credits: \(error)")
                    }
                })
                
                Branch.getInstance().redeemRewards(5, forBucket: "myBucket", callback: {(success, error) in
                    if success {
                        print("Redeemed 5 credits for myBucket!")
                    }
                    else {
                        print("Failed to redeem credits: \(error)")
                    }
                })

            }
        }
        //activityIndicator.stopAnimating()
        rewardTotal.isHidden = false
    }
    
    @IBAction func refreshQuote(_ sender: Any) {
        updateQuote()
    }
    
    @IBAction func shareQuote(_ sender: Any) {
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.controlParams = ["$fallback_url_us": "https://facebook.com"]
        linkProperties.feature = "sharing"
        linkProperties.channel = "Facebook"
        linkProperties.addControlParam("custom_data", withValue: "yes")
        
//        branchUniversalObject.showShareSheet(with: linkProperties,
//                                             andShareText: "Super amazing thing I want to share!",
//                                             from: self) { (activityType, completed) in
//                                                NSLog("done showing share sheet!")
//        }
        branchUniversalObject.showShareSheet(with: linkProperties,
                                             andShareText: "Super amazing thing I want to share!",
                                             from: self) { (activityType, completed) in
                                                NSLog("done showing share sheet!")
        }
//        let branchSharedlink = BranchShareLink(universalObject: branchUniversalObject, linkProperties: linkProperties)
//        branchSharedlink?.delegate = self
//        if (branchSharedlink != nil) {
//            branchSharedlink?.presentActivityViewController(from: self, anchor: nil)
//            let items = branchSharedlink?.activityItems()
//            print("\(String(describing: items?.count))")
//        }
    }
    
//    func branchShareLinkWillShare(_ shareLink: BranchShareLink) {
//        print("[WillShare]: \(String(describing: branchSharedlink?.shareURL))")
//        print("[WillShare]: \(String(describing: shareLink.linkProperties))")
//        print("[WillShare]: \(String(describing: shareLink.activityType ?? "No activityType"))")
//        guard let activityType = shareLink.activityType else { return }
//        
//    }
//    
//    func branchShareLink(_ shareLink: BranchShareLink, didComplete completed: Bool, withError error: Error?) {
//        let p = shareLink.activityItems()[0]
//        print("\(String(describing: p.placeholderItem))")
//        print("[ShareLink] URL: \(String(describing: shareLink.shareURL))")
//        print("[ShareLink]: Completed = \(completed)")
//        print("[ShareLink]: Error = \(String(describing: error?.localizedDescription))")
//    }
    
    @IBAction func seeRewards(_ sender: Any) {
        let rewards = Branch.getInstance().getCredits()
        rewardTotal.text = String(rewards)
    }
    
    @IBAction func redeemFiveRewards(_ sender: Any) {
        Branch.getInstance().redeemRewards(5)
    }
    
    @IBAction func setUserID(_ sender: Any) {
        let branch = Branch.getInstance()
        let userID = userIDTextField.text
        branch?.setIdentity(userID)
        print("Set user id")
        refreshRewardsBalanceOfBucket()
    }
    
    @IBAction func triggerCustomEvent(_ sender: Any) {
        Branch.getInstance().userCompletedAction("Test custom event")
        print("Triggered custom event")
    }
    
    @IBAction func triggerTweet(_ sender: Any) {
//        let linkProperties: BranchLinkProperties = BranchLinkProperties()
//        linkProperties.controlParams = ["$fallback_url_us": "https://facebook.com"]
//        linkProperties.feature = "sharing"
//        
//        branchUniversalObject.showShareSheet(with: linkProperties,
//                                             andShareText: "Super amazing thing I want to share!",
//                                             from: self) { (activityType, completed) in
//                                                NSLog("done showing share sheet!")
//        }
        
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
            vc.setInitialText("Look at this great picture!")
            vc.add(URL(string: "https://aaaronlopez.github.io/"))
            
            let url = NSURL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/SNice.svg/1200px-SNice.svg.png")
            let data = NSData(contentsOf: url! as URL)
            
            //vc.add(UIImage(data: data! as Data))
            
            present(vc, animated: true)
        }
    }
}

