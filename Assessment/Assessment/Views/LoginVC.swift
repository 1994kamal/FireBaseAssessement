//
//  ViewController.swift
//  Assessment
//
//  Created by Clavax on 25/04/24.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginVC: BaseVC {

    @IBOutlet weak var numberTxt: UITextField!
    @IBOutlet weak var verifyCodeTxt: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var verificationID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialInit()
        
    }
    
    //MARK: Class helper method
    func initialInit() {
        self.verifyCodeTxt.isHidden = true
        self.setShadowToView(view: loginButton,
                             CornerRadius: 10,
                             BorderColor: .lightGray,
                             BorderWidth: 1,
                             ShadowOpacity: 0.5,
                             ShadowColor: .lightGray,
                             ShadowRadius: 10,
                             ShadowOffset: CGSize(width: -1, height: 1),
                             MasksToBounds: false)
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        if validationsMobile() {
            guard let numberText = numberTxt.text else { return }
            let phoneNumber = "+91" + numberText
            if verificationID == nil {
                Auth.auth().settings?.isAppVerificationDisabledForTesting = false
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                    if let error = error {
                        self.alert(message: error.localizedDescription)
                        print("Error sending verification code: \(error.localizedDescription)")
                        return
                    }
                    self.verificationID = verificationID
                    print("Verification ID: \(String(describing: verificationID))")
                    self.verifyCodeTxt.isHidden = false
                    self.loginButton.setTitle("Verify Code", for: .normal)
                    self.numberTxt.isEnabled = false
                }
            } else {
                    guard let verificationCode = verifyCodeTxt.text else { return }
                    guard let verificationID = self.verificationID else { return }
                    let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
                    Auth.auth().signIn(with: credential) { (authResult, error) in
                        if let error = error {
                            self.alert(message: error.localizedDescription)
                            print("Error signing in: \(error.localizedDescription)")
                            return
                        }
                        let HomeVC = self.storyboard?.instantiateViewController(identifier: "TabBarVC") as! TabBarVC
                        self.navigationController?.pushViewController(HomeVC, animated: true)
                        print("User signed in with phone number: \(authResult?.user.phoneNumber ?? "")")
                    }
            }
        }
    }
    
    func validationsMobile() -> Bool {
        if self.numberTxt.text == "" {
            self.alert(message: "Please Enter Mobile Number.")
            return false
        }else {
            return true
        }
    }
    
    
    
    
}

