//
//  UserCell.swift
//  ChatEzee
//
//  Created by Shumaz Ahamed Junaidi on 6/4/18.
//  Copyright © 2018 Shumaz Ahamed Junaidi. All rights reserved.
//

import UIKit
import Firebase
// Following class customize table view cell to accommodate image & text label...

class UserCell: UITableViewCell{
    
    var messages: Messages?{
        didSet{
        /*    let actualChatProfileImage: String?
            if messages?.senderID == Auth.auth().currentUser?.uid{
                print("senderID=\(messages?.receiverID)")
                actualChatProfileImage = messages?.receiverID
            }else{
                print("receiverID=\(messages?.senderID)")
                actualChatProfileImage = messages?.senderID
            }
 */
            if let receiverID = messages?.getActualMappedUserID() {
                let ref = Database.database().reference().child("users").child(receiverID)
                ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                        self.textLabel?.text =  dictionary["name"] as? String
                        //cell.imageView?.image = UIImage(named: "prof")
                        
                        if let profileImageUrl = dictionary["profileImageUrl"] as? String{
                            
                            // Call extension of ImageView to perform caching of downloaded images from the server using NSCACHE
                            
                            self.profileImageView.cacheImageFrom(urlString: profileImageUrl)
                            
                            
                        }
                    }
                })
                
            }
            detailTextLabel?.text = messages?.text
            if let seconds = messages?.timeStamp?.doubleValue {
                let timeStampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "hh:mm:ss a"
                timeStamp.text =  dateFormat.string(from: timeStampDate as Date) 
            }
            
        }
    }
    
    
    //aligning text labels within cell
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x: 64, y: (detailTextLabel?.frame.origin.y)! + 2 , width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
        
        
        
    }
    
    // Customizing table cell to align profile image with rounded corners
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //Time stampinside cell
    let timeStamp: UILabel = {
        let label = UILabel()
       /// label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeStamp)
        
        //Constraints for image within table cell x,y,width,height
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        //Constraints for timeStamp within table cell x,y,width,height
        timeStamp.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        timeStamp.centerYAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        timeStamp.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeStamp.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
