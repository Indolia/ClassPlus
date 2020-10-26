//
//  HomeViewBuilder.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

protocol HomeViewDependenciesProtocol {
    var storyboard: AppConstants.Storyboard { get }
    var nav: NavigationViewControllerProtocol {get}
    var userType: UserType { get }
    
}

struct HomeViewDependencies: HomeViewDependenciesProtocol{
    let userType: UserType
    let nav: NavigationViewControllerProtocol
    let storyboard: AppConstants.Storyboard

}

protocol HomeViewBuilderProtocol: class {
    var dependencies: HomeViewDependenciesProtocol {get}
   func build(with delegate: HomeViewActionDelegate) -> HomeViewProtocol
}

class HomeViewBuilder: HomeViewBuilderProtocol {
    
    let dependencies: HomeViewDependenciesProtocol

    init(dependencies: HomeViewDependenciesProtocol) {
        self.dependencies = dependencies
    }
    
    func build(with delegate: HomeViewActionDelegate) -> HomeViewProtocol {
        return HomeViewController.get(from: dependencies.storyboard, with: dependencies.nav, delegate: delegate, userType: dependencies.userType)
    }
}
