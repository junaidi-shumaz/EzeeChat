//
//  ImageCaching.swift
//  ChatEzee
//
//  Created by Shumaz Ahamed Junaidi on 6/1/18.
//  Copyright © 2018 Shumaz Ahamed Junaidi. All rights reserved.
//

import UIKit

let cacheImages = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    
    // Function for caching images downloaded from Firbase server
    func cacheImageFrom(urlString: String){
        // Below line of code show blank area before loading up profile image instead flickering images when scrolled table view
        self.image = nil
        //Quick check to see if images are aready in cache else donload from server
        if let checkCacheForImg = cacheImages.object(forKey: urlString as AnyObject){
            self.image = checkCacheForImg as? UIImage
            return
        }
        
        
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: {(data, response, error) in
            if error != nil{
                print(error!)
                
                // Reading from coredat in case of network failure to enable offline support
                print("-----Network failure reading from Core Data----")
                if let checkCoreDataCacheForImg:NSData = CoreDataOperations.returnCoreDataCacheImage(userID: urlString){
                    let data = checkCoreDataCacheForImg as? NSData
                    ///self.image = UIImage(data: data! as Data)
                    let background = DispatchQueue.main
                    background.async { //async tasks here
                        self.image = UIImage(data: data! as Data)
                    }
                       return
                }
                
                return
            }
            let background = DispatchQueue.main
            background.async { //async tasks here
                if let imageDownloaded = UIImage(data: data!){
                    cacheImages.setObject(imageDownloaded, forKey: urlString as AnyObject)
                    self.image = UIImage(data: data!)
                    ///var newImageData = UIImageJPEGRepresentation(newImageData,1)
                    var newImageData:NSData = data! as NSData
                    CoreDataOperations.UpdateObject(userID: urlString, imageData: newImageData)
                }
                
                /// cell.imageView?.image = UIImage(data: data!)
            }
            
    }).resume()
        
    }
    
}
