//
//  SettingViewControllerViewController.swift
//  Pods
//
//  Created by Vatana Chhorn on 28/08/2020.
//

import UIKit

protocol SettingViewDelegate {
    func update(username : String)
}

class SettingViewController: UIViewController {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var delegate : SettingViewDelegate?
    var defaults = UserDefaults.standard
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    

    @IBAction func selectProfilePictureButtonClicked(_ sender: Any) {
    }
    
    @IBAction func finishButtonClicked(_ sender: Any) {
        let newString = usernameTextField.text?.prefix(10).lowercased()
        defaults.set( newString , forKey: Names.username)
        delegate?.update(username: newString!)
        self.dismiss(animated: true)
        }
    }

