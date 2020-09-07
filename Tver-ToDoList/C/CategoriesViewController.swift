//
//  CategoriesViewController.swift
//  Tver-ToDoList
//
//  Created by Vatana Chhorn on 28/08/2020.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift

class CategoriesViewController: UIViewController, UITableViewDelegate, SettingViewDelegate {
    func update() {
        setupNavigationbar()
    }
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    var dynamicColor = UIColor { $0.userInterfaceStyle == .dark ? .white : .black }
    let backgroundColor = UIColor { $0.userInterfaceStyle == .dark ?   #colorLiteral(red: 0.137254902, green: 0.1490196078, blue: 0.1803921569, alpha: 1)  : #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)}
    var catagoryArray: Results<Catagories>?
    var rowSelected: Int = 0
    let realm = try! Realm()
    var checkingButton = false
    var checkingTableView : Bool = false
    // TableView 1 False
    // TableView True
    var checkingAllAndTodayCatagory: Bool = false
    // All = False
    // Today = True
    
    // MARK: - Calculate topbarheight
    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            // Fallback on earlier versions
            return 25
        }
    }
    
    // MARK: - navbar title configuration
    lazy var titleStackView: UIStackView = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        let username = UserDefaults.standard.string(forKey: Names.username)
        if let safeUsername = username  {
            titleLabel.text = "Hi \(safeUsername),"
        } else {
            titleLabel.text = "Hi there,"
        }
        titleLabel.font = .boldSystemFont(ofSize: 17)
        let subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .left
        subtitleLabel.text = "Are you ready to conquer another day? "
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    //MARK: - Data Manipulation
    func loadItem ()  {
        catagoryArray = realm.objects(Catagories.self)
        tableView.reloadData()
    }
    
    func saveItem(catagory: Catagories)  {
        do {
            try realm.write {
                realm.add(catagory)
            }
        } catch  {
            print("Save item error: \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !UserDefaults.standard.bool(forKey: "FirstTableView") {
            initializeAllCategory()
            UserDefaults.standard.set(true, forKey: "FirstTableView")
        }
        
        // MARK: - nav bar configure
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Prepare haptic feedback
        UIImpactFeedbackGenerator().prepare()
    }
    
    // MARK: -  ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.isScrollEnabled = false
        
        //First tableView Configure
        
        let topBorder = CAShapeLayer()
        let topPath = UIBezierPath()
        topPath.move(to: CGPoint(x: 0, y: 0))
        topPath.addLine(to: CGPoint(x: tableView1.frame.width, y: 0))
        topBorder.path = topPath.cgPath
        topBorder.strokeColor = UIColor.gray.cgColor
        topBorder.lineWidth = 1
        topBorder.fillColor = UIColor.gray.cgColor
        tableView1.layer.addSublayer(topBorder)
        
        let bottomBorder = CAShapeLayer()
        let bottomPath = UIBezierPath()
        bottomPath.move(to: CGPoint(x: 0, y: tableView1.frame.height))
        bottomPath.addLine(to: CGPoint(x: tableView1.frame.width, y: tableView1.frame.height))
        bottomBorder.path = bottomPath.cgPath
        bottomBorder.strokeColor = UIColor.gray.cgColor
        bottomBorder.lineWidth = 1
        bottomBorder.fillColor = UIColor.gray.cgColor
        tableView1.layer.addSublayer(bottomBorder)
        
        // Buttom View Configuration
        initialButtomView()
        // MARK: - Navigationbar configuration
        setupNavigationbar()
        // MARK: - button configuration
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = 30
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light , scale: .small)
        let largeBoldDoc = UIImage(systemName: "plus", withConfiguration: largeConfig)
        addButton.setImage(largeBoldDoc, for: .normal)
        
        //Initialize hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(ToDoListViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // MARK: - Load item from Realm
        loadItem()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.initialButtomView()
        self.tableView.isUserInteractionEnabled = true
        checkingButton = false
    }
    
    // MARK: - Add button click buttom view configuration
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
    
    // MARK: - ViewDidLoad buttom view configuration
    
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
    
    // MARK: - Customize Navigation Bar
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if view.traitCollection.horizontalSizeClass == .compact {
            titleStackView.axis = .vertical
            titleStackView.spacing = UIStackView.spacingUseDefault
        } else {
            titleStackView.axis = .horizontal
            titleStackView.spacing = UIStackView.spacingUseDefault
        }
    }
    
    private func setupNavigationbar() {
        navigationItem.titleView = titleStackView
        let settingButton = UIButton(type: .system)
        let imageData = UserDefaults.standard.object(forKey: Names.displayProfile) as? Data
        if let safeImageData = imageData {
            settingButton.setImage(UIImage(data: safeImageData)?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            settingButton.setImage(#imageLiteral(resourceName: "Profile Picture").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        settingButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        settingButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        settingButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        settingButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        settingButton.layer.cornerRadius = settingButton.frame.height / 2.0
        settingButton.layer.masksToBounds = true
        settingButton.clipsToBounds = true
        settingButton.layer.borderColor = dynamicColor.cgColor
        settingButton.layer.borderWidth = 0.5
        let menuBarItem = UIBarButtonItem(customView: settingButton)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: topbarHeight)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: topbarHeight)
        currHeight?.isActive = true
        self.navigationItem.leftBarButtonItem = menuBarItem
    }
    
    // MARK: - Button Action
    
    @objc func buttonAction(sender: UIButton!) {
        performSegue(withIdentifier: "settingControllerSegue", sender: self)
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
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

    }
}


