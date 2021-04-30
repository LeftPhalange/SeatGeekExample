//
//  Events.swift
//  SeatGeekExample
//
//  Created by Ethan Bovard on 4/27/21.
//

import Foundation

struct Event {
    let type: String
    let url: String
    let title: String
    let id: Int
    let localDate: Date // parse to Date
    let venue: Venue
    let performers: Performers
    init? (json: [String: Any]) {
        self.type = json["type"] as! String;
        self.id = json["id"] as! Int;
        self.venue = Venue.init(json: json["venue"] as! [String: Any])!
        self.url = json["url"] as! String;
        self.title = json["title"] as! String;
        self.performers = Performers.init(json: json["performers"] as! [[String : Any]])!
        let dateFormatter = DateFormatter();
        self.localDate = dateFormatter.date(from: json["datetime_local"] as! String) ?? Date();
    }
}

// Structs within event

struct Venue {
    let displayLocation: String
    init? (json: [String: Any]) {
        self.displayLocation = json["display_location"] as! String
    }
}

struct Performers {
    var images: [String] = []
    init? (json: [[String: Any]]) {
        for jsonObj in json {
            let image = jsonObj["image"] as! String
            self.images.append(image);
        }
    }
}
