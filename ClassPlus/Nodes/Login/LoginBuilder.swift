//
//  LoginBuilder.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

protocol LoginBuilderProtocol: class {
    func build(dependencies: LoginViewDependenciesProtocol) -> RootRouterProtocol
}

class LoginBuilder: LoginBuilderProtocol {
    func build(dependencies: LoginViewDependenciesProtocol) -> RootRouterProtocol {
        let viewBuilder = LoginViewBuilder(dependencies: dependencies)
        let viewModel = LoginViewModel(viewBuilder: viewBuilder)
        let router = LoginRouter(with: viewModel)
        viewModel.router = router
        return router
    }

}
