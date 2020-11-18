//
//  LoginViewController.swift
//  TheFashionist
//
//  Created by Ozgur Hayat on 01/11/2020.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func forgetButtonPressed(_ sender: Any) {
        let vc = ForgotPasswordVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        guard let email = emailText.text, email.isNotEmpty,
              let password = passwordText.text, password.isNotEmpty else {
            simpleAlert(title: "Error", msg: "Please fill all blanks")
            return
            }
        
        activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
          
            if let error = error {
                debugPrint(error.localizedDescription)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                self.activityIndicator.stopAnimating()
                return
            }
            
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func continueGuestButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
