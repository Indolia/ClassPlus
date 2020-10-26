//
//  LogOutManager.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

import Foundation
import CoreData
struct LogoutManager {
    static func logout() {
        IKeyChain.shared.delete(key: AppConstants.UserInfo.key)
    }
}
