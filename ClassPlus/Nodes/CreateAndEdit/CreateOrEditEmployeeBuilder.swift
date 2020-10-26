//
//  CreateOrEditEmployeeBuilder.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

protocol CreateOrEditEmployeeBuilderProtocol: class {
    func build(dependencies: CreateOrEditEmployeeViewDependenciesProtocol) -> RootRouterProtocol
}

class CreateOrEditEmployeeBuilder: CreateOrEditEmployeeBuilderProtocol {
    func build(dependencies: CreateOrEditEmployeeViewDependenciesProtocol) -> RootRouterProtocol {
        let viewBuilder = CreateOrEditEmployeeViewBuilder(dependencies: dependencies)
        let ViewModel = CreateOrEditEmployeeViewModel(viewBuilder: viewBuilder)
        let router = CreateOrEditEmployeeRouter(with: ViewModel)
        ViewModel.router = router
        return router
    }

}
