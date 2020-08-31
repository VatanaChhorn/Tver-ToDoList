//
//  CategoriesViewController.swift
//  Tver-ToDoList
//
//  Created by Vatana Chhorn on 28/08/2020.
//

import UIKit
import IQKeyboardManagerSwift

class CategoriesViewController: UIViewController, UITableViewDelegate {

    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    var menuItem = ["Today", "All"]
    
    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            // Fallback on earlier versions
            return 25
        }
      }
    
    var dynamicColor = UIColor { $0.userInterfaceStyle == .dark ? .white : .black }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // MARK: - nav bar configure
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Prepare haptic feedback
        UIImpactFeedbackGenerator().prepare()
    }

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
        
        // MARK: - keyboard configure
        self.hideKeyboardWhenTappedAround()
        

    
  
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
    }
    
    // MARK: - ViewDidLoad buttom view configuration
    
    func initialButtomView() {
        self.categoryTextField.isHidden = true
        self.buttomView.backgroundColor = .clear
        self.buttomView.layer.borderColor = UIColor.clear.cgColor
    }
    
    // MARK: - Customize Navigation Bar
    
    lazy var titleStackView: UIStackView = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.text = "Hi Vatana,"
        titleLabel.font = .boldSystemFont(ofSize: 17)
        let subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .left
        subtitleLabel.text = "Are you ready to conquer another day? "
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        return stackView
    }()

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
        settingButton.setImage(#imageLiteral(resourceName: "Profile Picture").withRenderingMode(.alwaysOriginal), for: .normal)
        settingButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        settingButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        settingButton.layer.cornerRadius = 25
        settingButton.layer.masksToBounds = true
        
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
        addButtonClickedView()
        self.tableView.isUserInteractionEnabled = false
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    
}

extension CategoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView1 {
            return 2
        } else {
            return 5
        }
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView1 {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            cell1.textLabel?.text = menuItem[indexPath.row]
            return cell1
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
          
            cell.textLabel?.text = "Hell"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "performTodolistSegue", sender: self)
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        
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
                print(indexPath.row)
            }
        }
    }
    
    
    
    
}


// MARK: - Hide Keyboard When User Tapped Around

extension CategoriesViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CategoriesViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
        self.initialButtomView()
        self.tableView.isUserInteractionEnabled = true
        
    }
}
