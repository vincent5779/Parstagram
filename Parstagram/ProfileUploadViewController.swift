//
//  ProfileUploadViewController.swift
//  Parstagram
//
//  Created by Hew, Vincent on 10/16/21.
//

import UIKit
import AlamofireImage
import Parse

class ProfileUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePreview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfile()
        
    }
    
    @IBAction func onSubmitProfile(_ sender: Any) {
        var query = PFQuery(className: "Profiles")
        query.whereKey("user", equalTo: PFUser.current()!)
        query.findObjectsInBackground { (profile, error) in
            if profile![0] != nil {
                let imageData = self.imagePreview.image!.pngData()
                let file = PFFileObject(name: "profile.png", data: imageData!)

                let oldUser = profile![0]
                oldUser["profile"] = file
                oldUser.saveInBackground { (success, error) in
                    if success {
                        self.dismiss(animated: true, completion: nil)
                        print("profile saved: first if statement")
                    } else {
                        print("profile error: first if statement")
                    }
                }

            } else if profile![0] == nil{
                let newProfile = PFObject(className: "Profiles")

                newProfile["user"] = PFUser.current()!

                let imageData = self.imagePreview.image!.pngData()
                let file = PFFileObject(name: "profile.png", data: imageData!)

                newProfile["profile"] = file

                newProfile.saveInBackground { (success, error) in
                    if success {
                        self.dismiss(animated: true, completion: nil)
                        print("profile saved: second if statement")
                    } else {
                        print("profile error: second if statement")
                    }
                }
            } else {
                print("ERROR finding profile in background")
            }
        }
    }
    
    @IBAction func onProfileButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage

        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        imagePreview.image = scaledImage
        imagePreview.layer.borderWidth = 1.0
        imagePreview.layer.masksToBounds = false
        imagePreview.layer.borderColor = UIColor.white.cgColor
        imagePreview.layer.cornerRadius = 130 / 2
        imagePreview.clipsToBounds = true

        dismiss(animated: true, completion: nil)
    }
    
    func getProfile() {
        let query = PFQuery(className: "Profiles")
        query.includeKey("profile")
        query.whereKey("user", equalTo: PFUser.current()!)
        query.findObjectsInBackground { (profile, error) in
            if profile != nil {
                if profile![0] != nil {
                    let profileImg = profile![0]
                    
                    let imageFile = profileImg["profile"] as! PFFileObject
                    let urlString = imageFile.url!
                    let url = URL(string: urlString)!
                    
                    self.imagePreview.af_setImage(withURL: url)
                    
                    self.imagePreview.layer.borderWidth = 1.0
                    self.imagePreview.layer.masksToBounds = false
                    self.imagePreview.layer.borderColor = UIColor.white.cgColor
                    self.imagePreview.layer.cornerRadius = 130 / 2
                    self.imagePreview.clipsToBounds = true
                }
            } else {
                print(error?.localizedDescription)
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
