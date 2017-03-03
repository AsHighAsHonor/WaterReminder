//
//  WaterPlanControlCell.swift
//  WaterReminder
//
//  Created by YYang on 01/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit

class WaterPlanControlCell: UITableViewCell {

    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var timeTypeLab: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    public var toggleChangeClouser : ((_ isOn : Bool)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func toggleValueChanged(_ sender: UISwitch) {
        toggleChangeClouser?(sender.isOn)
    }
    
    
    
    
}
