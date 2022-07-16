//
//  Defaults.swift
//  StudentApp
//
//  Created by admin on 16/07/2022.
//

import Foundation

struct Defaults {
    
//    static let NAME: String = "name"
    static let EMAIL: String = "email"
    static let PASSWORD: String = "password"
    static let LOGIN = "login"

    private static let userDefault = UserDefaults.standard
    

    struct UserDetails {
//        let name: String
        let email: String
        let password: String

        init(_ json: [String: String]) {
//            self.name = json[NAME] ?? ""
            self.email = json[EMAIL] ?? ""
            self.password = json[PASSWORD] ?? ""
        }
    }
    
    static func save( email: String, password: String){
        userDefault.set([EMAIL: email, PASSWORD: password],
                                forKey: LOGIN)
    }
    

    static func getUserInfo()-> UserDetails {
        return UserDetails((userDefault.value(forKey: LOGIN) as? [String: String]) ?? [:])
    }
    

    static func clearUserInfo(){
        userDefault.removeObject(forKey: LOGIN)
    }
}
