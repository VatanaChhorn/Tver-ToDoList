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
    
    var delegate : SettingViewDelegate?
    var defaults = UserDefaults.standard
    let imagePicker = UIImagePickerController()
    var imageToPNG: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

