//
//  Indexer.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation
import UIKit

struct Indexer {
    enum RootViewType {
        case welcome
        case home
    }
    
    func setLandingIndex() {
        let landingView = getLandingViewType()
        switch landingView {
        case .welcome:
            setWelcomeAsLanding()
        case .home:
            setHomeAsLandig()
        }
    }
    
    func getLandingViewType()-> RootViewType {
        if IKeyChain.shared.isLogedIn {
            return .home
        }
        return .welcome
    }
    
    
    private func setWelcomeAsLanding() {
        let dependencies = WelcomeViewDependencies(nav: NavigationViewController.current, storyboard: AppConstants.Storyboard.main)
        let router  = WelcomeBuilder().build(dependencies: dependencies)
        router.setAsRootView(completion: nil)
    }
    
    private func setHomeAsLandig() {
        let dependencies = HomeViewDependencies(userType: .member, nav: NavigationViewController.current, storyboard: AppConstants.Storyboard.main)
        let router  = HomeBuilder().build(dependencies: dependencies)
        router.setAsRootView(completion: nil)
    }
    
}
