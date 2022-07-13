//
//  DogBreed.swift
//  StudentApp
//
//  Created by Eliav Menachi on 08/06/2022.
//

import Foundation

struct DogBreed: Decodable {
    let id: Int
    let name: String
    let bredFor: String
    let breedGroup: String
    let lifeSpan: String
    let temperament: String
    let origin: String
    let weight: String
    let height: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case bredFor = "bred_for"
        case breedGroup = "breed_group"
        case lifeSpan = "life_span"
        case temperament
        case origin
        case weight = "weight.metric"
        case height = "height.metric"
    }
}

struct SWFilms: Decodable {
    let count: Int
    let all: [DogBreed]
    
    enum CodingKeys: String, CodingKey {
        case count
        case all = "results"
    }
}


