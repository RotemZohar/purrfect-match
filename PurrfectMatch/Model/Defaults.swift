//
//  Defaults.swift
//  StudentApp
//
//  Created by admin on 16/07/2022.
//

import Foundation

struct Defaults {


    private static let userDefault = UserDefaults.standard
    

    struct UserDetails {
        let name: String
        let email: String

        init(_ json: [String: String]) {
            self.name = json["name"] ?? ""
            self.email = json["email"] ?? ""
        }
    }
    
    static func save( user: User){
        userDefault.set(["email": user.email, "name": user.name], forKey: "user")
        userDefault.set(true, forKey: "login")
    }
    

    static func getUserInfo()-> UserDetails {
        return UserDetails((userDefault.value(forKey: "user") as? [String: String]) ?? [:])
    }
    
    static func getUserLoggedIn()-> Bool {
        return userDefault.bool(forKey: "login")
    }
    

    static func clearUserInfo(){
        userDefault.removeObject(forKey: "user")
        userDefault.set(false, forKey: "login")
    }
    
    static func sync(){
        userDefault.synchronize()
    }
}
