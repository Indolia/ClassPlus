//
//  WelcomeViewBuilder.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

protocol WelcomeViewDependenciesProtocol {
    var storyboard: AppConstants.Storyboard { get }
    var nav: NavigationViewControllerProtocol {get}
    
}

struct WelcomeViewDependencies: WelcomeViewDependenciesProtocol{
    let nav: NavigationViewControllerProtocol
    let storyboard: AppConstants.Storyboard

}

protocol WelcomeViewBuilderProtocol: class {
   var dependencies: WelcomeViewDependenciesProtocol {get}
   func build(with delegate: WelcomeViewActionDelegate) -> WelcomeViewProtocol
}

class WelcomeViewBuilder: WelcomeViewBuilderProtocol {
    
    let dependencies: WelcomeViewDependenciesProtocol

    init(dependencies: WelcomeViewDependenciesProtocol) {
        self.dependencies = dependencies
    }
    
    func build(with delegate: WelcomeViewActionDelegate) -> WelcomeViewProtocol {
        return WelcomeViewController.get(from: dependencies.storyboard, with: dependencies.nav, delegate: delegate)
    }
    
    
}
