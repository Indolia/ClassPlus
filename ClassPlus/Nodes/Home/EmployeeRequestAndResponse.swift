//
//  EmployeeRequestAndResponse.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

struct FetchEmployeesRequest {
    let url: URL
    let paging: Paging
    let param: [ String : Any]?
    let method: HttpMethod
    init?(urlString: String, paging: Paging, param: [ String : Any]?, method: HttpMethod) {
        let fullURLStr = urlString + "?page=\(paging.currentPage)" 
        guard let url = URL(string: fullURLStr) else {
            print("Invalide url")
            return nil
        }
        self.url = url
        self.paging = paging
        self.param = param
        self.method = method
    }
}

struct Paging: Decodable {
    let totalItems: Int?
    let currentPage: Int
    let totalPages: Int
    let perPageItems: Int
}

struct FetchEmployeesResponse: Decodable {
    let employees: [EmployeeModel]
    let paging: Paging
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EmployeesResponseCodingKeys.self)
        let page = try container.decode(Int.self, forKey: .page)
        let perPage = try container.decode(Int.self, forKey: .perPage)
        let total = try container.decode(Int.self, forKey: .total)
        let totalPages = try container.decode(Int.self, forKey: .totalPages)
        employees = try container.decode([EmployeeModel].self, forKey: .data)
        paging = Paging(totalItems: total, currentPage: page, totalPages: totalPages, perPageItems: perPage)
    }
}


enum EmployeesResponseCodingKeys: String, CodingKey {
    case page = "page"
    case perPage = "per_page"
    case total = "total"
    case totalPages =  "total_pages"
    case data = "data"
}



struct DeleteEmployeeReqest {
    let url: URL
    let param: [ String : Any]?
    let method: HttpMethod
    let employee: EmployeeModel
    init?(urlString: String, param: [ String : Any]?, method: HttpMethod, employee: EmployeeModel) {
        let fullURLStr = urlString + "\(employee.id)"
        guard let url = URL(string: fullURLStr) else {
            print("Invalide url")
            return nil
        }
        self.url = url
        self.param = param
        self.method = method
        self.employee = employee
    }
}
