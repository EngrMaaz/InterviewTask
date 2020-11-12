//
//  StateCityTableViewCell.swift
//  InterviewTask
//
//  Created by HAPPY on 12/11/2020.
//

import UIKit

class StateCityTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cityLabel.superview?.superview?.addShadow(offset: CGSize.init(width: 0, height: 3), color: .darkText, radius: 4.0, opacity: 0.2, cornerRadius: 8)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
