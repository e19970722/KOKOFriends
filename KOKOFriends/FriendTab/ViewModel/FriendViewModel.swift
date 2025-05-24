//
//  FriendViewModel.swift
//  KOKOFriends
//
//  Created by Yen Lin on 2025/5/24.
//

import Foundation
import Combine

final class FriendViewModel {
    
    // MARK: - User Events Enum
    enum Input {
        /// 取得使⽤者資料
        case fetchMainInfo
        /// 取得好友資料
        case fetchFriends(type: FriendAPIDataType)
    }

    enum Output {
        case fetchMainInfoDidSucceed(response: FriendMainInfoResponse)
        case fetchMainInfoDidFail(error: Error)
        
        case fetchFriendsDidSucceed(type: FriendAPIDataType, response: FriendResponse)
        case fetchFriendsDidFail(type: FriendAPIDataType, error: Error)
    }
    
    // MARK: - Private Properties
    private let apiServiceType: FriendServiceType
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Properties
    /// 邀請好友
    @Published var invitingFriends: [Friend] = []
    /// 好友列表
    var friends: [Friend] = []
    /// 篩選後的好友列表
    @Published var filteredFriends: [Friend] = []
    
    // MARK: - Initializer
    init(apiServiceType: FriendServiceType = FriendService()) {
        self.apiServiceType = apiServiceType
    }
    
    // MARK: - Public Methods
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
      input.sink { [weak self] event in
          guard let self = self else { return }
          switch event {
          case .fetchMainInfo:
              self.handleFetchMainInfo()
              
          case .fetchFriends(let type):
              self.handleFetchItems(type: type)
          }
      }.store(in: &cancellables)
        
      return output.eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods
    private func handleFetchMainInfo() {
        apiServiceType.fetchFriendMainInfo()
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.output.send(.fetchMainInfoDidFail(error: error))
            }
        } receiveValue: { response in
            self.output.send(.fetchMainInfoDidSucceed(response: response))
        }.store(in: &cancellables)

    }
    
    private func handleFetchItems(type: FriendAPIDataType) {
        apiServiceType.fetchFriends(type: type)
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.output.send(.fetchFriendsDidFail(type: type, error: error))
            }
        } receiveValue: { response in
            self.output.send(.fetchFriendsDidSucceed(type: type, response: response))
        }.store(in: &cancellables)

    }
    
    /// 同時request的兩個資料，將兩個資料源整合為列表，若重覆fid資料則取updateDate較新的那⼀筆
    func combineFriends(returnedFriends: [Friend]) -> [Friend] {
        var combineFriends = self.filteredFriends
        for newFriend in returnedFriends {
            if let currentFriend = combineFriends.filter({ $0.fid == newFriend.fid }).first {
                let currentFriendUpdateDate = currentFriend.updateDate
                if newFriend.updateDate > currentFriendUpdateDate {
                    print("currentFriend: \(currentFriend) newFriend: \(newFriend)")
                    combineFriends.removeAll { $0.fid == newFriend.fid }
                    combineFriends.append(newFriend)
                }
            } else {
                combineFriends.append(newFriend)
            }
        }
        return combineFriends
    }
}
