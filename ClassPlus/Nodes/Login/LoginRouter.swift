//
//  LoginRouter.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

protocol LoginRouterProtocol: class { }

class LoginRouter: RootRouter, LoginRouterProtocol {
   
    required init(with viewModel: RootViewModelProtocol) {
        super.init(with: viewModel)
    }
}
