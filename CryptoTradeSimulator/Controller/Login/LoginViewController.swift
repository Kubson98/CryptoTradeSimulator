import UIKit
import Firebase
import SCLAlertView


class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIView!
    @IBOutlet weak var signUpButton: UIView!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    
    private var buyVC = BuyViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        buyVC.buttonView(button: signInButton)
        buyVC.buttonView(button: signUpButton)
        activityLoading.hidesWhenStopped = true
    }

    // MARK: - Login Button Pressed
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        signInButton.isHidden = true
        activityLoading.startAnimating()
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        self.activityLoading.stopAnimating()
                        self.signInButton.isHidden = false
                        if error != nil {
                    SCLAlertView().showError("Unfortunately!", subTitle: "Login / Password is incorrect")
                } else {
                        self.performSegue(withIdentifier: "goToApp", sender: self)
                }
            }
        )}
    }
}
}
