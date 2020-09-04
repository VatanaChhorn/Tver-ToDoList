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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePickerReview.layer.cornerRadius = imagePickerReview.frame.height / 2
        imagePickerReview.layer.masksToBounds = true
        imagePickerReview.layer.borderWidth = 3
        imagePickerReview.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    
    @IBAction func selectProfilePictureButtonClicked(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func finishButtonClicked(_ sender: Any) {
        let newString = usernameTextField.text?.prefix(15)
        defaults.set( newString! , forKey: Names.username)
        delegate?.update()
        self.dismiss(animated: true)
    }
}

// MARK: - ImagePickerController

extension SettingViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let userPickedImage = info[UIImagePickerController.InfoKey.editedImage]
        let imageToPNG = (userPickedImage as! UIImage).pngData()
        defaults.set(imageToPNG, forKey: Names.displayProfile)
        self.imagePickerReview.image = (userPickedImage as! UIImage)
        picker.dismiss(animated: true, completion: nil);
    }
    
    
    
}

