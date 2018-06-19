//
//  ChatRoomController.swift
//  ChatEzee
//
//  Created by Shumaz Ahamed Junaidi on 6/3/18.
//  Copyright © 2018 Shumaz Ahamed Junaidi. All rights reserved.
//

import UIKit
import Firebase
class ChatRoomController: UICollectionViewController,UITextFieldDelegate,UICollectionViewDelegateFlowLayout{
    
    var user: Users?
    let composeText: UITextField = {
    let text = UITextField()
    
    text.placeholder = "Enter message..."
    text.translatesAutoresizingMaskIntoConstraints = false
    
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 58, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(8, 0, 58, 0)
        //this line of code to enable pullup/pulldown keyboard within collection view
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView!.register(ChatHistoryCollectionViewCell.self, forCellWithReuseIdentifier: "reuseIdentifier")
        
        let iv = UIImageView()
        iv.image = UIImage(named:"listuserbg")
        iv.contentMode = .scaleAspectFill
        iv.alpha = 0.5
        self.collectionView?.backgroundView = iv
        
        composeText.delegate = self
        if let userName = user?.name{
           navigationItem.title = userName
        }
        
        collectionView?.backgroundColor = UIColor.white
        //These two functions provides a message box with keyboard attached below on tap by observing NotificationCenter feature ...
        ///initializeChatWindowComponents()
        ///captureKeyboardEevents()
        loadUserHistoryWithMessages()
    }
    