// MARK: - Tableview Extension

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView1 {
            return 2
        } else {
            return catagoryArray!.count - 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView1 {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            cell1.textLabel?.text = catagoryArray?[indexPath.row].name
            return cell1
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = self.catagoryArray?[indexPath.row + 2 ].name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView1 {
            self.checkingTableView = false
            self.rowSelected = indexPath.row
        } else {
            self.checkingTableView = true
            self.rowSelected = indexPath.row + 2
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "performTodolistSegue", sender: self)
    }
    
    // MARK: - prepare function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "performTodolistSegue" {
            let destinationVC = segue.destination  as! ToDoListViewController
            destinationVC.selectedCatagory = catagoryArray?[rowSelected]
            destinationVC.allCatagory = catagoryArray?[0]
            destinationVC.checkTableView =  checkingTableView
            //passing current Date
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .short
            formatter.timeZone = TimeZone.current
            let currentDate = formatter.string(from: Date())
            destinationVC.currentDate = currentDate
            
            //Checking TableView
            if rowSelected == 0 {
                destinationVC.checkingAllAndTodayCatagory = false
            } else if rowSelected == 1 {
                destinationVC.checkingAllAndTodayCatagory = true
            }
        } else if segue.identifier == Names.SettingSegue {
            let destinationVC = segue.destination as! SettingViewController
            destinationVC.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView != self.tableView1 {
            return true
        } else {
            return false 
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView != self.tableView1 {
            if (editingStyle == .delete) {
                try! self.realm.write {
                    if let currentCatagory = self.catagoryArray?[indexPath.row + 2]
                    {
                        self.realm.delete(currentCatagory)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension CategoriesViewController {
    
    // MARK: -  Add item to catagories
    
    func addItem() {
        let newCatagory = Catagories()
        if categoryTextField.text!.count != 0 {
            let newString = categoryTextField.text?.prefix(20).lowercased()
            newCatagory.name = newString!
            self.saveItem(catagory: newCatagory)
            self.categoryTextField.text = ""
            self.checkingButton.toggle()
        }
    }
    
    func initializeAllCategory() {
        let allCatagory = Catagories()
        let todayCatagory = Catagories()
        allCatagory.name = "All"
        todayCatagory.name = "Today"
        self.saveItem(catagory: allCatagory)
        self.saveItem(catagory: todayCatagory)
    }
}

