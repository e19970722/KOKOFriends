//
//  FriendHeaderView.swift
//  KOKOFriends
//
//  Created by Yen Lin on 2025/5/21.
//

import UIKit

class FriendHeaderView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusLightView: UIView!
    
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
        let nib = UINib(nibName: "FriendHeaderView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        self.contentView = view
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupUI() {
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
        self.statusLightView.layer.cornerRadius = self.statusLightView.frame.size.width / 2
        
    }
}
