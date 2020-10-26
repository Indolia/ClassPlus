//
//  WelcomeViewController.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import UIKit

protocol WelcomeViewActionDelegate:class {
    func proceedAsA(userType: UserType)
}

protocol WelcomeViewProtocol:class {
    static func get(from: AppConstants.Storyboard, with nav: NavigationViewControllerProtocol, delegate: WelcomeViewActionDelegate) -> WelcomeViewProtocol
    func setAsRootView()
}

enum UserType {
    case member
    case guest
}

class WelcomeViewController: UIViewController {
    private var nav: NavigationViewControllerProtocol?
    @IBOutlet var memberButton: UIButton!
    @IBOutlet var guestButton: UIButton!
    weak var delegate: WelcomeViewActionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nav?.setNavigationBar(hidden: true, animation: false)
    }
    
    private func uiSetup() {
        memberButton.applyGradient(colours: UIColor.gradientColors, locations: [0.5 , 1.0])
        memberButton.cornerRadius(with: 8)
        guestButton.applyGradient(colours: UIColor.gradientColors, locations: [0.5 , 1.0])
        guestButton.cornerRadius(with: 8)
    }
    @IBAction func proceedAsAMember(_ sender: Any) {
        delegate?.proceedAsA(userType: .member)
    }
    
    @IBAction func proceedAsAGuest(_ sender: Any) {
        delegate?.proceedAsA(userType: .guest)
    }
    
    
}

extension WelcomeViewController: WelcomeViewProtocol {
    func setAsRootView() {
        nav?.set(rootViewController: self)
    }
    
    
    static func get(from storyboard: AppConstants.Storyboard, with nav: NavigationViewControllerProtocol, delegate: WelcomeViewActionDelegate) -> WelcomeViewProtocol {
        
        let vc = WelcomeViewController.get(with: "WelcomeViewController", storyboard: storyboard.rawValue) as? WelcomeViewController
        vc?.nav = nav
        vc?.delegate = delegate
        guard let unwrappedVC = vc else {
            fatalError("WelcomeViewController not found in \(storyboard)")
        }
        
        return unwrappedVC
    }
    
}
