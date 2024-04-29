//
//  PostModel.swift
//  Assessment
//
//  Created by Clavax on 27/04/24.
//

import Foundation
import Firebase

struct Post {
    var username: String
    var description: String
    var creationDate: Date?
    var imageURLs: [String]?
    
    init(username: String, description: String, creationDate: Date?, imageURLs: [String]?) {
        self.username = username
        self.description = description
        self.creationDate = creationDate
        self.imageURLs = imageURLs
    }
    
    init?(documentData: [String: Any]) {
        guard let username = documentData["username"] as? String,
              let description = documentData["description"] as? String else {
            return nil
        }
        let creationTimestamp = documentData["creationDate"] as? Timestamp
        let creationDate = creationTimestamp?.dateValue()
        
        var imageURLs: [String]? = nil
        if let urls = documentData["imageURLs"] as? [String] {
            imageURLs = urls
        }
        
        self.init(username: username, description: description, creationDate: creationDate, imageURLs: imageURLs)
    }
}



