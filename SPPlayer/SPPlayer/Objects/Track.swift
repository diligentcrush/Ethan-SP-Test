//
//  Track.swift
//  SPPlayer
//
//  Created by Ethan Chen on 11/21/18.
//  Copyright © 2018 Estamp. All rights reserved.
//

import Foundation
import ObjectMapper

class Track: Mappable {
    var name: String?
    var uri: String?
    var album: Album?
    var artists: [Artist]?
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        uri <- map["uri"]
        album <- map["album"]
        artists <- map["artists"]
        
    }
}

class Artist: Mappable {
    var name: String?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        name <- map["name"]
    }
    
}

class Album: Mappable {
    var images: [trackImage]?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        images <- map["images"]

    }
}

class trackImage: Mappable {
    var url: String?
    var height: Int?
    var width: Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        url <- map["url"]
        height <- map["height"]
        width <- map["width"]
    }
}
