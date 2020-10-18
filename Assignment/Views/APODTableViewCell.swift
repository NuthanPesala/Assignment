//
//  APODTableViewCell.swift
//  Assignment
//
//  Created by Nuthan Raju Pesala on 17/10/20.
//  Copyright © 2020 NuthanRaju. All rights reserved.
//

import UIKit

class APODTableViewCell: UITableViewCell {

    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var object: APOD? {
        didSet {
            if let object = self.object {
                if object.media_type == "image" {
                    self.pictureView.downloadImageFromUrl(urlString: object.url )
            }else {
                    let url = URL(string: object.url)
                    self.pictureView.thumbnailImageForVideoUrl(url: url!)
            }
                self.dateLabel.text = "Published On: \(String(describing: object.date))"
                self.descriptionLabel.text = object.description
                self.titleLabel.text = object.title
            }
        }
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


