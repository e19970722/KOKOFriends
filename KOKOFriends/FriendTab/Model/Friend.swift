//
//  Friend.swift
//  KOKOFriends
//
//  Created by Yen Lin on 2025/5/24.
//

import Foundation
import Combine

public enum FriendAPIDataType: String {
    /// 好友列表1
    case friend1                           = "friend1.json"
    /// 好友列表2
    case friend2                           = "friend2.json"
    /// 好友列表含邀請列表
    case friendWithInvitingList            = "friend3.json"
    /// 無資料邀請/好友列表
    case noInvitingList                    = "friend4.json"
    
    var typeName: String {
        switch self {
        case .friend1:                     return "好友列表1"
        case .friend2:                     return "好友列表2"
        case .friendWithInvitingList:      return "好友列表含邀請列表"
        case .noInvitingList:              return "無資料邀請/好友列表"
        }
    }
}

public enum InvitingStatus: Int, Codable {
    /// 0:邀請送出
    case sent           = 0
    /// 1:已完成
    case done           = 1
    /// 2:邀請中
    case inviting       = 2
}

struct FriendMainInfoResponse: Codable {
    let response: [FriendMainInfo]
}

struct FriendMainInfo: Codable {
    let name: String
    let kokoid: String

    enum CodingKeys: String, CodingKey {
        case name
        case kokoid
    }
}

struct FriendResponse: Codable {
    let response: [Friend]
}

struct Friend: Codable {
    /// 姓名
    let name: String
    /// 0:邀請送出, 1:已完成 2:邀請中
    let status: InvitingStatus
    /// 是否出現星星
    let isTop: Bool
    /// 好友id
    let fid: String
    /// 資料更新時間
    let updateDate: Int
    
    enum CodingKeys: String, CodingKey {
        case name, status, isTop, fid, updateDate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        status = try container.decode(InvitingStatus.self, forKey: .status)
        
        let topValue = try container.decode(String.self, forKey: .isTop)
        isTop = (topValue == "1")
        
        fid = try container.decode(String.self, forKey: .fid)
        
        let updateDateValue = try container.decode(String.self, forKey: .updateDate).replacingOccurrences(of: "/", with: "")
        updateDate = Int(updateDateValue) ?? 0
    }
}

protocol FriendServiceType {
    func fetchFriendMainInfo() -> AnyPublisher<FriendMainInfoResponse, Error>
    func fetchFriends(type: FriendAPIDataType) -> AnyPublisher<FriendResponse, Error>
}

class FriendService: FriendServiceType {
    
    let urlString = "https://dimanyen.github.io/"
    
    func fetchFriendMainInfo() -> AnyPublisher<FriendMainInfoResponse, Error> {
        guard let url = URL(string: "\(self.urlString)man.json")
        else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200
                else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
          .catch { error in
            return Fail(error: error).eraseToAnyPublisher()
          }
          .decode(type: FriendMainInfoResponse.self, decoder: JSONDecoder())
          .eraseToAnyPublisher()
    }
    
    func fetchFriends(type: FriendAPIDataType) -> AnyPublisher<FriendResponse, Error> {
        guard let url = URL(string: "\(self.urlString)\(type.rawValue)")
        else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200
                else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
          .catch { error in
            return Fail(error: error).eraseToAnyPublisher()
          }
          .decode(type: FriendResponse.self, decoder: JSONDecoder())
          .eraseToAnyPublisher()
    }
}
