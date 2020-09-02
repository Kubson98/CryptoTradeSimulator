import UIKit
import Firebase
import SCLAlertView


class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIView!
    @IBOutlet weak var signUpButton: UIView!

    private var buyVC = BuyViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        buyVC.buttonView(button: signInButton)
        buyVC.buttonView(button: signUpButton)
    }

    // MARK: - Login Button Pressed
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {

            Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
                if (error != nil) {
                    SCLAlertView().showError("Unfortunately!", subTitle: "Login / Password is incorrect")
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.performSegue(withIdentifier: "goToApp", sender: self)
                    })
                }
            }
        }
    }
}
