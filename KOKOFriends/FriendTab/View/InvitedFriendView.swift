//
//  InvitedFriendView.swift
//  KOKOFriends
//
//  Created by Yen Lin on 2025/5/22.
//

import UIKit

class InvitedFriendView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
        setupUI()
    }

    private func loadFromNib() {
        let nib = UINib(nibName: "InvitedFriendView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.backgroundColor = .clear
        self.contentView = view
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupUI() {
        self.cardView.layer.shadowColor = UIColor.black.cgColor
        self.cardView.layer.shadowOpacity = 1
        self.cardView.layer.shadowRadius = 16
        self.cardView.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.cardView.layer.masksToBounds = false

        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.masksToBounds = true
    }

}
