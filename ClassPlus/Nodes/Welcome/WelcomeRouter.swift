//
//  WelcomeRouter.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation
protocol WelcomeRouterProtocol: class {
    
}

class WelcomeRouter: RootRouter, WelcomeRouterProtocol {
   // private let viewModel:RootViewModelProtocol
    
    required init(with viewModel: RootViewModelProtocol) {
       // self.viewModel = viewModel
        super.init(with: viewModel)
    }
}
