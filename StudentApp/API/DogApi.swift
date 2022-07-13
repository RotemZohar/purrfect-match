//
//  DogApi.swift
//  StudentApp
//
//  Created by Eliav Menachi on 08/06/2022.
//

import Foundation
import Alamofire



class DogApi{
    
    static func getFilms(onComplete:@escaping (SWFilms?)->Void){
        AF.request("https://api.thedogapi.com/v1/breeds?limit=10&page=0").responseDecodable(of:SWFilms.self){ response in
            switch response.result{
            case .success(let data):
                print ("success")
                onComplete(data)
            case .failure(let error):
                print("error : \(error)")
                onComplete(nil)
            }
        }
    }
    
    static func getFilms123(onComplete:@escaping ([SWFilm])->Void){
        var films = [SWFilm]()
        let dispatchGroup = DispatchGroup()
        for index in 1...3 {
            dispatchGroup.enter()
            AF.request("https://swapi.dev/api/films/" + String(index)).responseDecodable(of:SWFilm.self){ response in
                switch response.result{
                case .success(let film):
                    films.append(film)
                case .failure(let error):
                    print("error : \(error)")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main){
            onComplete(films)
        }
    }
}
