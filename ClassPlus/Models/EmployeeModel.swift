//
//  EmployeeModel.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation
protocol EmployeeModelProtocal: Decodable {
    var id: Int { get }
    var firstName: String {get}
    var lastName: String { get }
    var avatar: String { get }
    var email: String { get }
}

struct EmployeeModel: EmployeeModelProtocal {
    let id: Int
    let avatar: String
    let firstName: String
    let lastName: String
    let email: String
    
    var fullName: String {
       return firstName + " " + lastName
    }
    
    var searchable: String {
        return firstName + " " + lastName + " " + email
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EmployeeModelCodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        avatar = try container.decode(String.self, forKey: .avatar)
        email = try container.decode(String.self, forKey: .email)
    }
}

enum EmployeeModelCodingKeys: String, CodingKey {
    case id = "id"
    case lastName = "last_name"
    case firstName = "first_name"
    case avatar =  "avatar"
    case email = "email"
}

