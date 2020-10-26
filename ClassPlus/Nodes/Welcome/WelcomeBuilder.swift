//
//  WelcomeBuilder.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

protocol WelcomeBuilderProtocol: class {
    func build(dependencies: WelcomeViewDependenciesProtocol) -> RootRouterProtocol
}

class WelcomeBuilder: WelcomeBuilderProtocol {
    func build(dependencies: WelcomeViewDependenciesProtocol) -> RootRouterProtocol {
        let viewBuilder = WelcomeViewBuilder(dependencies: dependencies)
        let viewModel = WelcomeViewModel(viewBuilder: viewBuilder)
        let router = WelcomeRouter(with: viewModel)
        viewModel.router = router
        return router
    }

}
