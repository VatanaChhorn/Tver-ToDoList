//
//  SettingViewControllerViewController.swift
//  Pods
//
//  Created by Vatana Chhorn on 28/08/2020.
//

import UIKit

class SettingViewController: UIViewController {
    
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

    @IBAction func finishButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
        }
    }

