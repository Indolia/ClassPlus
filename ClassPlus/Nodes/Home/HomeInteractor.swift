//
//  HomeInteractor.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

protocol HomeInteractorProtocol: class {
    func fetchEmployees(for empRequest: FetchEmployeesRequest, completion: @escaping(Result<FetchEmployeesResponse, NSError>) -> Void)
    func deleteEmployee(for deleteRequest: DeleteEmployeeReqest, completion: @escaping(Result<String, NSError>) -> Void)
}

class HomeInteractor: RootInteractor, HomeInteractorProtocol {

    func fetchEmployees(for empRequest: FetchEmployeesRequest, completion: @escaping (Result<FetchEmployeesResponse, NSError>) -> Void) {
        super.request(with: empRequest.param, for: empRequest.url, method: empRequest.method) { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                self.decoderReponse(jsonData: data) { (decodedRuslt) in
                    switch decodedRuslt {
                    case .success(let empResponse):
                    completion(.success(empResponse))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
           
        }
    }
    
    private func decoderReponse(jsonData: Data, completion: @escaping (Result<FetchEmployeesResponse, NSError>) -> Void) {
        let decoder = JSONDecoder()
        do {
            let employees = try decoder.decode(FetchEmployeesResponse.self, from: jsonData)
            completion(.success(employees))
        } catch (let someError){
            print(someError.localizedDescription)
            let error = NSError(domain: "JSON Decoding faied", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }
}


extension HomeInteractor {
    func deleteEmployee(for deleteRequest: DeleteEmployeeReqest, completion: @escaping (Result<String, NSError>) -> Void) {
        super.request(with: deleteRequest.param, for: deleteRequest.url, method: deleteRequest.method) { (result) in
            switch result {
            case .success(let data):
                if data.isEmpty {
                    completion(.success("Response data is empty for delete api check it!"))
                }else {
                    completion(.success("User deleted successfully!"))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


