//
//  LoginRouter.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

protocol LoginRouterProtocol: class {
    
}

class LoginRouter: RootRouter, LoginRouterProtocol {
    private let viewModel:RootViewModelProtocol
    
    required init(with viewModel: RootViewModelProtocol) {
        self.viewModel = viewModel
        super.init(with: viewModel)
    }
}
