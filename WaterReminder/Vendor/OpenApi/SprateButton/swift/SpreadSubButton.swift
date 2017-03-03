//
//  SpreadSubButton.swift
//  SpreadButton
//
//  Created by lzy on 16/1/22.
//  Copyright © 2016年 lzy. All rights reserved.
//

import UIKit

typealias ButtonClickBlock = (_ index: Int, _ sender: UIButton) -> Void

class SpreadSubButton: UIButton {
    
    var clickedBlock: ButtonClickBlock?
    
    init(backgroundImage: UIImage?, highlightImage: UIImage?, clickedBlock: ButtonClickBlock?) {
        
//        guard let nonNilBackgroundImage = backgroundImage else {
//            fatalError("ERROR, image can not be nil")
//        }
        
        let buttonFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        super.init(frame: buttonFrame)
//        self.setImage(nonNilBackgroundImage, for: UIControlState())
        setTitleShadowColor(#colorLiteral(red: 0.4376174212, green: 0.7448593974, blue: 0.9861226678, alpha: 1), for: .normal)
        setTitle("一杯", for: .normal)
        setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        
        if let nonNilHighlightImage = highlightImage {
            self.setBackgroundImage(nonNilHighlightImage, for: .highlighted)
        }
        
        self.clickedBlock = clickedBlock
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
