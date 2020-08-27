//
//  MainScreenTableViewController.swift
//  Tver-ToDoList
//
//  Created by Vatana Chhorn on 25/08/2020.
//

import UIKit

class MainScreenTableViewController: UITableViewController {
    
    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            // Fallback on earlier versions
            return 25
        }
      }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationbar()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func setupNavigationbar() {
        navigationItem.titleView = titleStackView
        
        let settingButton = UIButton(type: .system)
        settingButton.setImage(#imageLiteral(resourceName: "Profile Picture").withRenderingMode(.alwaysOriginal), for: .normal)
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


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hell"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "performTodolist", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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

}
