//
//  CommentTableViewCell.swift
//  Blocstagram
//
//  Created by ddenis on 1/20/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
