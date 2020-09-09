//
//  LanguageSelectionViewController.swift
//  Tver-ToDoList
//
//  Created by Vatana Chhorn on 09/09/2020.
//

import UIKit

class LanguageSelectionViewController: UIViewController {
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var khmerButton: UIButton!
    @IBOutlet weak var label2: UILabel!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.set(true, forKey: language.chooseLanguage)
        englishButton.setBackgroundImage(#imageLiteral(resourceName: "EnglishFlag").withRenderingMode(.alwaysOriginal), for: .normal)
        khmerButton.setBackgroundImage(#imageLiteral(resourceName: "CambodiaFlag").withRenderingMode(.alwaysOriginal), for: .normal)
        khmerButton.alpha = 0.5
        print(label2.font!)
    }
   
    
    @IBAction func englishButtonSelected(_ sender: UIButton) {
        englishButton.alpha = 1
        khmerButton.alpha = 0.5
        defaults.set(true, forKey: language.chooseLanguage)
    
    }
    @IBAction func khmerButtonSelected(_ sender: Any) {
        khmerButton.alpha = 1
        englishButton.alpha = 0.5
        defaults.set(false, forKey: language.chooseLanguage)
    }
    
}
