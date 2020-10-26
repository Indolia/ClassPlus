//
//  CreateOrEditViewBuilder.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

enum ModeType {
    case create
    case edit
}
protocol CreateOrEditEmployeeViewDependenciesProtocol {
    var storyboard: AppConstants.Storyboard { get }
    var nav: NavigationViewControllerProtocol {get}
    var employee: EmployeeModel? {get}
    var mode: ModeType {get}
    
}

struct CreateOrEditEmployeeViewDependencies: CreateOrEditEmployeeViewDependenciesProtocol{
    let employee: EmployeeModel?
    let mode: ModeType
    let nav: NavigationViewControllerProtocol
    let storyboard: AppConstants.Storyboard

}

protocol CreateOrEditEmployeeViewBuilderProtocol: class {
   var dependencies: CreateOrEditEmployeeViewDependenciesProtocol {get}
   func build(with delegate: CreateOrEditEmployeeViewActionDelegate) -> CreateOrEditEmployeeViewProtocol
}

class CreateOrEditEmployeeViewBuilder: CreateOrEditEmployeeViewBuilderProtocol {
    
    let dependencies: CreateOrEditEmployeeViewDependenciesProtocol

    init(dependencies: CreateOrEditEmployeeViewDependenciesProtocol) {
        self.dependencies = dependencies
    }
    
    func build(with delegate: CreateOrEditEmployeeViewActionDelegate) -> CreateOrEditEmployeeViewProtocol {
        return CreateOrEditEmployeeViewController.get(from: AppConstants.Storyboard.main, with: dependencies.nav, delegate: delegate, mode: dependencies.mode, employee: dependencies.employee)
    }
    
    
}
