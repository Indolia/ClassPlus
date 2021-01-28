//
//  RootRouter.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation
import UIKit

protocol RootRouterProtocol {
    init(with viewModel: RootViewModelProtocol)
    func push(completion: (() -> Void)?)
    func pop(completion: (() -> Void)?)
    func present(completion: (() -> Void)?)
    func setAsRootView(completion: (() -> Void)?)
}

extension RootRouterProtocol {
    func push(completion: (() -> Void)?) {}
    func pop(completion: (() -> Void)?) {}
    func present(completion: (() -> Void)?) {}
    func setAsRootView(completion: (() -> Void)?) {}
}

class RootRouter: RootRouterProtocol {
    private let  viewModel:RootViewModelProtocol
    
    required init(with viewModel: RootViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    func push(completion: (() -> Void)?) {
        viewModel.didPush(completion: completion)
    }
    
    func pop(completion: (() -> Void)?) {
        viewModel.didPop(completion: completion)
    }
    
    func present(completion: (() -> Void)?) {
        viewModel.didPresent(completion: completion)
    }
    
    func setAsRootView(completion: (() -> Void)?) {
        viewModel.didSetAsRoot(completion: completion)
    }
}
