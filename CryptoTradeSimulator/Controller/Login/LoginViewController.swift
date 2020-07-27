
import UIKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIView!
    @IBOutlet weak var signUpButton: UIView!
    
    var buyVC = BuyViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buyVC.buttonView(button: signInButton)
        buyVC.buttonView(button: signUpButton)
    }
    
    //MARK: - Login Button Pressed 
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
    //MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        AccessToken.current = nil
    }
    
    
}
