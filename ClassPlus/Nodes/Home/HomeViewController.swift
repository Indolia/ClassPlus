//
//  HomeViewController.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import UIKit

protocol HomeViewActionDelegate:AnyObject {
    func delete(employee: EmployeeModel)
    func detailsUpdate(for employee: EmployeeModel)
    func createNewEmployee()
    func filterEmployees(for searchText: String)
    func logoutUser()
    func fetchNextPage()
}

protocol HomeViewProtocol:AnyObject {
    static func get(from: AppConstants.Storyboard, with nav: NavigationViewControllerProtocol, delegate: HomeViewActionDelegate, userType: UserType) -> HomeViewProtocol
    func pushInNavStack()
    func reloadData(for employees: [EmployeeModel])
    func alert(for message: String)
    func setAsRootView()
    func stopFooterAnimation()
}


class HomeViewController: UIViewController {
    private var nav: NavigationViewControllerProtocol?
    weak var delegate: HomeViewActionDelegate?
    @IBOutlet var createNewEmployeeButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var employeesTableView: UITableView!
    private var viewSetupDone: Bool = false
    private var employees = [EmployeeModel]()
    private var userType: UserType!
    var isPaginationInProgress: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
        nav?.setNavigationBar(hidden: false, animation: true)
        tableViewSetup()
        viewSetupDone = true
        // Do any additional setup after loading the view.
    }
    
    
    private func uiSet() {
        title = "Home"
        createNewEmployeeButton.applyGradient(colours: UIColor.gradientColors, locations: [0.5 , 1.0])
        createNewEmployeeButton.cornerRadius(with: 8)
        if userType == UserType.member {
            setRightBarButtons(with: [])
        }
        
    }
    @IBAction func createNewEmpolyee(_ sender: Any) {
        delegate?.createNewEmployee()
    }
    
    private func tableViewSetup() {
        employeesTableView.registerNib(String(describing: EmployeeTableViewCell.self))
        employeesTableView.estimatedRowHeight = 100
        employeesTableView.rowHeight = UITableView.automaticDimension
        employeesTableView.tableFooterView = UIView(frame: .zero)
    }
    
    
    func setRightBarButtons(with image: [UIImage]) {
        let image = UIImage(named: "logout.png")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(rightBarButtonTapped(button: )))
        //  let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(rightBarButtonTapped(button: )))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc private func rightBarButtonTapped(button: UIBarButtonItem) {
        delegate?.logoutUser()
    }
}

extension HomeViewController: HomeViewProtocol {
    func stopFooterAnimation() {
        employeesTableView.tableFooterView = nil
        isPaginationInProgress = false
    }
    
    func reloadData(for employees: [EmployeeModel]) {
        self.employees = employees
        if viewSetupDone {
            DispatchQueue.main.async {
                self.employeesTableView.reloadData()
            }
        }else {
            print("View setup no done")
        }
        
    }
    
    func alert(for message: String) {
        DispatchQueue.main.async {
            self.stopFooterAnimation()
            self.alert(title: "Info", message: message)
        }
    }
    
    
    func pushInNavStack(){
        nav?.push(viewController: self, animated: true)
    }
    
    func setAsRootView(){
        nav?.set(rootViewController: self)
    }
    
    
    static func get(from storyboard: AppConstants.Storyboard, with nav: NavigationViewControllerProtocol, delegate: HomeViewActionDelegate, userType: UserType) -> HomeViewProtocol {
        
        let vc = HomeViewController.get(with: "HomeViewController", storyboard: storyboard.rawValue) as? HomeViewController
        vc?.nav = nav
        vc?.delegate = delegate
        vc?.userType = userType
        guard let unwrappedVC = vc else {
            fatalError("HomeViewController not found in \(storyboard)")
        }
        
        return unwrappedVC
    }
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EmployeeTableViewCell.self), for: indexPath) as! EmployeeTableViewCell
        cell.setData(for: employees[indexPath.row], at: indexPath.row, delegate: self)
        return cell
    }
   
}

extension HomeViewController: EmployeeTableViewCellActionDelegate {
    func openMoreOption(at index: Int) {
        self.actionSheet(with: nil, message: nil) { [weak self](action) in
            guard let weakSelf = self else {
                return
            }
            switch action {
            case 0:
                weakSelf.delegate?.detailsUpdate(for: weakSelf.employees[index])
            case 1:
                weakSelf.delegate?.delete(employee: weakSelf.employees[index])
            default:
                break
            }
        }
    }
}


extension HomeViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        delegate?.filterEmployees(for: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        delegate?.filterEmployees(for: "")
    }
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let employeesCount = employees.count
        
        guard employeesCount != 0, employeesCount - 1 == row else {
            return
        }
        
        fetchNextPage()
    }
    
    private  func fetchNextPage() {
        guard !isPaginationInProgress else {
            stopFooterAnimation()
            return
        }
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: employeesTableView.bounds.width, height: 36)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.color = UIColor.skyBlue
        activityIndicator.center = CGPoint(x: employeesTableView.bounds.width/2, y: 18)
        view.addSubview(activityIndicator)
        employeesTableView.tableFooterView = view
        isPaginationInProgress = true
        delegate?.fetchNextPage()
        
    }
}

