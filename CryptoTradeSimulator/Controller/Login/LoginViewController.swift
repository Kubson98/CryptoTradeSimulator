
import UIKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
    }


}
