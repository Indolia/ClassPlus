//
//  WelcomeViewModel.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

protocol WelcomeViewModelProtocol: class {
    var viewBuilder: WelcomeViewBuilderProtocol { get }
    var router: WelcomeRouterProtocol! { get }
}

class WelcomeViewModel: WelcomeViewModelProtocol {
    let viewBuilder: WelcomeViewBuilderProtocol
    var router: WelcomeRouterProtocol!
    private var view: WelcomeViewProtocol?
    
    init(viewBuilder: WelcomeViewBuilderProtocol) {
        self.viewBuilder = viewBuilder
    }
}


extension WelcomeViewModel: RootViewModelProtocol {
    func didSetAsRoot(completion: (() -> Void)?) {
        self.view = viewBuilder.build(with: self)
        view?.setAsRootView()
    }
}

extension WelcomeViewModel: WelcomeViewActionDelegate {
    func proceedAsA(userType: UserType) {
        switch userType {
        case .guest:
            home()
        case .member:
            login()
        }
    }
    
    private func login() {
        let dependencies = LoginViewDependencies(nav: viewBuilder.dependencies.nav, storyboard: AppConstants.Storyboard.main)
        let router  = LoginBuilder().build(dependencies: dependencies)
        router.push(completion: nil)
    }
    
    private func home() {
        let dependencies = HomeViewDependencies(userType: .guest, nav: viewBuilder.dependencies.nav, storyboard: AppConstants.Storyboard.main)
        let router  = HomeBuilder().build(dependencies: dependencies)
        router.push(completion: nil)
    }
}
