//
//  ToDoListViewController.swift
//  Tver-ToDoList
//
//  Created by Vatana Chhorn on 28/08/2020.
//

import UIKit

class ToDoListViewController: UIViewController, UITableViewDelegate {
  
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryTextField: UITextField!
    let dynamicColor = UIColor { $0.userInterfaceStyle == .dark ? .white : .black }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        // MARK: - button configuration
        initialButtomView()
        
       
        // MARK: - nav bar configure
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // MARK: - Empty data background configuration
        let imageView = UIImageView(frame: CGRect(x: (self.view.frame.width / 2) - (270/2) , y: (self.view.frame.height / 4) + 25  , width: 270, height:180)); // set as you want
        let image = UIImage(named: "NoDataWasFound")
        imageView.image = image
        self.tableView.addSubview(imageView)
        
        // MARK: - Initialize hideKeyboardWhenTappedAround()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Add button click buttom view configuration
    
    public func addButtonClickedView() {
        buttomView.layer.masksToBounds = true
        buttomView.layer.cornerRadius = 15
        buttomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        buttomView.layer.borderWidth = 0.5
        buttomView.layer.borderColor = dynamicColor.cgColor
        
        categoryTextField.isHidden = false
        categoryTextField.becomeFirstResponder()
        
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = 30
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light , scale: .small)
        
        let largeBoldDoc = UIImage(systemName: "plus", withConfiguration: largeConfig)

        addButton.setImage(largeBoldDoc, for: .normal)
        
    }
    
    // MARK: - Button Actions

    
    @IBAction func addButtonDidPressed(_ sender: Any) {
        addButtonClickedView()
        self.tableView.isUserInteractionEnabled = false
    }
    
}

extension ToDoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! ToDoListTableViewCell
        cell.selectionStyle = .none
        cell.listLabel.text = "Fucking crazy!!"
        cell.configure(stringOfRow: String(indexPath.row), stringOfLabel: "Fucking crazy!!")
        cell.delegate = self
        return cell
    }
    
    
}

extension ToDoListViewController: todocelldelegate {
    func buttonDidPressed() {
        print("Done Button Pressed")
    }
    
}

// MARK: - Hide Keyboard When User Tapped Around

extension ToDoListViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ToDoListViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
        self.initialButtomView()
        self.tableView.isUserInteractionEnabled = true
    }
    
    // MARK: - Initial buttom view configuration
    
    func initialButtomView() {
        self.categoryTextField.isHidden = true
        self.buttomView.backgroundColor = .clear
        self.buttomView.layer.borderColor = UIColor.clear.cgColor
        
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = 30
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light , scale: .small)
        
        let largeBoldDoc = UIImage(systemName: "plus", withConfiguration: largeConfig)

        addButton.setImage(largeBoldDoc, for: .normal)
    }
}
