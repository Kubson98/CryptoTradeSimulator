//
//  alertView.swift
//  CryptoTradeSimulator
//
//  Created by Kuba on 28/06/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit

class AlertView: UIView{
    
    static let intance = AlertView()
    
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var resultInfo: UILabel!
    @IBOutlet weak var buttonOk: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet var parentView: UIView!
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
         commonInit()
     }
     
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
   private func commonInit(){
//        resultImage.layer.cornerRadius = 30
//        resultImage.layer.borderColor = UIColor.white.cgColor
//        resultImage.layer.borderWidth = 2
        
        alertView.layer.cornerRadius = 10
        alertView.layer.borderWidth = 10
        //alertView.layer.borderColor = UIColor.green as! CGColor
        
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
     enum AlertType {
         case success
         case failure
     }
     
     func showAlert(title: String, message: String, alertType: AlertType) {
         self.resultTitle.text = title
         self.resultInfo.text = message
         
         switch alertType {
         case .success:
             resultImage.image = UIImage(named: "Success")
             buttonOk.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
             alertView.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
         case .failure:
             resultImage.image = UIImage(named: "Failure")
             buttonOk.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            alertView.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
         }
         
        UIApplication.shared.keyWindow!.addSubview(parentView)
     }
     
     
     
     @IBAction func onClickDone(_ sender: Any) {
         parentView.removeFromSuperview()
     }
     
}
