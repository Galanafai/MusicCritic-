//
//  SweetsTableViewController.swift
//  Music_Critic_Single
//
//  Created by Galanafai Windross on 7/29/16.
//  Copyright © 2016 Galanafai Windross. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SweetsTableViewController: UITableViewController {

    
    var dbRef:FIRDatabaseReference!
    var sweets = [Sweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference().child("sweet-items")
        startObservingDB()
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth:FIRAuth, user:FIRUser?) in
            
            if let user = user {
                print("Welcome \(user.email)" )
                self.startObservingDB()
            }else{
                
                print("You need to sign up or login in first")
                
            }
    })
    
    }
    
    
    
    
    
    
    
    @IBAction func loginAndSignUp(sender: AnyObject) {
        
        let userAlert = UIAlertController(title: "login/Signup", message: "Enter Email and password", preferredStyle: .Alert)
        userAlert.addTextFieldWithConfigurationHandler { (textfield:UITextField ) in
            textfield.placeholder = "email"
        }
        userAlert.addTextFieldWithConfigurationHandler { (textfield:UITextField ) in
        textfield.secureTextEntry = true
        textfield.placeholder = "password"
        
        
        }
        userAlert.addAction(UIAlertAction(title: "Sign in", style: .Default, handler: { (action:UIAlertAction) in
            let emailTextField = userAlert.textFields!.first!
            let passwordTextField = userAlert.textFields!.last!
            
            FIRAuth.auth()?.signInWithEmail(emailTextField.text!, password: passwordTextField.text!, completion: { (user:FIRUser?, error:NSError?) in
                
                if error != nil {
                    print(error?.description)
                    
                    
        
                
                }
            
            })
            
        }))
        
        userAlert.addAction(UIAlertAction(title: "Sign up", style: .Default, handler: { (action:UIAlertAction) in
            let emailTextField = userAlert.textFields!.first!
            let passwordTextField = userAlert.textFields!.last!
            
            FIRAuth.auth()?.createUserWithEmail(emailTextField.text!, password: passwordTextField.text!, completion: { (user:FIRUser?, error:NSError?) in
                if error != nil {
                    print(error?.description)
                    
                }
            })

            
        }))
        
        self.presentViewController(userAlert, animated: true, completion: nil)
        
    }
    
    
    
    func startObservingDB () {
        dbRef.observeEventType(.Value, withBlock: { (snapshot:FIRDataSnapshot) in
            
            var newSweets = [Sweet]()
            
            for sweet in snapshot.children {
            
                let sweetObject = Sweet(snapshot: sweet as! FIRDataSnapshot)
                newSweets.append(sweetObject)
                
            }
            self.sweets = newSweets
            self.tableView.reloadData()
            
        }) { (error:NSError) in
            print(error.description)
        
        
        }
        
    }

 
    @IBAction func addSweet(sender: AnyObject) {
        let sweetAlert = UIAlertController(title: "Want to post", message: "Enter new post", preferredStyle: .Alert)
        sweetAlert.addTextFieldWithConfigurationHandler { (textfield:UITextField) in
            textfield.placeholder="Your post"
        }
        sweetAlert.addAction(UIAlertAction(title: "send", style: .Default, handler: { (action:UIAlertAction) in
           if let sweetContent = sweetAlert.textFields?.first?.text {
                let sweet = Sweet(content: sweetContent, addedByUser: "emailTextField" )
                
                let sweetRef = self.dbRef.child(sweetContent.lowercaseString)
                sweetRef.setValue(sweet.toAnyObject())
            
                
            }
        }))
        
        self.presentViewController(sweetAlert, animated: true, completion: nil)
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sweets.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let sweet = sweets[indexPath.row]
        
        cell.textLabel?.text = sweet.content
        cell.detailTextLabel?.text = sweet.content

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            
            let sweet = sweets[indexPath.row]
            
            sweet.itemRef?.removeValue()
            
    }
    }

}
