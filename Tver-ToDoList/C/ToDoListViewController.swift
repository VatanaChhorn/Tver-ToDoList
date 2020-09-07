//
//  ToDoListViewController.swift
//  Tver-ToDoList
//
//  Created by Vatana Chhorn on 28/08/2020.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift

class ToDoListViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryTextField: UITextField!
    
    var finishedItems: Array<String> = []
    var checkingButton : Bool = false
    var itemArray : Results<Items>?
    var realm = try! Realm()
    var selectedCatagory : Catagories?
    var allCatagory : Catagories?
    let dynamicColor = UIColor { $0.userInterfaceStyle == .dark ? .white : .black }
    let backgroundColor = UIColor { $0.userInterfaceStyle == .dark ?   #colorLiteral(red: 0.137254902, green: 0.1490196078, blue: 0.1803921569, alpha: 1)  : #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)}
    let doneButtonColor = UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 0.93, green: 0.55, blue: 0.40, alpha: 1.00) : UIColor(red: 0.97, green: 0.84, blue: 0.22, alpha: 1.00) }
    var height: CGFloat = 0
    var checkTableView: Bool = false
    /*    False = tableView1
     True = TableView
     */
    var checkingAllAndTodayCatagory: Bool = false
    /*     All = False
     Today = True
     */
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
    
    // MARK: - ViewWillDissapear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
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
    
    // MARK: - Viewdidload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadItem()
        
        //Initialize hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(ToDoListViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.initialButtomView()
        self.tableView.isUserInteractionEnabled = true
        checkingButton = false
    }
    
    //Add button click buttom view configuration
    
    public func addButtonClickedView() {
        buttomView.layer.masksToBounds = true
        buttomView.layer.cornerRadius = 15
        buttomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        buttomView.layer.borderWidth = 0.5
        buttomView.layer.borderColor = dynamicColor.cgColor
        buttomView.layer.backgroundColor = backgroundColor.cgColor
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
        if !checkingButton {
            addItem()
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            checkingButton.toggle()
            self.initialButtomView()
            self.tableView.isUserInteractionEnabled = true
            IQKeyboardManager.shared.resignFirstResponder()
        } else {
            self.tableView.isUserInteractionEnabled = false
            addButtonClickedView()
        }
        self.categoryTextField.text = ""
    }
    
}

// MARK: - Table View Controller

extension ToDoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfData = itemArray?.count ?? 0
        let doneArray = finishedItems.count
        checkingData = numberOfData + doneArray
        return numberOfData + doneArray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! ToDoListTableViewCell
        
        // MARK: - Done button with table cells configuration
        
        cell.selectionStyle = .none
        if (indexPath.row) < itemArray!.count  {
            let item = itemArray?[indexPath.row]
            let attributeString =  NSMutableAttributedString(string: item!.title)
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle,range: NSMakeRange(0, attributeString.length))
            cell.listLabel.attributedText = attributeString
            cell.listLabel.text = item?.title
            cell.doneButton.isUserInteractionEnabled = true
            cell.doneButton.layer.backgroundColor = UIColor.clear.cgColor
            cell.doneButton.layer.borderWidth = 2
            cell.doneButton.setImage(UIImage(), for: .normal)
            cell.doneButton.tintColor = .clear
            cell.configure(stringOfRow: indexPath.row, stringOfLabel: item!.title)
            
            cell.delegate = self
            return cell
        } else {
            let finishItemLocation = (finishedItems.count - (indexPath.row - itemArray!.count)) - 1
            let item = finishedItems[finishItemLocation]
            cell.doneButton.isUserInteractionEnabled = false
            cell.doneButton.layer.backgroundColor = doneButtonColor.cgColor
            cell.doneButton.layer.borderWidth = 0
            cell.doneButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            cell.doneButton.tintColor = .white
            let attributeString =  NSMutableAttributedString(string: item)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                         value: NSUnderlineStyle.single.rawValue,
                                         range: NSMakeRange(0, attributeString.length))
            cell.listLabel.attributedText = attributeString
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if indexPath.row < itemArray!.count {
            if (editingStyle == .delete) {
                deleteData(indexPath: indexPath.row)
            }
        }
    }
}

extension ToDoListViewController {
    
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
        let lastID = UserDefaults.standard.integer(forKey: Names.databaseID)
        let newID = lastID + 1;
        UserDefaults.standard.set(newID, forKey: Names.databaseID)
        if let  currentCatagory = self.selectedCatagory {
            if categoryTextField.text! != ""  {
                let newString = categoryTextField.text?.prefix(50).lowercased()
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
                        self.categoryTextField.text = ""
                        self.loadItem()
                    })
                } catch  {
                    print("Error saving item \(error)")
                }
            }
        }
        categoryTextField.text = ""
    }
    
    // MARK: - Deleting Data
    func deleteData (indexPath : Int) {
        var object: Items? 
        if checkTableView {
            object = realm.objects(Items.self).filter("id == %@", self.selectedCatagory?.items[indexPath].id as Any).first
        } else {
            object = realm.objects(Items.self).filter("id == %@", self.allCatagory?.items[indexPath].id as Any).first
        }
        try! realm.write {
            if let obj = object {
                realm.delete(obj)
                loadItem()
            }
        }
    }
}

// MARK: - todoCell delegate

extension ToDoListViewController: todocelldelegate {
    func buttonDidPressed(numberOfRowSelected: Int) {
        if checkTableView {
            finishedItems.append((self.selectedCatagory?.items[numberOfRowSelected].title)!)
        } else {
            finishedItems.append((self.allCatagory?.items[numberOfRowSelected].title)!)
        }
        deleteData(indexPath: numberOfRowSelected)
        loadItem()
    }
    
}
