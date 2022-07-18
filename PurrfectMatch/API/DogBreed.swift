//
//  DogBreed.swift
//  StudentApp
//
//  Created by Eliav Menachi on 08/06/2022.
//

import Foundation

struct DogBreed: Decodable {
    var id: Int? = 0
    var name: String? = ""
    var bredFor: String? = ""
    var breedGroup: String? = ""
    var lifeSpan: String? = ""
    var temperament: String? = ""
    var origin: String? = ""
//    let weight: String
//    let height: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case bredFor = "bred_for"
        case breedGroup = "breed_group"
        case lifeSpan = "life_span"
        case temperament
        case origin
//        case weight = "weight.metric"
//        case height = "height.metric"
    }
}

struct DogBreeds: Decodable {
    let count: Int
    let all: [DogBreed]
    
    enum CodingKeys: String, CodingKey {
        case count
        case all = "results"
    }
}


