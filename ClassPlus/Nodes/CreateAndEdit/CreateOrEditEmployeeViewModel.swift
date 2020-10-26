//
//  CreateOrEditEmployeeViewModel.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

enum CreateOrEditError: Error {
    case firstNameShouldNotBeEmpty
    case firstNameLenghtAtleastThreeCharacters
    case lastNameShouldNotBeEmpty
    case lastNameLenghtAtleastThreeCharacters
    case emailShouldNotBeEmpty
    case emailShouldBeValid
}

extension CreateOrEditError: LocalizedError {
    var localizedDescription: String {
        get {
            switch self {
            case .firstNameShouldNotBeEmpty:
                return "Please enter a valid first name."
            case.firstNameLenghtAtleastThreeCharacters:
                return "First name should have atleast 3 characters."
            case .lastNameShouldNotBeEmpty:
                return "Please enter a valid last name."
            case .lastNameLenghtAtleastThreeCharacters:
                return "last name should have atleast 3 characters"
            case .emailShouldNotBeEmpty, .emailShouldBeValid:
                return "Enter a valid email address"
            }
        }
    }
}

protocol CreateOrEditEmployeeViewModelProtocol: class {
    var viewBuilder: CreateOrEditEmployeeViewBuilderProtocol { get }
    var router: CreateOrEditEmployeeRouterProtocol! { get }
}

class CreateOrEditEmployeeViewModel: CreateOrEditEmployeeViewModelProtocol {
    let viewBuilder: CreateOrEditEmployeeViewBuilderProtocol
    var router: CreateOrEditEmployeeRouterProtocol!
    private var view: CreateOrEditEmployeeViewProtocol?
    private lazy var interactor = CreateOrEditEmployeeInteractor()
    
    init(viewBuilder: CreateOrEditEmployeeViewBuilderProtocol) {
        self.viewBuilder = viewBuilder
    }
}


extension CreateOrEditEmployeeViewModel: RootViewModelProtocol {
    func didPush(completion: (() -> Void)?) {
        self.view = viewBuilder.build(with: self)
        view?.pushInNavStack()
    }
}

extension CreateOrEditEmployeeViewModel: CreateOrEditEmployeeViewActionDelegate {
    func createEmployee(with firstName: String?, lastName: String?, email: String?) {
        do {
            try validate(firstName: firstName, lastName: lastName, email: email) { (tuple) in
                let param = ["first_name": tuple.firstName, "last_name": tuple.lastName, "email": tuple.email]
                let createEmployeeRequest = CreateEmployeeRequest(urlString: AppConstants.ServerURL.baseURL, param: param, method: .POST)
                if let someRequest = createEmployeeRequest {
                    interactor.createEmployees(for: someRequest) { [weak self](result) in
                        guard let self = self else {
                            return
                        }
                        switch result {
                        case .success(let response):
                            self.view?.alertWithCompletion(for: response.message, completion: {
                                self.view?.popFromNavStack()
                            })
                        case .failure(let error):
                            self.view?.alert(for: error.localizedDescription)
                        }
                    }
                }
            }
        }  catch (let error) {
            self.view?.alert(for:(error as! CreateOrEditError).localizedDescription)
        }
        
    }
    
    func editEmployee(with firstName: String?, lastName: String?, email: String?, id: Int) {
        do {
            try validate(firstName: firstName, lastName: lastName, email: email) { (tuple) in
                let param = ["first_name": tuple.firstName, "last_name": tuple.lastName, "email": tuple.email]
                let editEmployeeRequest = EditEmployeeRequest(urlString: AppConstants.ServerURL.baseURL, param: param, method: .PUT, employeeId: id)
                if let someRequest = editEmployeeRequest {
                    interactor.editEmployee(for: someRequest) {[weak self] (result) in
                        guard let self = self else {
                            return
                        }
                        switch result {
                        case .success(let response):
                            self.view?.alertWithCompletion(for: response.message, completion: {
                                self.view?.popFromNavStack()
                            })
                        case .failure(let error):
                            self.view?.alert(for: error.localizedDescription)
                        }
                    }
                }
            }
        }  catch (let error) {
            self.view?.alert(for: (error as! CreateOrEditError).localizedDescription)
        }
    }
    
    func viewDidLoad() {
        view?.populateDataOnView()
    }
    
}


extension CreateOrEditEmployeeViewModel {
    func validate(firstName: String?, lastName: String?, email: String?, completion:((firstName: String, lastName: String ,email: String))->Void) throws {
        guard let firstName = firstName else {
            throw CreateOrEditError.firstNameShouldNotBeEmpty
        }
        if firstName.count < 3 {
            throw CreateOrEditError.firstNameLenghtAtleastThreeCharacters
        }
        
        guard let lastName = lastName else {
            throw CreateOrEditError.lastNameShouldNotBeEmpty
        }
        
        if lastName.count < 3 {
            throw CreateOrEditError.lastNameLenghtAtleastThreeCharacters
        }
        
        guard let email = email else{
            throw CreateOrEditError.emailShouldNotBeEmpty
        }
        if !isValidEmail(email: email){
            throw CreateOrEditError.emailShouldBeValid
        }
        
        completion((firstName, lastName, email))
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
