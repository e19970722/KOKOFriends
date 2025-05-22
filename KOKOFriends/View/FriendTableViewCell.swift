//
//  FriendTableViewCell.swift
//  KOKOFriends
//
//  Created by Yen Lin on 2025/5/22.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var invitingBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
