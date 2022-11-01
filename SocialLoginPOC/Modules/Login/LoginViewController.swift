    //
    //  LoginViewController.swift
    //  SocialLoginPOC
    //
    //  Created by Anwesh M on 31/10/22.
    //

import UIKit
import GoogleSignIn
import FacebookLogin
import AuthenticationServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var appleBtn: UIButton!
    
    let users:[User] = [User(name: "Anwesh", password: "Anwesh"), User(name: "test", password: "test")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSocialButtons()
        hideKeyboardWhenTappedAround()
    }
    
    private func configureSocialButtons(){
        googleBtn.addLeadingImageToButton(imageName: "Google")
        facebookBtn.addLeadingImageToButton(imageName: "Facebook")
        appleBtn.addLeadingImageToButton(imageName: "Apple")
    }
    
    @IBAction func onLoginBtnClick(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        guard username.count > 0, password.count > 0 else{
            self.showAlert(message: "Please enter username / password")
            return
        }
        
        let usernameExist =  users.filter { $0.name == username}.count > 0
        
        guard usernameExist else{
            self.showAlert(message: "No user found")
            return
        }
        
        guard users.filter({ $0.name == username}).first?.password == password else{
            self.showAlert(message: "Invalid password")
            return
        }
        
        goToHomeViewController(username: username, platform: .password)
        
        
    }
    
    
    
    
    @IBAction func onGoogleSigninBtnClick(_ sender: Any) {
        
        let signInConfig = GIDConfiguration(clientID: "927907213040-3s6vun3o18sf716muk43jilc07ockhlp.apps.googleusercontent.com")
        
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: self) { user, error in
                guard let signInUser = user else {
                        // Inspect error
                    if let error = error{
                        
                        if error.localizedDescription == "The user canceled the sign-in flow."{
                            print("Cancelled Google login")
                        }
                        else{
                            self.showAlert(message: error.localizedDescription)
                        }
                    }
                    else{
                        print("Error!!!")
                    }
                    return
                }
                
                guard let username = signInUser.profile?.name else{
                    print("No username found in profile")
                    return
                }

                // If sign in succeeded, display the app's main content View.
                self.goToHomeViewController(username: username, platform: .google)
            }
        
    }
    
    @IBAction func onFacebookSignInBtnClick(_ sender: Any) {
        
        let loginManager = LoginManager()
        loginManager.logIn(viewController: self) { result in
            
            switch result{
            case .success(granted: let granted, declined: let declined, token: let token):
                
                    // Make sure the permissions of these fields are all granted; Else Facebook would not return these to app
                let requestedFields = "email, first_name, last_name"
                GraphRequest.init(graphPath: "me", parameters: ["fields":requestedFields]).start { (connection, result, error) -> Void in
                    if let dict = result as? [String: Any],  let lastName = dict["last_name"] as? String, let firstName =  dict["first_name"] as? String{
                        print("Hello \(firstName) \(lastName)")
                        let username = "\(firstName) \(lastName)"
                        self.goToHomeViewController(username: username, platform: .facebook)
                    }
                }
                print(token, granted, declined)
            case .cancelled:
                print("User cancelled FB login")
            case .failed(_):
                print("FB login failed")
            }
            
        }
        
    }
    
    @IBAction func onAppleSignInBtnClick(_ sender: Any) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    
    private func goToHomeViewController(username: String, platform: SocialPlatforms){
        print("goToHomeViewController")
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(platform.name, forKey: "logged-in_platform")
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    
    
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            UserDefaults.standard.setValue(userIdentifier, forKey: "AppleUserIdentifier")
            let fullName = appleIDCredential.fullName?.givenName
            UserDefaults.standard.setValue(fullName, forKey: userIdentifier)
            goToHomeViewController(username: fullName ?? "Unknown Apple user", platform: .apple)
            break
        default:
            break
        }
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

enum SocialPlatforms{
    case google, facebook, apple, password
    var name: String {
        switch self{
        case .google:
            return "Google"
        case .facebook:
            return "Facebook"
        case .apple:
            return "Apple"
        case .password:
            return "Password"
        }
    }
    
}


class User{
    let name, password: String
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
    }
}
