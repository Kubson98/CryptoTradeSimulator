
import UIKit
import Firebase
import SCLAlertView

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIView!
    
    let buyVC = BuyViewController()
    let pocketVC = PocketViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        buyVC.buttonView(button: registerButton)
    }
    
    //MARK: - Register Button Pressed
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            if passwordTextField.text == repeatPasswordTextField.text{
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        print(e)
                    }else{
                        let appearance = SCLAlertView.SCLAppearance(
                            showCloseButton: false
                        )
                        let alertView = SCLAlertView(appearance: appearance)
                        let alert = alertView.showSuccess("Congratulations!", subTitle: "You joined to Crypto Trade Simulator")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            self.performSegue(withIdentifier: "reggoToApp", sender: self)
                        })
                        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
                            alert.close()
                        }
                    }
                }
            }else{
                SCLAlertView().showError("Unfortunately!", subTitle: "Passwords must be identical!")
            }
        }
    }
}
