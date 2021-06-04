//
//  FlickrPhoto.swift
//  FlikrTest
//
//  Created by Prabhjot Singh on 03/06/21.
//  Copyright © 2021 Gogana Solutions. All rights reserved.
//

import Foundation

//used the Global array for flikr array to get working for every classes.
var photosFlickrGlobal = [FlickrPhoto]()

// Model of the Flickr Photo with Codable Protocol

struct FlickrPhoto: Codable {
    
    let title, ownername, url, picID: String
    var isFav = false

    enum CodingKeys: String, CodingKey {
        case title, ownername
        case url = "url_m"
        case picID = "id"
    }
}



// MARK: Convenience initializers

extension FlickrPhoto {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(FlickrPhoto.self, from: data) else { return nil }
        self = me
    }
}
