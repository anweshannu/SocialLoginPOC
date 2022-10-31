    //
    //  LoginViewController.swift
    //  SocialLoginPOC
    //
    //  Created by Anwesh M on 31/10/22.
    //

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var appleBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSocialButtons()
    }
    
    private func configureSocialButtons(){
        
        googleBtn.addLeadingImageToButton(imageName: "Google")
        facebookBtn.addLeadingImageToButton(imageName: "Facebook")
        appleBtn.addLeadingImageToButton(imageName: "Apple")
        
        
        
        
    }
    
    
    
    
    
    @IBAction func onLoginBtnClick(_ sender: Any) {
        
        
    }
    
    @IBAction func onGoogleSigninBtnClick(_ sender: Any) {
        
        let signInConfig = GIDConfiguration(clientID: "927907213040-3s6vun3o18sf716muk43jilc07ockhlp.apps.googleusercontent.com")
        
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: self) { user, error in
                guard let signInUser = user else {
                        // Inspect error
                    print("Error!!!")
                    return
                }
                
                UserDefaults.standard.set(signInUser.profile?.name, forKey: "username")
                UserDefaults.standard.set(signInUser.profile?.email, forKey: "email")
                UserDefaults.standard.set("Google", forKey: "logged-in_platform")
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                
                    // If sign in succeeded, display the app's main content View.
                self.goToHomeViewController()
            }
        
    }
    
    @IBAction func onFacebookSignInBtnClick(_ sender: Any) {
        
    }
    
    @IBAction func onAppleSignInBtnClick(_ sender: Any) {
        
    }
    
    
    private func goToHomeViewController(){
        print("goToHomeViewController")
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    
    
}
