//
//  setupProfileViewController.swift
//  Tver-ToDoList
//
//  Created by Vatana Chhorn on 25/08/2020.
//

import UIKit

class setupProfileViewController: UIViewController {

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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainScreen") as! UITableViewController
        mainVC.modalPresentationStyle = .fullScreen 
        self.present(mainVC, animated: true, completion: nil)
    }
    
}

