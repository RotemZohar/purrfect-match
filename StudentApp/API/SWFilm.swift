//
//  SWFilm.swift
//  StudentApp
//
//  Created by Eliav Menachi on 08/06/2022.
//

import Foundation

struct SWFilm: Decodable {
    let id: Int
    let title: String
    let openingCrawl: String
    let director: String
    let producer: String
    let releaseDate: String
    let starships: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "episode_id"
        case title
        case openingCrawl = "opening_crawl"
        case director
        case producer
        case releaseDate = "release_date"
        case starships
    }
}

struct SWFilms: Decodable {
    let count: Int
    let all: [SWFilm]
    
    enum CodingKeys: String, CodingKey {
        case count
        case all = "results"
    }
}


