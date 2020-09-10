//
//  setupProfileViewController.swift
//  Tver-ToDoList
//
//  Created by Vatana Chhorn on 25/08/2020.
//

import UIKit
import TransitionButton

class setupProfileViewController: UIViewController {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UITextField!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: TransitionButton!    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var profilePictureReview: UIImageView!
    
    var defaults = UserDefaults.standard
    let imagePicker = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        profilePictureReview.layer.cornerRadius = profilePictureReview.frame.height / 2
        profilePictureReview.layer.masksToBounds = true
        profilePictureReview.layer.borderWidth = 2
        profilePictureReview.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefaults.standard.bool(forKey: language.chooseLanguage) {
            
            label1.font = UIFont(name: "Khmer OS Bokor", size: 35)
            label2.font = UIFont(name: "Khmer OS Bokor", size: 17)
            label4.font = UIFont(name: "Khmer OS Bokor", size: 17)
            label5.font = UIFont(name: "Khmer OS Bokor", size: 14)
            button1.titleLabel?.font = UIFont(name: "Khmer OS Bokor", size: 15)
            button2.titleLabel?.font = UIFont(name: "Khmer OS Bokor", size: 15)
            button1.setTitle("ជ្រើសរើសរូបភាព", for: .normal)
            button2.setTitle(language.finish_kh, for: .normal)
            label1.text = language.setupYourProfile_kh
            label2.text = language.profilePicture_kh
            label4.text = language.userName_kh
            label5.placeholder = language.whatwouldyou_kh
        }
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
                                                                    UserDefaults.standard.set(true, forKey: Names.onboardingView)
                                                                })}
                                                            else {
                                                                button.stopAnimation(animationStyle: .normal, completion: {
                                                                    if !UserDefaults.standard.bool(forKey: language.chooseLanguage) {
                                                                        self.textfield.placeholder = "សូមបំពេញឈ្មោះ​ប្រើប្រាស់របស់អ្នក"
                                                                    } else {
                                                                        self.textfield.placeholder = "Please enter your username!"
                                                                    }
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

