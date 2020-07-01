
import UIKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController, LoginButtonDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
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
                return
            }
            
            self.performSegue(withIdentifier: "goToApp", sender: self)
            
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

    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
        
        Auth.auth().signIn(withEmail: email, password: password) { (authresult, error) in
                  if let e = error {
                      print(e)
                  } else {
                              DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                          self.performSegue(withIdentifier: "goToApp", sender: self)
                                          })
                  }

        }
    }
    }
    override func viewWillAppear(_ animated: Bool) {
        AccessToken.current = nil
        //print(Auth.auth().currentUser?.uid)
    }


}
