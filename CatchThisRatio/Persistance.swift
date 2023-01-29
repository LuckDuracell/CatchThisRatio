//
//  Persistance.swift
//  CatchThisRatio
//
//  Created by Luke Drushell on 1/28/23.
//

import Foundation

struct Map: Codable, Hashable, Equatable {
    var wins: Int
    var losses: Int
    var title: String
    var subtitle: String
    var image: String
}

class MapsModel: ObservableObject {
    @Published var maps: [Map] = [Map(wins: 0, losses: 0, title: "Busan", subtitle: "Downtown", image: "busan downtown"), Map(wins: 0, losses: 0, title: "Illios", subtitle: "Ruins", image: "illios ruins"), Map(wins: 0, losses: 0, title: "Busan", subtitle: "Sanctuary", image: "busan sanctuary"), Map(wins: 0, losses: 0, title: "Ayutthaya", subtitle: "", image: "ayutthaya"), Map(wins: 0, losses: 0, title: "Oasis", subtitle: "University", image: "oasis university"), Map(wins: 0, losses: 0, title: "Lijiang", subtitle: "Garden", image: "lijiang garden")]

    init() {
        if let data = UserDefaults.standard.data(forKey: "maps"), let maps = try? JSONDecoder().decode([Map].self, from: data) {
            self.maps = maps
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(maps) {
            UserDefaults.standard.set(data, forKey: "maps")
        }
    }
}

