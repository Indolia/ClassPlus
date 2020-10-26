//
//  HomeViewModel.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

protocol HomeViewModelProtocol: class {
    var viewBuilder: HomeViewBuilderProtocol { get }
    var router: HomeRouterProtocol! { get }
}

class HomeViewModel: HomeViewModelProtocol {
    let viewBuilder: HomeViewBuilderProtocol
    var router: HomeRouterProtocol!
    private var view: HomeViewProtocol?
    lazy var interactor: HomeInteractor = HomeInteractor()
    private var currentPaging: Paging?
    private var employees = [EmployeeModel]()
    private var empResponse: FetchEmployeesResponse? {
        willSet {
            if let someValue = newValue {
                currentPaging = someValue.paging
                if someValue.paging.currentPage == 1 {
                    employees = someValue.employees
                }else {
                    employees.append(contentsOf: someValue.employees)
                }
                self.view?.reloadData(for: self.employees)
            }
        }
    }
    init(viewBuilder: HomeViewBuilderProtocol) {
        self.viewBuilder = viewBuilder
    }
}


extension HomeViewModel: RootViewModelProtocol {
    func didPush(completion: (() -> Void)?) {
        self.view = viewBuilder.build(with: self)
        self.view?.pushInNavStack()
        let paging = Paging(totalItems: nil, currentPage: 1, totalPages: 0, perPageItems: 0)
        self.getEmployees(paging: paging)
    }
    
    func didSetAsRoot(completion: (() -> Void)?) {
        self.view = viewBuilder.build(with: self)
        view?.setAsRootView()
        let paging = Paging(totalItems: nil, currentPage: 1, totalPages: 0, perPageItems: 0)
        self.getEmployees(paging: paging)
    }
}

extension HomeViewModel: HomeViewActionDelegate {
    func fetchNextPage() {
        if let paging = self.currentPaging, paging.currentPage < paging.totalPages {
            let nextPaging = Paging(totalItems: paging.totalItems, currentPage: paging.currentPage + 1, totalPages: paging.totalPages, perPageItems: paging.perPageItems)
            getEmployees(paging: nextPaging)
        }else {
            print("Already all pages fetched")
            self.view?.stopFooterAnimation()
        }
    }
    
    func logoutUser() {
        LogoutManager.logout()
        setWelcomeAsLanding()
    }
    
    private func setWelcomeAsLanding() {
        let dependencies = WelcomeViewDependencies(nav: viewBuilder.dependencies.nav, storyboard: AppConstants.Storyboard.main)
        let router  = WelcomeBuilder().build(dependencies: dependencies)
        router.setAsRootView(completion: nil)
    }
    
    func createNewEmployee() {
        let dependencies = CreateOrEditEmployeeViewDependencies(employee: nil, mode: .create, nav: viewBuilder.dependencies.nav, storyboard: AppConstants.Storyboard.main)
        let router = CreateOrEditEmployeeBuilder().build(dependencies: dependencies)
        router.push(completion: nil)
    }
    
    func delete(employee: EmployeeModel) {
        let deleteRequest = DeleteEmployeeReqest(urlString: AppConstants.ServerURL.baseURL, param: nil, method: .DELETE, employee: employee)
        if deleteRequest != nil {
            interactor.deleteEmployee(for: deleteRequest!) { [weak self](result) in
                switch result {
                case .failure(let error):
                    self?.view?.alert(for: error.localizedDescription)
                case .success(let message):
                    self?.view?.alert(for: message)
                }
            }
        }
    }
    
    func detailsUpdate(for employee: EmployeeModel) {
        let dependencies = CreateOrEditEmployeeViewDependencies(employee: employee, mode: .edit, nav: viewBuilder.dependencies.nav, storyboard: AppConstants.Storyboard.main)
        let router = CreateOrEditEmployeeBuilder().build(dependencies: dependencies)
        router.push(completion: nil)
    }
    
    func filterEmployees(for searchText: String) {
        if searchText.isEmpty {
            self.view?.reloadData(for: self.employees)
        }else {
            
            let filterEmployees = self.employees.filter { (employee) -> Bool in
                return employee.searchable.lowercased().contains(searchText.lowercased())
            }
            self.view?.reloadData(for: filterEmployees)
        }
    }
    
}


extension HomeViewModel {
    
    private func getEmployees(paging: Paging) {
        currentPaging = paging
        let emp = FetchEmployeesRequest(urlString: AppConstants.ServerURL.baseURL, paging: paging, param: nil, method: .GET)
        if let request = emp {
            getEmployees(request: request)
        }
        
    }
    private func getEmployees(request: FetchEmployeesRequest) {
        interactor.fetchEmployees(for: request) { [weak self](result) in
            switch result {
            case .failure(let error):
                self?.view?.alert(for: error.description)
            case .success(let empResponse):
                self?.empResponse = empResponse
            }
        }
    }
}
