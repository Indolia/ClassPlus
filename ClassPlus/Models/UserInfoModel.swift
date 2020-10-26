//
//  UserInfoModel.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

struct UserInfoModel {
    let userName: String
    let password: String
}

//MARK: - sign in logic
extension UserInfoModel {
    func signIn(completion:(Any?)->Void) {
        let userData =  IKeyChain.shared.load(key: AppConstants.UserInfo.key)
        if let someUserData = userData {
            let userInfo = someUserData.unarchivedObject()
            completion(userInfo)
        }else {
            completion(nil)
        }
    }
}

//MARK: - sign up logic

extension UserInfoModel {
    func signUp(completion:(Bool)->Void) {
        let userInfo = self.json()
        print(userInfo)
        let userData = Data.archivedData(from: userInfo)
        if let someData = userData {
            let status = IKeyChain.shared.save(key: AppConstants.UserInfo.key, data: someData)
            if status == noErr {
               completion(true)
            }else {
                completion(false)
            }
        }
    }
    
    func json()-> Dictionary<String,String> {
        let json = ["userName" : self.userName, "password" : self.password]
        return json
    }
    
}
