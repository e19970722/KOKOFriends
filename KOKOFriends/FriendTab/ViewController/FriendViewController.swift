//
//  FriendViewController.swift
//  KOKOFriends
//
//  Created by Yen Lin on 2025/5/21.
//

import UIKit
import Combine

class FriendViewController: UIViewController {
    
    // viewWillAppear 的 fetchInfo function 可調整不同情境
    
    // MARK: - Properties
    private var viewModel = FriendViewModel()
    private let input: PassthroughSubject<FriendViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    /// 是否顯示無好友圖
    private var isNoFriend = false
    /// 選擇第幾個Segment
    private var selectedSegmentIndex = 0 {
        // TODO: ⚠️ 寫成 Segment Array 控管
        didSet {
            if self.selectedSegmentIndex == 0 {
                self.friendFlagView.isSelected = true
                self.chatFlagView.isSelected = false
            } else {
                self.friendFlagView.isSelected = false
                self.chatFlagView.isSelected = true
            }
        }
    }
    
    // MARK: - Views
    private lazy var headerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteTwo
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var invitedFriendHeightConstraint: NSLayoutConstraint? = nil
    
    private lazy var invitedFriendStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let navigationView = FriendNavigationView()
    private let mainInfoView = FriendMainInfoView()
    
    private lazy var segmentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 15.5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var friendFlagView: SegmentFlagView = {
        let flagView = SegmentFlagView()
        flagView.titleLabel.text = "好友"
        flagView.isSelected = false
        flagView.flagLabel.isHidden = true
        flagView.translatesAutoresizingMaskIntoConstraints = false
        return flagView
    }()
    
