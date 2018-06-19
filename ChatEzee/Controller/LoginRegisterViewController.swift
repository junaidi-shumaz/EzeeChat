//
//  LoginRegisterViewController.swift
//  ChatEzee
//
//  Created by Shumaz Ahamed Junaidi on 5/23/18.
//  Copyright © 2018 Shumaz Ahamed Junaidi. All rights reserved.
//

import UIKit
import Firebase
class LoginRegisterViewController: UIViewController {
    var messageVC: MessageViewController?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    let showActivityIndicator: UIActivityIndicatorView = {
        
        
        var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x:0.0, y:0.0, width:40.0, height:40.0);
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        
        return actInd
    }()
    
    
    // Custom view to hold text fields...
    let helpView: UILabel = {
        // Instantiate UIView and set the background color to white
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "New To EzeeChat"
        view.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // Following two lines of code is for rounded corner view
       // view.font = UIFont.boldSystemFont(ofSize: 25)
        view.font = UIFont(name: "verdana", size: 15)
        view.font = UIFont.italicSystemFont(ofSize: 15)
        
        return view
    }()
    
    // Custom view to hold text fields...
    let helpViewtext2: UILabel = {
        // Instantiate UIView and set the background color to white
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Trouble Logging In ?"
        view.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // Following two lines of code is for rounded corner view
        // view.font = UIFont.boldSystemFont(ofSize: 25)
        view.font = UIFont(name: "verdana", size: 15)
        view.font = UIFont.italicSystemFont(ofSize: 15)
        
        return view
    }()
    
    // Application name logo display
    //Profile image
     var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    let appName: UILabel = {
       
        let name = UILabel()
        name.text = "ChatEzee.."
        name.textColor = UIColor.white
       // name.font = UIFont(name: "arial", size: 26.0)
       // name.font = UIFont.boldSystemFont(ofSize: 26)
        name.font = UIFont(name: "verdana", size: 26)
        ///name.font = UIFont.italicSystemFont(ofSize: 26)
        name.font = UIFont.boldSystemFont(ofSize: 26)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        return name
    }()
    
    // Registration button...
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r:0, g:128, b:255)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLoginOrRegistration), for: .touchUpInside)
        return button
    }()
    
    //login username text fields
    let userNameField: UITextField = {
        let username = UITextField()
        username.placeholder = "Name"
        username.translatesAutoresizingMaskIntoConstraints = false
        return username
    
    }()
    //Seperator for each textfield
    let userNameSeperator: UIView = {
            let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //login email text fields
    let emailField: UITextField = {
        let email = UITextField()
        email.placeholder = "Email"
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
        
    }()
    //Seperator for email textfield
    let emailSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //login password text fields
    let passwordField: UITextField = {
        let password = UITextField()
        password.placeholder = "Password"
        password.translatesAutoresizingMaskIntoConstraints = false
        password.isSecureTextEntry = true
        return password
        
    }()
    //Seperator for password textfield
    let passwordSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //Profile image
   lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "prof")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImageSelection)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
   
   
    
    //Toggle tab for login and register
    let loginRegisterTab: UISegmentedControl = {
        let segments = UISegmentedControl(items: ["Login","Register"])
        segments.translatesAutoresizingMaskIntoConstraints = false
        segments.tintColor = UIColor.white
        segments.selectedSegmentIndex = 1
        segments.addTarget(self, action: #selector(handleSegmentToggle), for: .valueChanged)
        return segments
    }()
    
    let activityView:UIView = {
        var loadingView: UIView = UIView()
        //loadingView.frame = CGRect(x:0, y:0, width:80, height:80)
        ///loadingView.backgroundColor = UIColor(white: 0x444444, alpha: 0.7)
        loadingView.backgroundColor = UIColor.blue
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        loadingView.layer.masksToBounds = true
        
        return loadingView
    }()
    //function to display activity indicator
    func showActivityInd(){
        
        activityView.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        activityView.widthAnchor.constraint(equalToConstant:80).isActive = true
        activityView.heightAnchor.constraint(equalToConstant:80).isActive = true
        ///activityView.addSubview(showActivityIndicator)
        
    }
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var loadingView: UIView = UIView()
    
    
    func showActivityIndicatory(uiView: UIView) {
        actInd.frame = CGRect(x:0.0, y:0.0, width:40.0, height:40.0);
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        
        loadingView.frame = CGRect(x:0, y:0, width:80, height:80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.lightGray
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        actInd.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        
        loadingView.addSubview(actInd)
        ///container.addSubview(loadingView)
        uiView.addSubview(loadingView)
        
        
        
        
        loadingView.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: loginView.centerYAnchor).isActive = true
        
        loadingView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        actInd.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        actInd.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        
        actInd.widthAnchor.constraint(equalToConstant: 50).isActive = true
        actInd.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        actInd.startAnimating()
    }
    func stopActivity(){
        actInd.stopAnimating()
        loadingView.removeFromSuperview()
        
    }
    //function to toggle view between login and registration panel...
    var loginViewHeightAnchor: NSLayoutConstraint?
    var userNameHeightAnchor: NSLayoutConstraint?
    var emailHeightAnchor: NSLayoutConstraint?
    var passwordHeightAnchor: NSLayoutConstraint?
    
    @objc func handleSegmentToggle(){
        let title = loginRegisterTab.titleForSegment(at: loginRegisterTab.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //change the size of a view on toggle
        loginViewHeightAnchor?.constant = loginRegisterTab.selectedSegmentIndex == 0 ? 100 : 150
    
        //hide user nametext field on click login tab
        userNameHeightAnchor?.isActive = false
        userNameHeightAnchor = userNameField.heightAnchor.constraint(equalTo: loginView.heightAnchor, multiplier: loginRegisterTab.selectedSegmentIndex == 0 ? 0 : 1/3)
        userNameHeightAnchor?.isActive = true
        
        //align email field in absence of user name inside view
        emailHeightAnchor?.isActive = false
        emailHeightAnchor = emailField.heightAnchor.constraint(equalTo: loginView.heightAnchor, multiplier: loginRegisterTab.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailHeightAnchor?.isActive = true
        
        //align password field in absence of user name inside view
        passwordHeightAnchor?.isActive = false
        passwordHeightAnchor = passwordField.heightAnchor.constraint(equalTo: loginView.heightAnchor, multiplier: loginRegisterTab.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordHeightAnchor?.isActive = true
    
    }
    //function to decide which program to run login or registration
    @objc func handleLoginOrRegistration(){
        showActivityIndicatory(uiView: view)
        if loginRegisterTab.selectedSegmentIndex == 0 {
            handleLogin()
        }else{
            handleRegistration()
        }
    }
    
    
    
    //function to handle user login
    func handleLogin(){
        guard let email = emailField.text, let password = passwordField.text else {
            print("Invalid input...")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
            if error != nil{
                print("----****Error Logging In***\(error!)")
                self.stopActivity()
                return
            }
            self.messageVC?.setNameOnNavigationBar()
            self.stopActivity()
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    //function to handle user registration on to firebase
    @objc func handleRegistration(){
        guard let email = emailField.text, let password = passwordField.text, let name = userNameField.text else {
            print("Invalid input...")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user: User?, error) in
            if error != nil{
                print(error!)
                return
            }
            
            guard let uid = user?.uid else{
                return
            }
            //successful authenticated user...
            let imageName = NSUUID().uuidString
            let profileImageStorage = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let storageData = UIImageJPEGRepresentation(self.profileImage.image!, 0.1){
                profileImageStorage.putData(storageData, metadata:nil, completion:{(metadata,error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    // Passing just image uid to achieve firebase offline support for images
                    if let profileImgURL = metadata?.downloadURL()?.absoluteString{
                        ///print("metadata---\(metadata?.downloadURL())")
                        let nodeValues = ["name": name, "email":email, "profileImageUrl":profileImgURL]
                        self.registerUserInDBWithUID(uid: uid, nodeValues: nodeValues as [String : AnyObject])
                    }
                    
                })
            }
        })
    }
    
    private func registerUserInDBWithUID(uid: String, nodeValues: [String: AnyObject]){
        let ref = Database.database().reference(fromURL: "https://ezeechat-c9a07.firebaseio.com/")
        // to create user child node...
        let userRef = ref.child("users").child(uid)
        
        userRef.updateChildValues(nodeValues, withCompletionBlock: {(err, ref) in
            if err != nil{
                print(err!)
                return
            }
            ///self.messageVC?.setNameOnNavigationBar()
            ///print("-------\(String(describing: nodeValues["name"]))")
            ///self.messageVC?.navigationItem.title = nodeValues["name"] as? String
            let user = Users()
            user.name = nodeValues["name"] as? String
            user.email = nodeValues["email"] as? String
            user.profileImage = nodeValues["profileImageUrl"] as? String
            self.messageVC?.setIconWithUserNameOnNanigationBar(user: user)
            self.dismiss(animated: true, completion: nil)
            print("User Successfully Saved into Firebase...")
        })
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Pass values to the color extension to display blue login screen
        
        ///view.backgroundColor = UIColor(r: 255, g: 9, b: 9)
       /// view.backgroundColor = UIColor(patternImage: UIImage(named: "loginbg.png")!)
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        
        backgroundImage.image = UIImage(named: "loginbg.png")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        backgroundImage.alpha = 0.4
        view.insertSubview(backgroundImage, at: 0)
        //Adding activity indicator
        ///view.addSubview(activityView)
       // view.addSubview(showActivityIndicator)
        //Adding app label/name
        view.addSubview(appName)
        ///view.addSubview(logoImage)
        view.addSubview(helpView)
        view.addSubview(helpViewtext2)
        //adding login view to the main view controller
        view.addSubview(loginView)
        // adding button to the view
        view.addSubview(loginRegisterButton)
        // adding user profile image view to the custom controller view
        view.addSubview(profileImage)
        // adding tab view support
        view.addSubview(loginRegisterTab)
        // function call to lay app name
        setAppNameLogo()
        // we need x,y,width & height constraints
        setUpLoginRegView()
        // function call to lay registration button
        setupRegisterButton()
        // function call to lay image view for profile image
        setupProfileImage()
        // function call to lay segmented control/tab view
        setLoginRegisterTab()
        
        
    }
    
    
    func setAppNameLogo(){
        // App name co-ordinates...
        appName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appName.bottomAnchor.constraint(equalTo: profileImage.topAnchor, constant: -12).isActive = true
        //appName.widthAnchor.constraint(equalTo: loginView.widthAnchor).isActive = true
        //appName.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
   /*     //Logo co-ordinates
        logoImage.centerXAnchor.constraint(equalTo: appName.leftAnchor, constant: -30).isActive = true
        logoImage.bottomAnchor.constraint(equalTo: profileImage.topAnchor, constant: -12).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
     */
        //help text at bottom co-ordinates
        helpView.centerXAnchor.constraint(equalTo: loginView.centerXAnchor, constant: -60).isActive = true
        helpView.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 20).isActive = true
        helpView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        helpView.heightAnchor.constraint(equalToConstant: 50).isActive = true
 
      
        //help text 2 at bottom co-ordinates
        helpViewtext2.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 120).isActive = true
        helpViewtext2.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 20).isActive = true
        helpViewtext2.widthAnchor.constraint(equalToConstant: 200).isActive = true
        helpViewtext2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    //function to set Login/Register tabs on UI
    func setLoginRegisterTab(){
        
        loginRegisterTab.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterTab.bottomAnchor.constraint(equalTo: loginView.topAnchor, constant: -12).isActive = true
        loginRegisterTab.widthAnchor.constraint(equalTo: loginView.widthAnchor).isActive = true
        loginRegisterTab.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    //function to set user profile image during registration
    func setupProfileImage(){
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: loginRegisterTab.topAnchor, constant: -12).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    //function to setup custom view
    func setUpLoginRegView(){
        loginView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        loginViewHeightAnchor = loginView.heightAnchor.constraint(equalToConstant: 150)
        loginViewHeightAnchor?.isActive = true
        //adding username text field to the custom login view controller
        loginView.addSubview(userNameField)
        loginView.addSubview(userNameSeperator)
        
        userNameField.leftAnchor.constraint(equalTo: loginView.leftAnchor, constant: 12).isActive = true
        userNameField.topAnchor.constraint(equalTo: loginView.topAnchor).isActive = true
        userNameField.widthAnchor.constraint(equalTo: loginView.widthAnchor).isActive = true
        userNameHeightAnchor = userNameField.heightAnchor.constraint(equalTo: loginView.heightAnchor, multiplier: 1/3)
        userNameHeightAnchor?.isActive = true
        
        //adding seperator after username text field
        userNameSeperator.leftAnchor.constraint(equalTo: loginView.leftAnchor).isActive = true
        userNameSeperator.topAnchor.constraint(equalTo: userNameField.bottomAnchor).isActive = true
        userNameSeperator.widthAnchor.constraint(equalTo: loginView.widthAnchor).isActive = true
        userNameSeperator.heightAnchor.constraint(equalToConstant: 2).isActive = true
    
    
        
        //adding username text field to the custom login view controller
        loginView.addSubview(emailField)
        loginView.addSubview(emailSeperator)
        
        emailField.leftAnchor.constraint(equalTo: loginView.leftAnchor, constant: 12).isActive = true
        emailField.topAnchor.constraint(equalTo: userNameField.bottomAnchor).isActive = true
        emailField.widthAnchor.constraint(equalTo: loginView.widthAnchor).isActive = true
        emailHeightAnchor = emailField.heightAnchor.constraint(equalTo: loginView.heightAnchor, multiplier: 1/3)
        emailHeightAnchor?.isActive = true
        //adding seperator after username text field
        emailSeperator.leftAnchor.constraint(equalTo: loginView.leftAnchor).isActive = true
        emailSeperator.topAnchor.constraint(equalTo: emailField.bottomAnchor).isActive = true
        emailSeperator.widthAnchor.constraint(equalTo: loginView.widthAnchor).isActive = true
        emailSeperator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        
        //adding password text field to the custom login view controller
        loginView.addSubview(passwordField)
        loginView.addSubview(passwordSeperator)
        
        passwordField.leftAnchor.constraint(equalTo: loginView.leftAnchor, constant: 12).isActive = true
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor).isActive = true
        passwordField.widthAnchor.constraint(equalTo: loginView.widthAnchor).isActive = true
        passwordHeightAnchor = passwordField.heightAnchor.constraint(equalTo: loginView.heightAnchor, multiplier: 1/3)
        passwordHeightAnchor?.isActive = true
        //adding seperator after password text field
        passwordSeperator.leftAnchor.constraint(equalTo: loginView.leftAnchor).isActive = true
        passwordSeperator.topAnchor.constraint(equalTo: emailField.bottomAnchor).isActive = true
        passwordSeperator.widthAnchor.constraint(equalTo: loginView.widthAnchor).isActive = true
        passwordSeperator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    
    
    }
    //function to setup registration button
    func setupRegisterButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: loginView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}


extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
