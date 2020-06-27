//
//  LoginViewController.swift
//  CryptoTradeSimulator
//
//  Created by Kuba on 15/06/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

//protocol loginDelegate {
//    func sendLogin(name: String)
//}

class LoginViewController: UIViewController, LoginButtonDelegate {
 
    
    
    //var delegate: loginDelegate?
  var name: String = (Auth.auth().currentUser?.uid)!
  //  var vc = PocketViewController()
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print("niestety",error)
            return
        }
        print("SUCCESS")
        let accessToken = AccessToken.current
        guard let accessTokenString = accessToken?.tokenString else {return}
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                print("something wrong with our user")
            }
        }
        GraphRequest(graphPath: "/me", parameters: ["fields":"id,name,email"]).start { (connection, result, error) in
            if error != nil {
                print("ups")
                return
            }
            
            self.performSegue(withIdentifier: "goToApp", sender: self)
            print(result)
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("U did logouted")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
       let loginButton = FBLoginButton()
        loginButton.center = view.center
            view.addSubview(loginButton)
        loginButton.delegate = self
//        delegate?.sendLogin(name: "kuba")
        
        
        
          
        
            
       // print(Auth.auth().currentUser?.displayName) nazwa
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        if AccessToken.current != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.performSegue(withIdentifier: "goToApp", sender: self)
            })
        }
    }
    
              
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
