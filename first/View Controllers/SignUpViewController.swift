//
//  SignUpViewController.swift
//  first
//
//  Created by Alyna Sameullah on 4/5/20.
//  Copyright © 2020 Akshan Sameullah. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var FullNameTextField: UITextField!
    
    @IBOutlet weak var AddressTextField: UITextField!
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var NewPasswordTextField: UITextField!
    
    @IBOutlet weak var SignUpButton: UIButton!

    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    func setUpElements(){
        //hide error label
        ErrorLabel.alpha = 0
        //style the elements
        Utilities.styleTextField(FullNameTextField)
        Utilities.styleTextField(AddressTextField)
        Utilities.styleTextField(EmailTextField)
        Utilities.styleTextField(NewPasswordTextField)
        
        Utilities.styleFilledButton(SignUpButton)
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
        if FullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || AddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || NewPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please Fill In All Fields"
        }
        let cleanedPassword = NewPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedEmail = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false{
            
            return "Please ensure Password meets all requirements (At least 8 Characters in length, Contains special character i.e !,@,#, and a number)"
        }
        if Utilities.isEmailValid(cleanedEmail) == false{
            
            return "Please ensure email is valid"
        }
        return nil
    }
    
    @IBAction func SignUpTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        } else {
            let cleanedPassword = NewPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedEmail = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedAddress = AddressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedFullName = FullNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: cleanedEmail, password: cleanedPassword) { (result, err) in
                if err != nil{
                    self.showError("Error creating user")
                } else {
                    //
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["FullName": cleanedFullName, "Address": cleanedAddress, "uid": result!.user.uid ]) { (error) in
                        if error != nil{
                            //database problem
                        }
                    }
                    self.TransitionToHome()
                }
            }
        }
    }
    func showError(_ message:String){
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
    }
    func TransitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
