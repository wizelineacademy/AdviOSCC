//: Playground - noun: a place where people can play

import UIKit

// Object-Oriented

class Planet {
    var name: String
    var isBreathable: Bool
    
    init(name: String, isBreathable: Bool) {
        self.name = name
        self.isBreathable = isBreathable
    }
}

class Earth: Planet {
    var oxygen: Double
    var nitrogen: Double
    
    init(name: String, oxygen: Double, nitrogen: Double) {
        self.oxygen = oxygen
        self.nitrogen = nitrogen
        
        super.init(name: name, isBreathable: true)
    }
    
    func airQuality() -> String {
        return (oxygen / nitrogen) >= 0.18 ? "good" : "bad"
    }
}

let earth = Earth(name: "Earth", oxygen: 15, nitrogen: 70)
earth.name
earth.isBreathable
