//
//  ViewController.swift
//  ChatEzee
//
//  Created by Shumaz Ahamed Junaidi on 5/23/18.
//  Copyright © 2018 Shumaz Ahamed Junaidi. All rights reserved.
//

import UIKit
import Firebase
class MessageViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "WriteIcon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessages))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        self.displayCurrentUser()
        
       
    }
    var messageArray = [Messages]()
    var messageDictionary = [String: Messages]()
    //function to construct the messages sent by users and list all of them into table VC of message Controller
    func watchMessages(){
        guard let senderID = Auth.auth().currentUser?.uid else{
            return
        }
        
        
        
        
        // Read root node
        let userMessageMappingRef = Database.database().reference().child("userMessageMapping").child(senderID)
        userMessageMappingRef.observe(.childAdded, with: { (snapshot) in
            
            let senderIDFromFIR = snapshot.key
            
            let userMessageMappingKeyRef = Database.database().reference().child("messages").child(senderIDFromFIR)
            userMessageMappingKeyRef.observeSingleEvent(of: .value, with: {(snapshot) in
                print("snapshot key------\(snapshot)")
                
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                        let messages = Messages()
                        messages.receiverID = dictionary["receiverID"] as? String
                        messages.senderID = dictionary["senderID"] as? String
                        messages.text = dictionary["text"] as? String
                        messages.timeStamp = dictionary["timeStamp"] as? NSNumber
                        
                   /*     let actualChatID: String?
                        if messages.senderID == Auth.auth().currentUser?.uid{
                            print("senderID=\(messages.receiverID)")
                            actualChatID = messages.receiverID
                        }else{
                            print("receiverID=\(messages.senderID)")
                            actualChatID = messages.senderID
                        }
                      */
                        if let recId = messages.getActualMappedUserID(){
                            self.messageDictionary[recId] = messages
                            self.messageArray = Array(self.messageDictionary.values)
                            self.messageArray.sort(by: { (Message1, Message2) -> Bool in
                                return (Message1.timeStamp?.intValue)! > (Message2.timeStamp?.intValue)!
                            })
                        }
                        
                        
                        //user.setValueForKeysWithDictionary(dictionary)
                        ///self.messageArray.append(messages)
                        userMessageMappingKeyRef.keepSynced(true)
                        // this will crash because of background thraed
                        //self.tableView.reloadData()
                        // Below code to span a long running thread to avoid app crash
                        let background = DispatchQueue.main
                        background.async { //async tasks here
                            self.tableView.reloadData()
                            
                            
                        }
                        
                    }
                    
                    
                }, withCancel: nil)
            
            
        }, withCancel: nil)
        
        /*
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let messages = Messages()
                messages.receiverID = dictionary["receiverID"] as? String
                messages.senderID = dictionary["senderID"] as? String
                messages.text = dictionary["text"] as? String
                messages.timeStamp = dictionary["timeStamp"] as? NSNumber
                if let recId = messages.receiverID{
                    self.messageDictionary[recId] = messages
                    self.messageArray = Array(self.messageDictionary.values)
                    self.messageArray.sort(by: { (Message1, Message2) -> Bool in
                        return (Message1.timeStamp?.intValue)! > (Message2.timeStamp?.intValue)!
                    })
                }
                
                
                //user.setValueForKeysWithDictionary(dictionary)
                ///self.messageArray.append(messages)
                ref.keepSynced(true)
                // this will crash because of background thraed
                //self.tableView.reloadData()
                // Below code to span a long running thread to avoid app crash
                let background = DispatchQueue.main
                background.async { //async tasks here
                    self.tableView.reloadData()
                    
                    
                }
                
            }
            
        } ) */
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "tablebg")
        
        let imageView = UIImageView(image: backgroundImage)
        imageView.alpha = 0.4
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = imageView
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Need to use dequeue to achieve memory efficiency...
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! UserCell
        let messages = messageArray[indexPath.row]
        cell.messages = messages
        
        //cell.detailTextLabel?.text = messages.text
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    //function to display new messages view controller to initiate chat
    @objc func handleNewMessages(){
        let newMessageVC = NewMessagesTableViewController()
        let navigationController = UINavigationController(rootViewController: newMessageVC)
        present(navigationController, animated: true, completion: nil)
    }
    
    
    ///var messageController: MessageViewController
    //function to navigate to chat room view controller...
    func navigateCharRoomController(user: Users){
        let chatRoomVC = ChatRoomController(collectionViewLayout: UICollectionViewFlowLayout())
        chatRoomVC.user = user
        navigationController?.pushViewController(chatRoomVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageData = self.messageArray[indexPath.row]
        let actualMessageID = messageData.getActualMappedUserID(); Database.database().reference().child("users").child(actualMessageID!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                ///print("UID------\(dictionary)");
                ///self.navigationItem.title = dictionary["name"] as? String
                let user = Users()
                user.id = actualMessageID
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImage = dictionary["profileImageUrl"] as? String
                self.navigateCharRoomController(user: user)
            }
        }, withCancel: nil)
        
        
    }
    
    // function to display current logged in user...
    func displayCurrentUser(){
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
        }else{
            setNameOnNavigationBar()
        }
    }
    
    //observer single event with UID as child will fetch the user datails of currenlty logged in user
    func setNameOnNavigationBar(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                ///print("UID------\(dictionary)");
                ///self.navigationItem.title = dictionary["name"] as? String
                let user = Users()
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImage = dictionary["profileImageUrl"] as? String
                self.setIconWithUserNameOnNanigationBar(user: user)
            }
        }, withCancel: nil)
    }
    
    func setIconWithUserNameOnNanigationBar(user: Users){
        
        messageArray.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        watchMessages()
        let titleView = UIView()
        titleView.frame = CGRect(x:0, y:0, width:100, height:40)
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        if let profileImageUrl = user.profileImage {
            profileImageView.cacheImageFrom(urlString: profileImageUrl)
        }
        titleView.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        titleView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    
    
    
    //Handle signout onclick of Logout
    @objc func handleLogout(){
        
        do{
            try Auth.auth().signOut()
        }catch let logoutError{
            print(logoutError)
        }
        let loginController = LoginRegisterViewController()
        loginController.messageVC = self
        present(loginController, animated: true, completion: nil)
    }
   

}

