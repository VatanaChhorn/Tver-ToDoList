//
//  ToDoListTableViewCell.swift
//  Tver-ToDoList
//
//  Created by Vatana Chhorn on 27/08/2020.
//

import UIKit

protocol todocelldelegate {
    func buttonDidPressed()
}

class ToDoListTableViewCell: UITableViewCell {
   
    
    static let dynamicColor = UIColor { $0.userInterfaceStyle == .dark ? .white : .black }
    var numberOfRowSelected: String?
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
    
    func configure(stringOfRow: String, stringOfLabel: String) {
        self.numberOfRowSelected = stringOfRow
        self.labelString = stringOfLabel
    }
    
    @IBAction func buttonDidSelected(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        print(numberOfRowSelected ?? "No Data")
        doneButton.layer.backgroundColor = UIColor(red: 0.97, green: 0.84, blue: 0.22, alpha: 1.00).cgColor
        doneButton.layer.borderWidth = 0
        doneButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        doneButton.tintColor = .white
        let attributeString =  NSMutableAttributedString(string: self.labelString!)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                             value: NSUnderlineStyle.single.rawValue,
                                                 range: NSMakeRange(0, attributeString.length))
        listLabel.attributedText = attributeString
        delegate?.buttonDidPressed()
    }
    
}

