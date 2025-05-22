//
//  FriendViewController.swift
//  KOKOFriends
//
//  Created by Yen Lin on 2025/5/21.
//

import UIKit

class FriendViewController: UIViewController {
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    private let headerView = FriendHeaderView()
    private let invitedFriendView = InvitedFriendView()
    private let noFriendView = NoFriendsView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        
        self.invitedFriendView.backgroundColor = .red
        self.noFriendView.backgroundColor = .yellow
        
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.invitedFriendView.translatesAutoresizingMaskIntoConstraints = false
        self.noFriendView.translatesAutoresizingMaskIntoConstraints = false
        
        self.headerStackView.addArrangedSubview(self.headerView)
        self.headerStackView.addArrangedSubview(self.invitedFriendView)
        self.headerStackView.addArrangedSubview(self.noFriendView)
        
        NSLayoutConstraint.activate([
            self.headerView.heightAnchor.constraint(equalToConstant: 134),
            self.invitedFriendView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        self.view.addSubview(self.headerStackView)
        self.headerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.headerStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            self.headerView.heightAnchor.constraint(equalToConstant: 480)
        ])
    }
}
