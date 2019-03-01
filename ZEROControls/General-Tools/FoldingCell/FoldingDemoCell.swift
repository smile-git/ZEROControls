//
//  FoldingDemoCell.swift
//  FoldingCell
//
//  Created by ZWX on 2019/2/19.
//  Copyright © 2019 ZWX. All rights reserved.
//

import UIKit

class FoldingDemoCell: FoldingCell {

    override func awakeFromNib() {
        
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
