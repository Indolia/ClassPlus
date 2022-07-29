//
//  AppConstants.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

struct AppConstants {
    struct UserInfo {
        static let key:String = "top_headlines_user_info_key"
    }
    
    enum Storyboard: String {
        case main = "Main"
    }
   
    struct ViewControllerStotyboardId {
        static let navigationViewController = "NavigationViewController"
        static let welcomeViewController = "WelcomeViewController"
        static let signInOrSignUpViewController  = "SignInOrSignUpViewController"
        static let headlinesTableViewController = "HeadlinesTableViewController"
        static let headlineDetailsTableViewController = "HeadlineDetailsTableViewController"
    }
    
    struct ServerURL {
       // static let baseURL = "https://reqres.in/api/users"
        static let baseURL = "https://api.github.com/repos/Indolia/ClassPlus/pulls?state=all"
    }
}
