//
//  Onboarding0_ViewController.swift
//  Tver-ToDoList
//
//  Created by Vatana Chhorn on 09/09/2020.
//

import UIKit

class Onboarding0_ViewController: UIViewController {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: language.chooseLanguage) {
            label1.text = language.heyThere_Eng
            label2.text = language.welcome_eng
        } else {
            stackView.spacing = 0
            label1.font = UIFont(name: "Khmer OS Bokor", size: 25)
            label2.font = UIFont(name: "Khmer OS Bokor", size: 23)
            label1.text = language.heyThere_Kh
            label2.text = language.welcome_kh
          
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
