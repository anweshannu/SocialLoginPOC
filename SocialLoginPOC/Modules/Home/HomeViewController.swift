    //
    //  HomeViewController.swift
    //  SocialLoginPOC
    //
    //  Created by Anwesh M on 31/10/22.
    //

import UIKit
import GoogleSignIn
import FacebookLogin

class HomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var loggedInMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
      
        guard let socialPlatform = UserDefaults.standard.value(forKey: "logged-in_platform") else{
            print("Unable to get username and platform name")
            return
        }
        
        guard let username = UserDefaults.standard.value(forKey: "username") as? String ?? getUsernameForAppleUser() else{
            return
        }
        welcomeLabel.text = "Welcome, \(username)"
        loggedInMessageLabel.text = "You have successfully logged in using \(socialPlatform)"
    }
    
    private func getUsernameForAppleUser() -> String?{
        guard let appleUserIdentifier = UserDefaults.standard.value(forKey: "AppleUserIdentifier") as? String else{
            return nil
        }
        return UserDefaults.standard.value(forKey: appleUserIdentifier) as? String
    }
    
    @IBAction func onSignOutButtonClick(_ sender: Any) {
        GIDSignIn.sharedInstance.signOut()
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        LoginManager().logOut()
        goToLoginScreen()
    }
    
    private func goToLoginScreen(){
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
}
