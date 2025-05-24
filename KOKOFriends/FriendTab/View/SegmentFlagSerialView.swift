//
//  SegmentFlagSerialView.swift
//  KOKOFriends
//
//  Created by Yen Lin on 2025/5/23.
//

import UIKit

class SegmentFlagSerialView: UIView {
    
    var segmentTitleArr: [String]
    var selectedIndex: Int = 0
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15.5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(segmentTitleArr: [String], selectedIndex: Int) {
        self.segmentTitleArr = segmentTitleArr
        self.selectedIndex = selectedIndex
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        for (index, title) in segmentTitleArr.enumerated() {
            let segmentFlagView = SegmentFlagView()
            // TODO: ⚠️ 分別控管不同Segment狀態
            segmentFlagView.flagLabel.text = (index == self.selectedIndex) ? "2" : "99+"
            segmentFlagView.isSelected = (index == self.selectedIndex) ? true : false
            segmentFlagView.titleLabel.text = title
            stackView.addArrangedSubview(segmentFlagView)
            NSLayoutConstraint.activate([
                segmentFlagView.widthAnchor.constraint(equalToConstant: 64)
            ])
        }
    }

}
