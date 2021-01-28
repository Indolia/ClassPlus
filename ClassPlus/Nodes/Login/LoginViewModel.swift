//
//  LoginViewModel.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

enum LoginError: Error {
    case userNameShouldNotBeEmpty
    case userNameLenghtAtleastThreeCharacters
    case passwordShouldNotBeEmpty
    case passwordLenghtAtleastThreeCharacters
}

protocol LoginViewModelProtocol: class {
    var viewBuilder: LoginViewBuilderProtocol { get }
    var router: LoginRouterProtocol! { get }
}

class LoginViewModel: LoginViewModelProtocol {
    let viewBuilder: LoginViewBuilderProtocol
    weak var router: LoginRouterProtocol!
    private weak var view: LoginViewProtocol?
    private var homeRouter: RootRouterProtocol?
    private var userInfo: UserInfoModel? {
        willSet{
            newValue?.signUp(completion: { (status) in
                print(status)
            })
        }
    }
    
    init(viewBuilder: LoginViewBuilderProtocol) {
        self.viewBuilder = viewBuilder
    }
}


extension LoginViewModel: RootViewModelProtocol {
    func didPush(completion: (() -> Void)?) {
        self.view = viewBuilder.build(with: self)
        self.view?.pushInNavStack()
    }
}

extension LoginViewModel: LoginViewActionDelegate {
    func successfullLogedIn() {
        let dependencies = HomeViewDependencies(userType: .member, nav: viewBuilder.dependencies.nav, storyboard: AppConstants.Storyboard.main)
        homeRouter  = HomeBuilder().build(dependencies: dependencies)
        homeRouter?.push(completion: nil)
    }
    
    func validateDetails(with userName: String?, password: String?, completion: (Result<Bool, LoginError>) -> Void) {
        do {
            try validate(userName: userName, and: password) { (valid, userInfo) in
                self.userInfo = userInfo
                completion(.success(true))
            }
        } catch (let error) {
            completion(.failure(error as! LoginError))
        }
    }
    
}

extension LoginViewModel {
    func validate(userName: String?, and password: String?, completion:(Bool, UserInfoModel )->Void) throws {
        guard let someUserName = userName else {
            throw LoginError.userNameShouldNotBeEmpty
        }
        if someUserName.count < 3 {
            throw LoginError.userNameLenghtAtleastThreeCharacters
        }
        
        guard let somePassword = password else{
            throw LoginError.passwordShouldNotBeEmpty
        }
        if somePassword.count < 3 {
            throw LoginError.passwordLenghtAtleastThreeCharacters
        }
        let model = UserInfoModel(userName: someUserName, password: someUserName)
        completion(true , model)
    }
 
}

extension LoginError: LocalizedError {
    var localizedDescription: String {
        get {
            switch self {
            case .userNameShouldNotBeEmpty:
                return "Please enter a valid username."
            case.userNameLenghtAtleastThreeCharacters:
                return "Username should have atleast 3 characters."
            case .passwordShouldNotBeEmpty:
                return "Please enter a valid password."
            case .passwordLenghtAtleastThreeCharacters:
                return "Password should have atleast 3 characters"
            }
        }
    }
}

