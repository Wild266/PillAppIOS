//
//  LopginViewController.swift
//  first
//
//  Created by Alyna Sameullah on 4/5/20.
//  Copyright © 2020 Akshan Sameullah. All rights reserved.
//

import UIKit
import FirebaseAuth

class LopginViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
  
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    func setUpElements(){
        ErrorLabel.alpha = 0
        Utilities.styleTextField(EmailTextField)
        Utilities.styleTextField(PasswordTextField)
        Utilities.styleFilledButton(LoginButton)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func validateFields() -> String? {
        if EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please Fill In All Fields"
        }

        return nil
    }
    @IBAction func LoginTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        } else {
            let cleanedEmail = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedPassword = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: cleanedEmail, password: cleanedPassword) { (result, error) in
                if error != nil {
                    self.ErrorLabel.text = error!.localizedDescription
                    self.ErrorLabel.alpha = 1
                } else {
                    let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
    func showError(_ message:String){
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
    }
}
