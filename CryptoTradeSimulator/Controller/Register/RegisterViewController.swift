import UIKit
import Firebase
import SCLAlertView

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIView!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    
    private let buyVC = BuyViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buyVC.buttonView(button: registerButton)
        activityLoading.hidesWhenStopped = true
    }
    
    // MARK: - Register Button Pressed
    
    @IBAction func registerPressed(_ sender: UIButton) {
        activityLoading.startAnimating()
        registerButton.isHidden = true
        if let email = emailTextField.text, let password = passwordTextField.text {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self!.activityLoading.stopAnimating()
                self!.registerButton.isHidden = false
                if self!.passwordTextField.text == self!.repeatPasswordTextField.text {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if (error != nil) {
                            SCLAlertView().showError("Unfortunately!", subTitle: "Passwords should have 6 characters!")
                        } else {
                            let appearance = SCLAlertView.SCLAppearance(
                                showCloseButton: false
                            )
                            let alertView = SCLAlertView(appearance: appearance)
                            let alert = alertView.showSuccess("Congratulations!", subTitle: "You joined to Crypto Trade Simulator")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                                self?.performSegue(withIdentifier: "reggoToApp", sender: self)
                            }
                            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
                                alert.close()
                            }
                        }
                    }
                } else {
                    SCLAlertView().showError("Unfortunately!", subTitle: "Passwords must be identical!")
                }
            }
        }
    }
}
