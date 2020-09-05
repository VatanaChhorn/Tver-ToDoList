//
//  ToDoListTableViewCell.swift
//  Tver-ToDoList
//
//  Created by Vatana Chhorn on 27/08/2020.
//

import UIKit

protocol todocelldelegate {
    func buttonDidPressed(numberOfRowSelected: Int)
}

class ToDoListTableViewCell: UITableViewCell {
   
    
    static let dynamicColor = UIColor { $0.userInterfaceStyle == .dark ? .white : .black }
    var numberOfRowSelected: Int?
    var labelString: String?
    var delegate: todocelldelegate?
    
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var listLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doneButton.layer.borderWidth = 2
        doneButton.layer.cornerRadius = 15
        doneButton.layer.masksToBounds = true
        doneButton.layer.borderColor = ToDoListTableViewCell.dynamicColor.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(stringOfRow: Int, stringOfLabel: String) {
        self.numberOfRowSelected = stringOfRow
        self.labelString = stringOfLabel
    }
    
    @IBAction func buttonDidSelected(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        delegate?.buttonDidPressed(numberOfRowSelected: numberOfRowSelected!)
    }
    
}

