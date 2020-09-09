//
//  Onboarding1_ViewController.swift
//  Tver-ToDoList
//
//  Created by Vatana Chhorn on 09/09/2020.
//

import UIKit

class Onboarding1_ViewController: UIViewController {
    @IBOutlet weak var label1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: language.chooseLanguage) {
            label1.text = language.hopeJourney_eng
        } else {
            label1.font = UIFont(name: "Khmer OS Bokor", size: 25)
            label1.text = language.hopeJourney_kh
        }
    }

}
