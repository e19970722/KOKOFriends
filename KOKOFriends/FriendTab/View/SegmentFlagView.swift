//
//  SegmentFlagView.swift
//  KOKOFriends
//
//  Created by Yen Lin on 2025/5/23.
//

import UIKit

class SegmentFlagView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var flagLabel: FlagLabel!
    
    var isSelected: Bool = false {
        didSet {
            self.titleLabel.font = .systemFont(ofSize: 13,
                                               weight: self.isSelected ? .medium : .regular)
            self.bottomLineView.alpha = self.isSelected ? 1.0 : 0.0
        }
    }
    var showFlag: Bool = false
    
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
        let nib = UINib(nibName: "SegmentFlagView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.backgroundColor = .clear
        self.contentView = view
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupUI() {
        self.bottomLineView.layer.cornerRadius = 2
        self.flagLabel.layer.cornerRadius = self.flagLabel.frame.height / 2
        self.flagLabel.clipsToBounds = true
    }
    
}

class FlagLabel: UILabel {

    var textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}
