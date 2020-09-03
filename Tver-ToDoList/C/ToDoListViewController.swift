//
//  ToDoListViewController.swift
//  Tver-ToDoList
//
//  Created by Vatana Chhorn on 28/08/2020.
//

import UIKit
import RealmSwift

class ToDoListViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryTextField: UITextField!
    
    var checkingButton : Bool = false
    var itemArray : Results<Items>?
    var realm = try! Realm()
    var selectedCatagory : Catagories?
    var allCatagory : Catagories?
    let dynamicColor = UIColor { $0.userInterfaceStyle == .dark ? .white : .black }
    let backgroundColor = UIColor { $0.userInterfaceStyle == .dark ?   #colorLiteral(red: 0.2549999952, green: 0.2669999897, blue: 0.2939999998, alpha: 1)  : #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)}
    var height: CGFloat = 0
    var checkTableView: Bool = false
    //False = tableView1
    //True = TableView
    var checkingAllAndTodayCatagory: Bool = false
    // All = False
    // Today = True
    var currentDate: String = ""
    //Declare date
    let formatter = DateFormatter()
    var checkingData: Int = 0 {
        didSet {
            if checkingData == 0 && height != 0 {
                let imageView = UIImageView(frame: CGRect(x: (self.view.frame.width / 2) - (270/2) , y: height , width: 270, height:180));
                imageView.image = UIImage(named: "NoDataWasFound")
                self.tableView.addSubview(imageView)
            } else {
                for view in self.tableView.subviews {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    
    //MARK: - Data manipulation
    
    func saveItem (newItem: Items )  {
        do {
            try self.realm.write({
                self.realm.add(newItem)
            })
        } catch  {
            print("Error saving new Item \(error)")
        }
        //Reloads the rows and sections of the table view.
        self.tableView.reloadData()
    }
    
    //MARK: - Create Load Item Function
    
    func loadItem () {
        if checkTableView {
            itemArray = selectedCatagory?.items.sorted(byKeyPath: "id", ascending: true)
            self.titleLabel.text = selectedCatagory?.name
            if (self.selectedCatagory?.name.count)! < 4 {
                self.titleLabel.textAlignment = .center
            }
        } else {
            if checkingAllAndTodayCatagory {
                itemArray = allCatagory?.items.filter("date CONTAINS[cd] %@", currentDate).sorted(byKeyPath: "id", ascending: true)
                self.titleLabel.text = "Today"
            } else {
                itemArray = allCatagory?.items.sorted(byKeyPath: "id", ascending: true)
                self.titleLabel.text = "All"
                self.titleLabel.textAlignment = .center
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        height = ((self.view.frame.height / 4))
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.timeZone = TimeZone.current
        
        // MARK: - button configuration
        initialButtomView()
        
        // MARK: - nav bar configure
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = dynamicColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadItem()
        
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
        checkingButton.toggle()
        addButtonClickedView()
        self.tableView.isUserInteractionEnabled = false
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    
}

// MARK: - Table View Controller

extension ToDoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfData = itemArray?.count ?? 0
        checkingData = numberOfData
        return numberOfData
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! ToDoListTableViewCell
        cell.selectionStyle = .none
        let item = itemArray?[indexPath.row]
        cell.listLabel.text = item?.title
        cell.configure(stringOfRow: String(indexPath.row), stringOfLabel: item!.title)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            try! self.realm.write { 
                if let currentItem = self.selectedCatagory?.items[indexPath.row]
                {
                    self.realm.delete(currentItem)
                    self.tableView.reloadData()
                }
            }
        }
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
        if checkingButton {
            addItem()
            checkingButton.toggle()
        }
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
    
    // MARK: - Add Item Function
    
    func addItem () {
        let all = self.allCatagory
        let lastID = self.selectedCatagory!.items.last?.id ?? 0
        let newID = lastID + 1;
        if let  currentCatagory = self.selectedCatagory {
            if categoryTextField.text! != ""  {
                let newString = categoryTextField.text?.prefix(30).lowercased()
                do {
                    try self.realm.write({
                        let newItem = Items()
                        newItem.title = newString!
                        newItem.date =  formatter.string(from: Date())
                        newItem.id = newID
                        if checkTableView {
                            currentCatagory.items.append(newItem)
                            all?.items.append(newItem)
                        } else {
                            all?.items.append(newItem)
                        }
                        self.tableView.reloadData()
                    })
                } catch  {
                    print("Error saving item \(error)")
                }
            }
        }
        categoryTextField.text = ""
    }
}
