//
//  CreateOrEditEmployeeInteractor.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

protocol CreateOrEditEmployeeInteractorProtocol: class {
    
    func createEmployees(for createRequest: CreateEmployeeRequest, completion: @escaping(Result<CreateEmployeeResponse, NSError>) -> Void)
    func editEmployee(for editRequest: EditEmployeeRequest, completion: @escaping(Result<EditEmployeeResponse, NSError>) -> Void)
}

class CreateOrEditEmployeeInteractor: RootInteractor, CreateOrEditEmployeeInteractorProtocol {
    func editEmployee(for editRequest: EditEmployeeRequest, completion: @escaping (Result<EditEmployeeResponse, NSError>) -> Void) {
        super.request(with:editRequest.param, for: editRequest.url, method: editRequest.method) { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let date):
                self.decoderEditReponse(jsonData: date) { (result) in
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createEmployees(for createRequest: CreateEmployeeRequest, completion: @escaping (Result<CreateEmployeeResponse, NSError>) -> Void) {
        super.request(with: createRequest.param, for: createRequest.url, method: createRequest.method) { [weak self](result) in
            
            guard let self = self else {
                return
            }
            switch result {
            case .success(let date):
                self.decoderCreateReponse(jsonData: date) { (result) in
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    private func decoderCreateReponse(jsonData: Data, completion: @escaping (Result<CreateEmployeeResponse, NSError>) -> Void) {
        let decoder = JSONDecoder()
        do {
            let employee = try decoder.decode(CreateEmployeeResponse.self, from: jsonData)
            completion(.success(employee))
        } catch (let someError){
            print(someError.localizedDescription)
            let error = NSError(domain: "JSON Decoding faied", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }
    
    private func decoderEditReponse(jsonData: Data, completion: @escaping (Result<EditEmployeeResponse, NSError>) -> Void) {
        let decoder = JSONDecoder()
        do {
            let employee = try decoder.decode(EditEmployeeResponse.self, from: jsonData)
            completion(.success(employee))
        } catch (let someError){
            print(someError.localizedDescription)
            let error = NSError(domain: "JSON Decoding faied", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }
}


