//
//  CategoriesViewController.swift
//  Tver-ToDoList
//
//  Created by Vatana Chhorn on 28/08/2020.
//

import UIKit
import IQKeyboardManagerSwift

class CategoriesViewController: UIViewController, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
     
        
        // MARK: - Navigationbar configuration
        
        setupNavigationbar()
        
        // MARK: - button configuration
        buttomView.layer.masksToBounds = true
        buttomView.layer.cornerRadius = 15
        buttomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        buttomView.layer.borderWidth = 0.5
        buttomView.layer.borderColor = dynamicColor.cgColor
        
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = 30
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light , scale: .small)
        
        let largeBoldDoc = UIImage(systemName: "plus", withConfiguration: largeConfig)

        addButton.setImage(largeBoldDoc, for: .normal)
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

    @objc func buttonAction(sender: UIButton!) {
        performSegue(withIdentifier: "settingControllerSegue", sender: self)
     }
    
}

extension CategoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hell"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "performTodolistSegue", sender: self)
        print("row selected")
    }
    
    
}

