//
//  UZTextViewCell.swift
//  reddift
//
//  Created by sonson on 2015/09/03.
//  Copyright © 2015年 sonson. All rights reserved.
//

import UIKit

class UZTextViewCell: UITableViewCell {
    @IBOutlet var textView: UZTextView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
