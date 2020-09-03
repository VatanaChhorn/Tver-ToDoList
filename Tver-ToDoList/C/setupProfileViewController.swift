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
    @IBOutlet weak var profilePictureReview: UIImageView!
    
    var defaults = UserDefaults.standard
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        profilePictureReview.layer.cornerRadius = profilePictureReview.frame.height / 2
        profilePictureReview.layer.masksToBounds = true
        profilePictureReview.layer.borderWidth = 2
        profilePictureReview.layer.borderColor = UIColor.white.cgColor
    }
    
    // MARK: - buttons action
    
    @IBAction func imagePickerClicked(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func finishButtonClicked(_ button: TransitionButton) {
        
        button.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
                                DispatchQueue.main.async(execute: { () -> Void in
                                                            if self.textfield.text?.count != 0 {
                                                                button.stopAnimation(animationStyle: .expand, completion: {
                                                                    let newString = self.textfield.text?.prefix(15)
                                                                    self.defaults.set( newString! , forKey: Names.username)
                                                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                                                    let mainVC = storyboard.instantiateViewController(withIdentifier: "MainScreen") as! UINavigationController
                                                                    mainVC.modalPresentationStyle = .fullScreen
                                                                    self.present(mainVC, animated: true, completion: nil)
                                                                })}
                                                            else {
                                                                button.stopAnimation(animationStyle: .normal, completion: {
                                                                    self.textfield.placeholder = "Please enter your username!"
                                                                    self.textfield.shake()
                                                                })}})})
        
        
    }
}

// MARK: - shake textfield configuration
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

// MARK: - ImagePickerController
extension setupProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let userPickedImage = info[UIImagePickerController.InfoKey.editedImage]
        let imageToPNG = (userPickedImage as! UIImage).pngData()
        defaults.set(imageToPNG, forKey: Names.displayProfile)
        self.profilePictureReview.image = (userPickedImage as! UIImage)
        picker.dismiss(animated: true, completion: nil);
    }
}

