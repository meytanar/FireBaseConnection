//
//  ViewController.swift
//  FireBaseConnection
//
//  Created by BSH_MRM on 6.12.2018.
//  Copyright © 2018 BSH_MRM. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var sifreTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func girisBtn(_ sender: Any) {
        if self.emailTxt.text != "" && self.sifreTxt.text != "" {
            
            Auth.auth().signIn(withEmail: self.emailTxt.text!, password: self.sifreTxt.text!)
            { (userdata, error) in
                
                if error != nil {
                    let alert = UIAlertController(title: "Hata", message: error?.localizedDescription, preferredStyle: .alert)
                    let alertaction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                    alert.addAction(alertaction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.performSegue(withIdentifier: "girisYapildi", sender: nil)
                    
                }
            }
        }
    }
    
    @IBAction func KayıtOl(_ sender: UIButton) {
        if self.emailTxt.text != "" && self.sifreTxt.text != "" {
            
            Auth.auth().createUser(withEmail: self.emailTxt.text!, password: self.sifreTxt.text!)
            { (userdata, error) in
                
                if error != nil {
                    let alert = UIAlertController(title: "Hata", message: error?.localizedDescription, preferredStyle: .alert)
                    let alertaction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                    alert.addAction(alertaction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.performSegue(withIdentifier: "girisYapildi", sender: nil)
                }
            }
        } else {
            let alert = UIAlertController(title: "Hata", message: "E-mail yada Şifre boş olamaz", preferredStyle: .alert)
            let alertaction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(alertaction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