    private lazy var chatFlagView: SegmentFlagView = {
        let flagView = SegmentFlagView()
        flagView.titleLabel.text = "聊天"
        flagView.isSelected = false
        flagView.flagLabel.isHidden = true
        flagView.translatesAutoresizingMaskIntoConstraints = false
        return flagView
    }()
    
    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .veryLightPink2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let noFriendView = NoFriendsView()
    private let searchBarView = FriendSearchView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "\(FriendTableViewCell.self)", bundle: nil),
                           forCellReuseIdentifier: "\(FriendTableViewCell.self)")
        return tableView
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.bindViewModel()
        self.addSubscription()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 🟠 點入選擇發送不同狀態資訊
        self.fetchInfo()
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        self.navigationView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.navigationView)
        NSLayoutConstraint.activate([
            self.navigationView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.navigationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.navigationView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.navigationView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        self.mainInfoView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.mainInfoView)
        NSLayoutConstraint.activate([
            self.mainInfoView.topAnchor.constraint(equalTo: self.navigationView.bottomAnchor, constant: 27),
            self.mainInfoView.leadingAnchor.constraint(equalTo: self.navigationView.leadingAnchor, constant: 10),
            self.mainInfoView.trailingAnchor.constraint(equalTo: self.navigationView.trailingAnchor, constant: -10),
            self.mainInfoView.heightAnchor.constraint(equalToConstant: 52)
        ])
        
        self.view.addSubview(self.invitedFriendStackView)
        NSLayoutConstraint.activate([
            self.invitedFriendStackView.topAnchor.constraint(equalTo: self.mainInfoView.bottomAnchor, constant: 25),
            self.invitedFriendStackView.leadingAnchor.constraint(equalTo: self.mainInfoView.leadingAnchor),
            self.invitedFriendStackView.trailingAnchor.constraint(equalTo: self.mainInfoView.trailingAnchor),
        ])
        
        self.invitedFriendHeightConstraint = self.invitedFriendStackView.heightAnchor.constraint(equalToConstant: 0)
        self.invitedFriendHeightConstraint?.isActive = true
        
        self.selectedSegmentIndex = 0
        self.segmentStackView.addArrangedSubview(self.friendFlagView)
        self.segmentStackView.addArrangedSubview(self.chatFlagView)
        NSLayoutConstraint.activate([
            self.friendFlagView.widthAnchor.constraint(equalToConstant: 26+3+30),
            self.chatFlagView.widthAnchor.constraint(equalToConstant: 26+3+30)
        ])
        
        self.view.addSubview(self.segmentStackView)
        NSLayoutConstraint.activate([
            self.segmentStackView.topAnchor.constraint(equalTo: self.invitedFriendStackView.bottomAnchor, constant: 15),
            self.segmentStackView.leadingAnchor.constraint(equalTo: self.mainInfoView.leadingAnchor),
            self.segmentStackView.trailingAnchor.constraint(equalTo: self.mainInfoView.trailingAnchor),
            self.segmentStackView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        self.headerBackgroundView.addSubview(self.seperatorView)
        NSLayoutConstraint.activate([
            self.seperatorView.leadingAnchor.constraint(equalTo: self.headerBackgroundView.leadingAnchor),
            self.seperatorView.trailingAnchor.constraint(equalTo: self.headerBackgroundView.trailingAnchor),
            self.seperatorView.bottomAnchor.constraint(equalTo: self.headerBackgroundView.bottomAnchor),
            self.seperatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        self.view.insertSubview(self.headerBackgroundView, at: 0)
        NSLayoutConstraint.activate([
            self.headerBackgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.headerBackgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerBackgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerBackgroundView.bottomAnchor.constraint(equalTo: self.segmentStackView.bottomAnchor)
        ])
        
        self.view.addSubview(self.noFriendView)
        self.noFriendView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.noFriendView.topAnchor.constraint(equalTo: self.seperatorView.bottomAnchor),
            self.noFriendView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.noFriendView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.noFriendView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.noFriendView.isHidden = true
        
        self.view.addSubview(self.searchBarView)
        self.searchBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.searchBarView.topAnchor.constraint(equalTo: self.seperatorView.bottomAnchor, constant: 15),
            self.searchBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.searchBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.searchBarView.heightAnchor.constraint(equalToConstant: 61)
        ])
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.searchBarView.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.searchBarView.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.searchBarView.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .fetchMainInfoDidSucceed(let mainInfoResponse):
                    guard let mainInfo = mainInfoResponse.response.first else { return }
                    self.updateMainInfo(response: mainInfo)
                    
                case .fetchMainInfoDidFail(let error):
                    self.showAlert(title: "訊息",
                                   message: "使用者資料取得失敗\n原因：\(error.localizedDescription)，請重新再試。")
                    
                case .fetchFriendsDidSucceed(let type, let friendResponse):
                    switch type {
                    case .friend1, .friend2:
                        self.viewModel.friends = friendResponse.response
                        self.viewModel.filteredFriends = self.viewModel.combineFriends(returnedFriends: friendResponse.response)
                        self.tableView.reloadData()
                        
                    case .noInvitingList, .friendWithInvitingList:
                        self.viewModel.invitingFriends = friendResponse.response
                    }
                    
                case .fetchFriendsDidFail(let type, let error):
                    self.showAlert(title: "訊息",
                                   message: "\(type.typeName)取得失敗\n原因：\(error.localizedDescription)，請重新再試。")
                }
            }.store(in: &cancellables)
    }
    
    /// 訂閱項目
    private func addSubscription() {
        self.viewModel.$invitingFriends
            .sink { [weak self] returnedInvitingFriends in
            guard let self = self else { return }
            let friendsCount = returnedInvitingFriends.count
            if friendsCount > 0 {
                self.createfriendInvitationCard(invitingFriends: returnedInvitingFriends)
                self.friendFlagView.flagLabel.text = (friendsCount > 99) ? "99+" : "\(friendsCount)"
                self.friendFlagView.flagLabel.alpha = 1.0
            } else {
                self.friendFlagView.flagLabel.alpha = 0.0
            }
        }.store(in: &cancellables)
        
        NotificationCenter
            .default
            .publisher(for: UITextField.textDidChangeNotification, object: self.searchBarView.textField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { [weak self] text in
                guard let self = self else { return }

                if text.isEmpty {
                    self.viewModel.filteredFriends = self.viewModel.friends
                } else {
                    self.viewModel.filteredFriends = self.viewModel.friends.filter {
                        $0.name.localizedStandardContains(text)
                    }
                }
                self.tableView.reloadData()
            }
            .store(in: &self.searchBarView.cancellables)
    }
    
    /// 取得使用者資訊、好友邀請、好友列表
    private func fetchInfo() {
        
        // 是否顯示無好友圖
        self.isNoFriend = true
        if self.isNoFriend {
            self.noFriendView.isHidden = false
            self.searchBarView.isHidden = true
            self.tableView.isHidden = true
        } else {
            self.noFriendView.isHidden = true
            self.searchBarView.isHidden = false
            self.friendFlagView.flagLabel.isHidden = false
            self.chatFlagView.flagLabel.isHidden = false
            self.tableView.isHidden = false
        }
        
        // 1️⃣ 使用者資訊
        self.input.send(.fetchMainInfo)
        
        // 2️⃣ 好友邀請
        let customRequestType: FriendAPIDataType = .noInvitingList
        self.input.send(.fetchFriends(type: customRequestType))
        
        // 3️⃣ 好友列表
        self.input.send(.fetchFriends(type: .friend1))
        self.input.send(.fetchFriends(type: .friend2))
    }
    
    /// 更新使用者資訊
    private func updateMainInfo(response: FriendMainInfo) {
        self.mainInfoView.nameLabel.text = response.name
        self.mainInfoView.idLabel.text = self.isNoFriend ? "設定 KOKO ID" : "KOKO ID：\(response.kokoid)"
    }
    
    /// 生成好友邀請
    private func createfriendInvitationCard(invitingFriends: [Friend]) {
        for friend in invitingFriends {
            let invitedFriendView = InvitedFriendView()
            invitedFriendView.nameLabel.text = friend.name
            invitedFriendView.translatesAutoresizingMaskIntoConstraints = false
            self.invitedFriendStackView.addArrangedSubview(invitedFriendView)
            NSLayoutConstraint.activate([
                invitedFriendView.heightAnchor.constraint(equalToConstant: 70)
            ])
        }
        self.invitedFriendHeightConstraint?.isActive = false
    }
    
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true)
        }
    }
}

extension FriendViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.filteredFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(FriendTableViewCell.self)",
                                                       for: indexPath) as? FriendTableViewCell
        else { return UITableViewCell() }
        cell.selectionStyle = .none
        let friend = self.viewModel.filteredFriends[indexPath.row]
        cell.configCell(friend: friend)
        return cell
    }
}
