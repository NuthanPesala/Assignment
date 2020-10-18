//
//  ExtensionOfUIImageView.swift
//  Assignment
//
//  Created by Nuthan Raju Pesala on 18/10/20.
//  Copyright © 2020 NuthanRaju. All rights reserved.
//

import UIKit
import AVFoundation


let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    // Getting Image From image Url
    func downloadImageFromUrl(urlString: String) {
        
        self.image = nil
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        if let imgData = try? Data(contentsOf: URL(string: urlString)!) {
            do {
                DispatchQueue.main.async {
                    guard let imageToCache = UIImage(data: imgData) else { return }
                    imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    self.image = imageToCache
                }
            }
        }
    }
    // Creating thumbnail Image from Video Url
    func thumbnailImageForVideoUrl(url: URL)  {

        let asset = AVAsset(url: url)
        let assestGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        do {
            let thumbnailCgImage = try assestGenerator.copyCGImage(at: time, actualTime: nil)
            self.image = UIImage(cgImage: thumbnailCgImage)
        }catch {
            print("error")
        }
       
    }
    
}
