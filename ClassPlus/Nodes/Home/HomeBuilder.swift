//
//  HomeBuilder.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

protocol HomeBuilderProtocol: class {
    func build(dependencies: HomeViewDependenciesProtocol) -> RootRouterProtocol
}

class HomeBuilder: HomeBuilderProtocol {
    func build(dependencies: HomeViewDependenciesProtocol) -> RootRouterProtocol {
        let viewBuilder = HomeViewBuilder(dependencies: dependencies)
        let viewModel = HomeViewModel(viewBuilder: viewBuilder)
        let router = HomeRouter(with: viewModel)
        viewModel.router = router
        return router
    }

}
