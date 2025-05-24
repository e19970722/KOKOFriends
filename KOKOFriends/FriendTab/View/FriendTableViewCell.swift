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
    
    @IBOutlet weak var transferBtn: UIButton!
    @IBOutlet weak var inviteBtn: UIButton!

    @IBOutlet weak var moreBtn: UIButton!
    
    var isFavorite: Bool = false {
        didSet {
            self.starImageView.alpha = self.isFavorite ? 1.0 : 0.0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        self.transferBtn.layer.borderWidth = 1.2
        self.transferBtn.layer.borderColor = UIColor.hotPink.cgColor
        self.transferBtn.layer.cornerRadius = 2
        self.transferBtn.clipsToBounds = true
        
        self.inviteBtn.layer.borderWidth = 1.2
        self.inviteBtn.layer.borderColor = UIColor.pinkishGrey.cgColor
        self.inviteBtn.layer.cornerRadius = 2
        self.inviteBtn.clipsToBounds = true
    }
    
    func configCell(friend: Friend) {
        self.nameLabel.text = friend.name
        self.friendImageView.image = .imgFriendsList
        self.isFavorite = friend.isTop
        switch friend.status {
        case .inviting:
            self.inviteBtn.isHidden = false
            self.moreBtn.isHidden = true
        default:
            self.inviteBtn.isHidden = true
            self.moreBtn.isHidden = false
        }
    }
}
