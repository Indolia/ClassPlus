//
//  CreateOrEditEmployeeRequestAndResponse.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation


protocol DecodableResponse: Decodable {}

struct CreateEmployeeRequest {
    let url: URL
    let param: [ String : Any]?
    let method: HttpMethod
    init?(urlString: String, param: [ String : Any]?, method: HttpMethod) {
        let fullURLStr = urlString
        guard let url = URL(string: fullURLStr) else {
            print("Invalide url")
            return nil
        }
        self.url = url
        self.param = param
        self.method = method
    }
}


struct CreateEmployeeResponse: DecodableResponse{
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let message: String = "New employee have created successfully!."
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EditOrCreateEmployeeResponseCodingKeys.self)
        let idStr = try container.decode(String.self, forKey: .id)
        id = Int(idStr) ?? 0
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        email = try container.decode(String.self, forKey: .email)
    }

}

struct EditEmployeeRequest {
    let url: URL
    let param: [ String : Any]?
    let method: HttpMethod
    let employeeId: Int
    init?(urlString: String, param: [ String : Any]?, method: HttpMethod, employeeId: Int) {
        let fullURLStr = urlString + "\(employeeId)"
        guard let url = URL(string: fullURLStr) else {
            print("Invalide url")
            return nil
        }
        self.url = url
        self.param = param
        self.method = method
        self.employeeId = employeeId
    }
}


struct EditEmployeeResponse: Decodable{
    let firstName: String
    let lastName: String
    let email: String
    let message: String = "Employee details have updated successfully!."
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EditOrCreateEmployeeResponseCodingKeys.self)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        email = try container.decode(String.self, forKey: .email)
    }
}


enum EditOrCreateEmployeeResponseCodingKeys: String, CodingKey {
        case id = "id"
        case lastName = "last_name"
        case firstName = "first_name"
        case email = "email"
}

