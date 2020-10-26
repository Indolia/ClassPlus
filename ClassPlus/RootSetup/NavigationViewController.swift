//
//  NavigationViewController.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import UIKit

protocol NavigationViewControllerProtocol {
    func set(rootViewController: UIViewController)
    func set(viewControllers: [UIViewController])
    func push(viewController: UIViewController, animated: Bool)
    func setNavigationBar(hidden: Bool, animation: Bool)
    func popViewController(with animated: Bool)
}

class NavigationViewController: UINavigationController, NavigationViewControllerProtocol {
    var button: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor.skyBlue
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        // Do any additional setup after loading the view.
    }
    
    static var current: NavigationViewControllerProtocol {
        let navViewController = NavigationViewController.get(with: "NavigationViewController", storyboard: AppConstants.Storyboard.main.rawValue)
        
        guard let someNavCV = navViewController as? NavigationViewController else {
            fatalError("NavigationViewController not find, check it")
        }
        return someNavCV
    }
    
    func set(rootViewController: UIViewController) {
        self.viewControllers = [rootViewController]
        AppDelegate.shared.window?.rootViewController = self
    }
    
    func set(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
       
    }
    
    func push(viewController: UIViewController, animated: Bool) {
        self.pushViewController(viewController, animated: animated)
    }
    
    func setNavigationBar(hidden: Bool, animation: Bool) {
        self.setNavigationBarHidden(hidden, animated: animation)
    }
    
    func popViewController(with animated: Bool) {
        self.popViewController(animated: animated)
    }
    
    
}


