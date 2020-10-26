//
//  LoginViewBuilder.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation
protocol LoginViewDependenciesProtocol {
    var storyboard: AppConstants.Storyboard { get }
    var nav: NavigationViewControllerProtocol {get}
    
}

struct LoginViewDependencies: LoginViewDependenciesProtocol{
    let nav: NavigationViewControllerProtocol
    let storyboard: AppConstants.Storyboard

}

protocol LoginViewBuilderProtocol: class {
   var dependencies: LoginViewDependenciesProtocol {get}
   func build(with delegate: LoginViewActionDelegate) -> LoginViewProtocol
}

class LoginViewBuilder: LoginViewBuilderProtocol {
    let dependencies: LoginViewDependenciesProtocol
    
    init(dependencies: LoginViewDependenciesProtocol) {
        self.dependencies = dependencies
    }
    
    func build(with delegate: LoginViewActionDelegate) -> LoginViewProtocol {
        return LoginViewController.get(from: dependencies.storyboard, with: dependencies.nav, delegate: delegate)
    }
}
