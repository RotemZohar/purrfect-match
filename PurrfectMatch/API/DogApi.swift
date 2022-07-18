//
//  DogApi.swift
//  PurrfectMatch
//
//

import Foundation
import Alamofire



class DogApi{
    
    static func getBreeds(onComplete:@escaping (DogBreeds?)->Void){
        AF.request("https://api.thedogapi.com/v1/breeds").responseDecodable(of:DogBreeds.self){ response in
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
    
    static func getThreeBreeds(onComplete:@escaping ([DogBreed])->Void){
        var breeds = [DogBreed]()
        let dispatchGroup = DispatchGroup()
        for index in 1...35 {
            dispatchGroup.enter()
            AF.request("https://api.thedogapi.com/v1/breeds/" + String(index * 5)).responseDecodable(of:DogBreed.self){ response in
                switch response.result{
                case .success(let breed):
                    breeds.append(breed)
                case .failure(let error):
                    print("error : \(error)")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main){
            onComplete(breeds)
        }
    }
}
