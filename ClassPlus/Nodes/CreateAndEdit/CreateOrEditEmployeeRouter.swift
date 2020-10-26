//
//  CreateOrEditEmployeeRouter.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation
protocol CreateOrEditEmployeeRouterProtocol: class {
    
}

class CreateOrEditEmployeeRouter: RootRouter, CreateOrEditEmployeeRouterProtocol {
    private let viewModel:RootViewModelProtocol
    
    required init(with viewModel: RootViewModelProtocol) {
        self.viewModel = viewModel
        super.init(with: viewModel)
    }
}
