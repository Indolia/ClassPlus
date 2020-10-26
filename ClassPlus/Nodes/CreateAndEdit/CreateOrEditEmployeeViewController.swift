//
//  CreateOrEditEmployeeViewController.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import UIKit


protocol CreateOrEditEmployeeViewActionDelegate:class {
    func viewDidLoad()
    func createEmployee(with firstName: String?, lastName: String?, email: String?)
    func editEmployee(with firstName: String?, lastName: String?, email: String?, id: Int)
}

protocol CreateOrEditEmployeeViewProtocol:class {
    static func get(from storyboard: AppConstants.Storyboard, with nav: NavigationViewControllerProtocol, delegate: CreateOrEditEmployeeViewActionDelegate, mode type: ModeType, employee: EmployeeModel?) -> CreateOrEditEmployeeViewProtocol
    func pushInNavStack()
    func popFromNavStack()
    func alert(for message: String)
    func alertWithCompletion(for message: String, completion: @escaping() -> Void)
    func populateDataOnView()
}


class CreateOrEditEmployeeViewController: UIViewController {
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var createOrEditButton: UIButton!
    private var nav: NavigationViewControllerProtocol?
    weak var delegate: CreateOrEditEmployeeViewActionDelegate?
    private var mode: ModeType!
    private var employee: EmployeeModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
        // Do any additional setup after loading the view.
    }
    
    private func uiSetup() {
        createOrEditButton.applyGradient(colours: UIColor.gradientColors, locations: [0.5 , 1.0])
        createOrEditButton.cornerRadius(with: 8)
        delegate?.viewDidLoad()
    }
    
    private func populateDataForEditMode() {
        title = "Edit Details"
        createOrEditButton.setTitle("Edit", for: .normal)
        firstNameTextField.text = employee?.firstName
        lastNameTextField.text = employee?.lastName
        emailTextField.text = employee?.email
    }
    
    private func populateDataForCreateMode() {
        title = "Create A Employee"
        createOrEditButton.setTitle("Create", for: .normal)
        
    }
    
    @IBAction func createOrEdit(_ sender: Any) {
        switch mode {
        case .create:
            delegate?.createEmployee(with: firstNameTextField.text, lastName: lastNameTextField.text, email: emailTextField.text)
        case .edit:
            if let id = employee?.id {
                delegate?.editEmployee(with: firstNameTextField.text, lastName: lastNameTextField.text, email: emailTextField.text, id: id)
            }
        case .none:
            break
        }
    }
}


extension CreateOrEditEmployeeViewController: CreateOrEditEmployeeViewProtocol{
    func popFromNavStack() {
        nav?.popViewController(with: true)
    }
    
    func alertWithCompletion(for message: String, completion: @escaping () -> Void) {
        self.view.endEditing(true)
        self.alert(title: "Info", message: message) {
            completion()
        }
    }
    
    func populateDataOnView() {
        guard let mode = self.mode else {
            print("View mode not set")
            return
        }
        switch mode {
        case .create:
            populateDataForCreateMode()
        case .edit:
            populateDataForEditMode()
        }
    }
    
    func pushInNavStack() {
        nav?.push(viewController: self, animated: true)
    }
    
    func alert(for message: String) {
        self.alert(title: "Info", message: message)
    }
    
    static func get(from storyboard: AppConstants.Storyboard, with nav: NavigationViewControllerProtocol, delegate: CreateOrEditEmployeeViewActionDelegate, mode type: ModeType, employee: EmployeeModel?) -> CreateOrEditEmployeeViewProtocol {
        let vc = CreateOrEditEmployeeViewController.get(with: "CreateOrEditEmployeeViewController", storyboard: storyboard.rawValue) as? CreateOrEditEmployeeViewController
        vc?.nav = nav
        vc?.delegate = delegate
        vc?.mode = type
        vc?.employee = employee
        guard let unwrappedVC = vc else {
            fatalError("CreateOrEditEmployeeViewController not found in \(storyboard)")
        }
        
        return unwrappedVC
    }
    
}
