//
//  DetailTableViewController.swift
//  Assignment
//
//  Created by Nuthan Raju Pesala on 17/10/20.
//  Copyright © 2020 NuthanRaju. All rights reserved.
//

import UIKit
import SafariServices

class DetailTableViewController: UITableViewController {
    // IBOUTLETS
    @IBOutlet weak var picView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var object: APOD?
    
    let expandImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Details"
        self.navigationItem.largeTitleDisplayMode = .never
        self.tableView.tableFooterView = UIView()
   
        if let object = self.object {
            if object.media_type == "image" {
                self.picView.downloadImageFromUrl(urlString: object.url )
                let gesture = UITapGestureRecognizer(target: self, action: #selector(handleExpandView))
                self.picView.addGestureRecognizer(gesture)
                self.playButton.isHidden = true
            }else {
                let url = URL(string: object.url)
                self.picView.thumbnailImageForVideoUrl(url: url!)
                self.playButton.isHidden = false
            }
            self.dateLabel.text = "\(String(describing: object.date))"
            self.descLabel.text = object.description
            self.titleLabel.text = object.title
        }
        self.initialSetup()
      
    }
    
    func initialSetup() {
        self.playButton.backgroundColor = UIColor.lightGray
        self.playButton.tintColor = UIColor.white
        self.expandImage.isHidden = true
        self.view.addSubview(expandImage)
        expandImage.frame = UIScreen.main.bounds
        expandImage.backgroundColor = UIColor.black
        expandImage.contentMode = .scaleAspectFit
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissView))
        expandImage.addGestureRecognizer(tapGesture)
        self.picView.isUserInteractionEnabled = true
        
        //Play Button Method
        self.playButton.addTarget(self, action: #selector(handlePlayBtn), for: .touchUpInside)
    }
    
    // On click of Image View ...View will enlarge
    @objc func handleExpandView() {
        if self.expandImage.isHidden == true {
            self.expandImage.isHidden = false
            self.expandImage.image = self.picView.image
            self.navigationController?.isNavigationBarHidden = true
        }else {
            self.expandImage.isHidden = true
            self.navigationController?.isNavigationBarHidden = false
        }
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
    // Enlarge View will dismiss
    @objc func handleDismissView() {
        if self.expandImage.isHidden == true {
            self.expandImage.isHidden = false
        }else {
            self.expandImage.isHidden = true
            self.navigationController?.isNavigationBarHidden = false
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    // IBACTION
    @objc func handlePlayBtn() {
        if let object = self.object {
            let url = URL(string: object.url)
            self.playInYoutube(url: url!)
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 300
    }

    // If media_type is Video ..it takes you to safari browser there you can see video
    func playInYoutube(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            // redirect to app
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else  {
            // redirect to safari browser
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
}
