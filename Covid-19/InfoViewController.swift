//
//  InfoViewController.swift
//  Covid-19
//
//  Created by Connor on 4/25/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class InfoViewController: UIViewController {
    
    var authUI: FUIAuth!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let home = self.storyboard?.instantiateViewController(identifier: "TabBar") as? UITabBarController
        
        view.window?.rootViewController = self
        
        if authUI.auth?.currentUser != nil {
            print("logged in!")
            self.view.window?.rootViewController = home
            performSegue(withIdentifier: "TabBar", sender: Any?.self)
        } else { signIn()}
        
        
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
        ]
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            let authLogIn = authUI.authViewController()
            authLogIn.modalPresentationStyle = .fullScreen
            present(authLogIn, animated: true, completion: nil)
        }
        
    }
    
    func signOut() {
        authUI = FUIAuth.defaultAuthUI()
        do {
            try authUI!.signOut()
            print("^^^ Successfully signed out!")
            signIn()
        } catch {
            print("*** ERROR: Couldn't sign out")
        }
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        signIn()
        
    }
}


extension InfoViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            // Assumes data will be isplayed in a tableView that was hidden until login was verified so unauthorized users can't see data.
            print("^^^ We signed in with the user \(user.email ?? "unknown e-mail")")
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        
        // Create an instance of the FirebaseAuth login view controller
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        
        loginViewController.navigationItem.leftBarButtonItem = nil
        loginViewController.isModalInPresentation = true
        
        // Set background color to white
        loginViewController.view.backgroundColor = UIColor.white
        
        // Create a frame for a UIImageView to hold our logo
        let marginInsets: CGFloat = 16 // logo will be 16 points from L and R margins
        let imageHeight: CGFloat = 225 // the height of our logo
        let imageY = self.view.center.y - imageHeight // places bottom of UIImageView in the center of the login screen
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageHeight)
        
        
        
        // Create the UIImageView using the frame created above & add the "logo" image
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
        loginViewController.view.addSubview(logoImageView) // Add ImageView to the login controller's main view
        return loginViewController
    }
}
