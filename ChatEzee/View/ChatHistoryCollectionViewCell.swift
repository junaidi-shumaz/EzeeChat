//
//  ChatHistoryCollectionViewCell.swift
//  ChatEzee
//
//  Created by Shumaz Ahamed Junaidi on 6/10/18.
//  Copyright © 2018 Shumaz Ahamed Junaidi. All rights reserved.
//

import UIKit

class ChatHistoryCollectionViewCell: UICollectionViewCell {
    //Contains text message from the users...
    let textView: UITextView = {
       let textview = UITextView()
        textview.text = "Hello"
        textview.font = UIFont.systemFont(ofSize: 16)
        textview.backgroundColor = UIColor.clear
        textview.textColor = .white
        textview.translatesAutoresizingMaskIntoConstraints = false
        return textview
    }()
    //Bubble to hold above textview.........
    let bubble: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(r:0, g: 137, b: 247)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //ImageView to pin images before message bubble...
    let profImageView: UIImageView = {
       let profImg = UIImageView()
        profImg.image = UIImage(named: "prof")
        profImg.translatesAutoresizingMaskIntoConstraints = false
        profImg.layer.cornerRadius = 16
        profImg.layer.masksToBounds = true
        profImg.contentMode = .scaleAspectFill
        return profImg
    }()
    
    
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubble)
        addSubview(textView)
        addSubview(profImageView)
        
        profImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        bubbleRightAnchor = bubble.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleRightAnchor?.isActive = true
        bubbleLeftAnchor = bubble.leftAnchor.constraint(equalTo: profImageView.rightAnchor, constant: 8)
        bubbleLeftAnchor?.isActive = false
        bubble.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubble.widthAnchor.constraint(equalToConstant: 200).isActive = true
        bubble.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
       
        textView.leftAnchor.constraint(equalTo: bubble.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        //textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
