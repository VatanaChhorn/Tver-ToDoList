//
//  setupProfileViewController.swift
//  Tver-ToDoList
//
//  Created by Vatana Chhorn on 25/08/2020.
//

import UIKit
import TransitionButton

class setupProfileViewController: UIViewController {
    @IBOutlet weak var textfield: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func finishButtonClicked(_ button: TransitionButton) {
        button.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
                                DispatchQueue.main.async(execute: { () -> Void in
                                    if self.textfield.text?.count != 0 {
                                    button.stopAnimation(animationStyle: .expand, completion: {
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let mainVC = storyboard.instantiateViewController(withIdentifier: "MainScreen") as! UINavigationController
                                            mainVC.modalPresentationStyle = .fullScreen
                                            self.present(mainVC, animated: true, completion: nil)
                                        }
                                        )}
                                    else {
                                        
                                        button.stopAnimation(animationStyle: .normal, completion: {
                                            self.textfield.placeholder = "Please enter your username!"
                                            self.textfield.shake()
                                    }
                                )}
                                }
        )}
    
)}
}

extension UIView {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
