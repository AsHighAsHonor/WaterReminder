//
//  WaterPlanSetCell.swift
//  WaterReminder
//
//  Created by YYang on 01/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit

@IBDesignable
class WaterPlanSetCell: UITableViewCell {

    @IBOutlet weak public var setLabel: UILabel!
    @IBOutlet weak public var toggle: UISwitch!
    public var toggleChangeClouser : ((_ isOn : Bool)->())?

    @IBAction public func toggleValueChanged(_ sender: UISwitch) {
        toggleChangeClouser?(sender.isOn)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
