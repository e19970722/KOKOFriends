//
//  NoFriendsView.swift
//  KOKOFriends
//
//  Created by Yen Lin on 2025/5/22.
//

import UIKit

class NoFriendsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var addFriendBtn: UIButton!
    @IBOutlet weak var setIDBtn: UIButton!
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [weak self] in
            self?.applyAddBtnGradient()
        }
    }

    private func loadFromNib() {
        let nib = UINib(nibName: "NoFriendsView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        self.contentView = view
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }

    private func setupUI() {
        self.addFriendBtn.layer.cornerRadius = 20
        self.addFriendBtn.clipsToBounds = true
        
        let setIDBtnAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.hotPink,
            .font: UIFont.systemFont(ofSize: 13)
        ]
        
        let setIDBtnAttributedTitle = NSAttributedString(string: "設定 KOKO ID", attributes: setIDBtnAttributes)
        setIDBtn.setAttributedTitle(setIDBtnAttributedTitle, for: .normal)
    }
    
    private func applyAddBtnGradient() {
        self.addFriendBtn.layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach { $0.removeFromSuperlayer() }

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.addFriendBtn.bounds
        gradientLayer.colors = [
            UIColor.frogGreen.cgColor,
            UIColor.b.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = self.addFriendBtn.layer.cornerRadius

        self.addFriendBtn.layer.insertSublayer(gradientLayer, at: 0)
        
    }
}
