//
//  NewMessagesTableViewController.swift
//  ChatEzee
//
//  Created by Shumaz Ahamed Junaidi on 5/30/18.
//  Copyright © 2018 Shumaz Ahamed Junaidi. All rights reserved.
//

import UIKit
import Firebase
class NewMessagesTableViewController: UITableViewController {
    var usr = [Users]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: "reuseIdentifier")
        fetchUsersFromDatabase()
    }
    //function to fetch entire user list from DB
    func fetchUsersFromDatabase(){
        print("reset user object array......")
        usr.removeAll()
        let ref = Database.database().reference()
        ref.child("users").observe(.childAdded, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = Users()
                user.id = snapshot.key
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImage = dictionary["profileImageUrl"] as? String
                //user.setValueForKeysWithDictionary(dictionary)
                self.usr.append(user)
                ref.keepSynced(true)
                // this will crash because of background thraed
                //self.tableView.reloadData()
                // Below code to span a long running thread to avoid app crash
                let background = DispatchQueue.main
                background.async { //async tasks here
                    self.tableView.reloadData()
                    
                    
               }
            
            }
        })
    }
    
    //On cancel go back to MessageController VC
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Need to use dequeue to achieve memory efficiency...
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! UserCell
        let user = usr[indexPath.row]
       
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        //cell.imageView?.image = UIImage(named: "prof")
        if let profileImageUrl = user.profileImage {
           
           // Call extension of ImageView to perform caching of downloaded images from the server using NSCACHE
            
              cell.profileImageView.cacheImageFrom(urlString: profileImageUrl)
           
            
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    ///var messageController: MessageViewController
    //function to navigate to chat room view controller...
    func navigateCharRoomController(user: Users){
        let chatRoomVC = ChatRoomController(collectionViewLayout: UICollectionViewFlowLayout())
        chatRoomVC.user = user
        navigationController?.pushViewController(chatRoomVC, animated: true)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usersData = self.usr[indexPath.row]
        navigateCharRoomController(user: usersData)
      /*  dismiss(animated: true, completion: {
            messageController?.navigateCharRoomController()
            })
 */
    }
  /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Need to use dequeue to achieve memory efficiency...
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let user = usr[indexPath.row]
        print("dddddddddd")
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

