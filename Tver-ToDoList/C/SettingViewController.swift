//
//  SettingViewControllerViewController.swift
//  Pods
//
//  Created by Vatana Chhorn on 28/08/2020.
//

import UIKit


protocol SettingViewDelegate {
    func update()
}

class SettingViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var imagePickerReview: UIImageView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UITextField!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    var delegate : SettingViewDelegate?
    var defaults = UserDefaults.standard
    let imagePicker = UIImagePickerController()
    var imageToPNG: Data?
    
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
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePickerReview.layer.cornerRadius = imagePickerReview.frame.height / 2
        imagePickerReview.layer.masksToBounds = true
        imagePickerReview.layer.borderWidth = 2
        imagePickerReview.layer.borderColor = UIColor.white.cgColor
        
        let imageData = UserDefaults.standard.object(forKey: Names.displayProfile) as? Data
        if let safeImageData = imageData {
            self.imagePickerReview.image = UIImage(data: safeImageData)
        }
    }

    @IBAction func selectProfilePictureButtonClicked(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func finishButtonClicked(_ sender: Any) {
        let newString = usernameTextField.text?.prefix(15)
        if let safeString = newString {
            defaults.set( safeString , forKey: Names.username)
        }
        if let safeImage = imageToPNG {
            defaults.set(safeImage, forKey: Names.displayProfile)
        }
        delegate?.update()
        self.dismiss(animated: true)
    }
}

// MARK: - ImagePickerController
extension SettingViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let userPickedImage = info[UIImagePickerController.InfoKey.editedImage]
        imageToPNG = (userPickedImage as! UIImage).pngData()
        self.imagePickerReview.image = (userPickedImage as! UIImage)
        picker.dismiss(animated: true, completion: nil);
    }
}

