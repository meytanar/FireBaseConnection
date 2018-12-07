//
//  UserDataViewController.swift
//  FireBaseConnection
//
//  Created by BSH_MRM on 7.12.2018.
//  Copyright © 2018 BSH_MRM. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class UserDataViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var thoughts: UITextField!
    @IBOutlet weak var kaydet: UIButton!
    
    
    @IBAction func kaydetAct(_ sender: Any) {
        let storageRef = Storage.storage().reference()
        let imageFolder = storageRef.child("ImageFolder")
        
        if let data = image.image?.jpegData(compressionQuality: 0.8){
            
            let uuid = NSUUID().uuidString //Unique değer oluştur-Yeni fotoğraf ismi eklemek için
            let imageFolderRef = imageFolder.child("\(uuid).jpg")
            
            imageFolderRef.putData(data, metadata: nil) { (storageMetaData, error) in
                if error != nil{
                    let alert = UIAlertController(title: "Hata", message: error?.localizedDescription, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    imageFolderRef.downloadURL(completion: { (url, error)in
                        if error == nil{
                            let imageURL = url?.absoluteString
                            let databaseRef = Database.database().reference()
                            
                            let icerik = ["Gorsel": imageURL!, "Kim": Auth.auth().currentUser?.email!, "isim": self.name.text!, "Yorum": self.thoughts.text!, "uuid": uuid] as [String: Any]
                            
                            databaseRef.child("Kullanici").child(((Auth.auth().currentUser?.uid)!)).child("Gonderi").childByAutoId().setValue(icerik)
                    }
                }
            )}
        }
    }
}
    
    @IBAction func okuButton(_ sender: Any) {
        let databaseRef = Database.database().reference()
        
        databaseRef.child("UserProfile").observe(.value) { (snapshot) in
            let values = snapshot.value! as! NSDictionary
            let gonderi = values["Gonderi"] as! NSDictionary
            let postID = gonderi.allKeys
            print(postID)
            
            for id in postID {
                let post = gonderi[id] as! NSDictionary
                self.adArray.append(post["AD"] as! String)
                //let ad = post ["AD"] as! String
            }
            print(self.adArray)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        image.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImajSec))
   
    image.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func ImajSec() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

  
}

