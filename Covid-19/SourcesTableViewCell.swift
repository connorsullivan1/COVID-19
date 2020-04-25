//
//  SourcesTableViewCell.swift
//  Covid-19
//
//  Created by Connor on 4/21/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//

import UIKit

protocol SourcesTableViewCellDelegate: class {
    func checkBoxToggle(sender: SourcesTableViewCell)
}

class SourcesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var sourceLabel: UILabel!
    
    weak var delegate: SourcesTableViewCellDelegate?
    
    var sourceBool: Bool! {
        didSet {
            checkBoxButton.isSelected = sourceBool
        }
    }
    
    @IBAction func checkToggled(_ sender: UIButton) {
        delegate?.checkBoxToggle(sender: self)
    }
}
