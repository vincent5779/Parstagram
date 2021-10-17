//
//  ProfileViewController.swift
//  Parstagram
//
//  Created by Hew, Vincent on 10/16/21.
//

import UIKit
import AlamofireImage
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let query = PFQuery(className: "Profiles")
        query.whereKey("user", equalTo: PFUser.current()!)
        query.findObjectsInBackground{ (profile, error) in
            if profile != [] {
                let userProfile = profile![0]

                let user = userProfile["user"] as! PFUser
                user.fetchIfNeededInBackground { (profileName, error) in
                    if profileName != nil {
                        self.usernameLabel.text = profileName?["username"] as? String
                    } else {
                        print(error?.localizedDescription)
                    }
                }

                let imageFile = userProfile["profile"] as! PFFileObject
                let urlString = imageFile.url!
                let url = URL(string: urlString)!

                self.profileView.af_setImage(withURL: url)

                self.profileView.layer.borderWidth = 1.0
                self.profileView.layer.masksToBounds = false
                self.profileView.layer.borderColor = UIColor.white.cgColor
                self.profileView.layer.cornerRadius = 130 / 2
                self.profileView.clipsToBounds = true
            } else {
                print("profile did not update")
                let user = PFUser.current()!
                user.fetchIfNeededInBackground { (profileName, error) in
                    if profileName != nil {
                        self.usernameLabel.text = profileName?["username"] as? String
                    } else {
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let query = PFQuery(className: "Profiles")
        query.whereKey("user", equalTo: PFUser.current()!)
        query.findObjectsInBackground{ (profile, error) in
            if profile != [] {
                let userProfile = profile![0]

                let user = userProfile["user"] as! PFUser
                user.fetchIfNeededInBackground { (profileName, error) in
                    if profileName != nil {
                        self.usernameLabel.text = profileName?["username"] as? String
                    } else {
                        print(error?.localizedDescription)
                    }
                }

                let imageFile = userProfile["profile"] as! PFFileObject
                let urlString = imageFile.url!
                let url = URL(string: urlString)!

                self.profileView.af_setImage(withURL: url)

                self.profileView.layer.borderWidth = 1.0
                self.profileView.layer.masksToBounds = false
                self.profileView.layer.borderColor = UIColor.white.cgColor
                self.profileView.layer.cornerRadius = 130 / 2
                self.profileView.clipsToBounds = true
            } else {
                print("profile did not update")
                let user = PFUser.current()!
                user.fetchIfNeededInBackground { (profileName, error) in
                    if profileName != nil {
                        self.usernameLabel.text = profileName?["username"] as? String
                    } else {
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