    // This will be passed to a fun-> override var inputAccessoryView is a built-in var which
    //accepts UIView type...
    lazy var interactiveMessageArea: UIView = {
        let componentView = UIView()
         componentView.frame = CGRect(x:0,y:0, width: view.frame.width, height:50)
        
            componentView.backgroundColor = UIColor.white
           // componentView.translatesAutoresizingMaskIntoConstraints = false
        
            // adding send message button
            
            let sendButton = UIButton(type: .system)
            sendButton.setTitle("Send", for: .normal)
            sendButton.translatesAutoresizingMaskIntoConstraints = false
            componentView.addSubview(sendButton)
            // Adding constraints to lay component at required location
            sendButton.rightAnchor.constraint(equalTo: componentView.rightAnchor).isActive = true
            sendButton.centerYAnchor.constraint(equalTo:componentView.centerYAnchor).isActive = true
            sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
            sendButton.heightAnchor.constraint(equalTo: componentView.heightAnchor).isActive = true
            sendButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
            // adding compose text field
            
            
            componentView.addSubview(composeText)
            // Adding constraints to lay component at required location
            composeText.leftAnchor.constraint(equalTo: componentView.leftAnchor).isActive = true
            composeText.centerYAnchor.constraint(equalTo:componentView.centerYAnchor).isActive = true
            composeText.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
            composeText.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            let seperatorLine = UIView()
            seperatorLine.backgroundColor = UIColor(r:220, g:220, b:220)
            seperatorLine.translatesAutoresizingMaskIntoConstraints = false
            componentView.addSubview(seperatorLine)
            // Adding constraints to lay component at required location
            seperatorLine.leftAnchor.constraint(equalTo: componentView.leftAnchor).isActive = true
            seperatorLine.topAnchor.constraint(equalTo:componentView.topAnchor).isActive = true
            seperatorLine.widthAnchor.constraint(equalTo: componentView.widthAnchor).isActive = true
            seperatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            return componentView
            
            
    }()
    // These two functions will add UIView into controller at specified co-ordinated and support some basic functionalities which associated with controller...we are using it to attach message box at the top of keyboard and pullup/pulldown feature....
    override var inputAccessoryView: UIView?{
        get{
            
            return interactiveMessageArea
        }
        
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    //Function to load chat history...
    var messageArray = [Messages]()
    func loadUserHistoryWithMessages() {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        // Read root node
        let userMessageMappingRef = Database.database().reference().child("userMessageMapping").child(uid)
        userMessageMappingRef.observe(.childAdded, with: { (snapshot) in
            
            let senderIDFromFIR = snapshot.key
            
            let userMessageMappingKeyRef = Database.database().reference().child("messages").child(senderIDFromFIR)
            userMessageMappingKeyRef.observeSingleEvent(of: .value, with: {(snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let messages = Messages()
                    messages.receiverID = dictionary["receiverID"] as? String
                    messages.senderID = dictionary["senderID"] as? String
                    messages.text = dictionary["text"] as? String
                    messages.timeStamp = dictionary["timeStamp"] as? NSNumber
                    if messages.getActualMappedUserID() == self.user?.id{
                        self.messageArray.append(messages)
                    }
                    /*     let actualChatID: String?
                     if messages.senderID == Auth.auth().currentUser?.uid{
                     print("senderID=\(messages.receiverID)")
                     actualChatID = messages.receiverID
                     }else{
                     print("receiverID=\(messages.senderID)")
                     actualChatID = messages.senderID
                     }
                     */
                    
                    
                    
                    //user.setValueForKeysWithDictionary(dictionary)
                    ///self.messageArray.append(messages)
                    userMessageMappingKeyRef.keepSynced(true)
                    // this will crash because of background thraed
                    //self.tableView.reloadData()
                    // Below code to span a long running thread to avoid app crash
                    let background = DispatchQueue.main
                    background.async { //async tasks here
                        self.collectionView?.reloadData()
                        
                        
                    }
                    
                }
                
                
            }, withCancel: nil)
            
            
        }, withCancel: nil)
        
    }
    
    //Function to capture all events occured in this view and filtering out to listen keyboard events
    //Below two are unused function but can be enabled by uncommenting the call in didappear function....
    //These functions keyboard attached below and observing NotificationCenter feature ...
    //----------------------------------
    func captureKeyboardEevents(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeHide), name: .UIKeyboardWillHide, object: nil)
        

    }
    @objc func keyboardWillChange(notification: NSNotification) {
       
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardDuration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
        ///print("Key board height----\(targetFrame.height)")
        componentViewBottomAnchor?.constant = CGFloat(-targetFrame.height)
    }
    @objc func keyboardWillChangeHide(notification: NSNotification) {
        
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardDuration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
        ///print("Key board height----\(targetFrame.height)")
        componentViewBottomAnchor?.constant = 0
    }
    // Releasing all observer as soon as the view diappears to avoid memory leak...
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    ///--------------------------------------
    //Following message is to invalidate the view to support orientation layout...
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as? ChatHistoryCollectionViewCell
        let messages = messageArray[indexPath.row]
        cell?.textView.text = messages.text
        
        setupMessageBubbleBasedOnUser(cell: cell!, messages:messages)
        
        return cell!
        
    }
    
    //Following function will set the message bubbles background colour based on user id
    func setupMessageBubbleBasedOnUser(cell:ChatHistoryCollectionViewCell, messages:Messages){
        if let profImageURL = self.user?.profileImage{
            cell.profImageView.cacheImageFrom(urlString: profImageURL)
        }
        if messages.receiverID == Auth.auth().currentUser?.uid{
            /// logged-in user message will be shown in blue bubble
            cell.bubble.backgroundColor = UIColor(r:0, g: 137, b: 247)
            //following lines will hide the profile image before bubble as this section of code
            //belongs to the user loogedin use chat messages...
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
            cell.profImageView.isHidden = true
        }else{
            cell.bubble.backgroundColor = UIColor(r:240, g: 240, b: 240)
            cell.textView.textColor = UIColor.black
            
            //following lines will pull the bubble to the left side and pin with profile image
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
            cell.profImageView.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        if let text = messageArray[indexPath.item].text{
            height = getHeightBasedFromMsgText(text: text).height + 20
            ///print("height---\(height)")
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func getHeightBasedFromMsgText(text: String)->CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    // Function to create and lay chat window components like compose message text box and send button...
    var componentViewBottomAnchor: NSLayoutConstraint?
    
    
    //Unused function but can be enabled by uncommenting the call in didappear function....
    // Content from this is moved above to support keyboard pullup/pulldown functionalities...
    func initializeChatWindowComponents(componentView: UIView){
        //let componentView = UIView()
        componentView.backgroundColor = UIColor.white
        componentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(componentView)
        
        // Adding constraints to lay component at required location
        componentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        componentViewBottomAnchor = componentView.bottomAnchor.constraint(equalTo:view.bottomAnchor)
        componentViewBottomAnchor?.isActive = true
        componentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        componentView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // adding send message button
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        componentView.addSubview(sendButton)
        // Adding constraints to lay component at required location
        sendButton.rightAnchor.constraint(equalTo: componentView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo:componentView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: componentView.heightAnchor).isActive = true
        sendButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        // adding compose text field
        
        
        componentView.addSubview(composeText)
        // Adding constraints to lay component at required location
        composeText.leftAnchor.constraint(equalTo: componentView.leftAnchor).isActive = true
        composeText.centerYAnchor.constraint(equalTo:componentView.centerYAnchor).isActive = true
        composeText.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        composeText.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let seperatorLine = UIView()
        seperatorLine.backgroundColor = UIColor(r:220, g:220, b:220)
        seperatorLine.translatesAutoresizingMaskIntoConstraints = false
        componentView.addSubview(seperatorLine)
        // Adding constraints to lay component at required location
        seperatorLine.leftAnchor.constraint(equalTo: componentView.leftAnchor).isActive = true
        seperatorLine.topAnchor.constraint(equalTo:componentView.topAnchor).isActive = true
        seperatorLine.widthAnchor.constraint(equalTo: componentView.widthAnchor).isActive = true
        seperatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        
    }
    //function to send chat messages...
    @objc func handleSendMessage(){
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let receiverID = user?.id
        let senderID = Auth.auth().currentUser?.uid
        ///let timeStamp = NSNumber(NSDate().timeIntervalSince1970)
        let timestamp: Int32 = Int32(NSDate().timeIntervalSince1970)
        let values = ["text": composeText.text!, "receiverID": receiverID!, "senderID": senderID!, "timeStamp": timestamp] as [String : Any]
        ///childRef.updateChildValues(values)
        childRef.updateChildValues(values, withCompletionBlock: {(error, ref) in
            if error != nil{
                print(error!)
                return
            }
            
            let userMessageReferenceSender = Database.database().reference().child("userMessageMapping").child(senderID!)
            let messageKeyFromABove = childRef.key
            let msgValues = [messageKeyFromABove: 1]
            userMessageReferenceSender.updateChildValues(msgValues)
            
            let userMessageReferenceReceiver = Database.database().reference().child("userMessageMapping").child(receiverID!)
            let messageKeyFromABoveReceiver = childRef.key
            let msgValuesReceiver = [messageKeyFromABoveReceiver: 1]
            userMessageReferenceReceiver.updateChildValues(msgValuesReceiver)
            
            self.composeText.text = ""
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSendMessage()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
