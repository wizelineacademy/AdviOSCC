//: Playground - noun: a place where people can play

import UIKit

// Object-Oriented

class ClassPlanet {
    var name: String
    var isBreathable: Bool
    
    init(name: String, isBreathable: Bool) {
        self.name = name
        self.isBreathable = isBreathable
    }
}

class ClassEarth: ClassPlanet {
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

let earth = ClassEarth(name: "Class Earth", oxygen: 15, nitrogen: 70)
earth.name
earth.isBreathable

// Protocol-Oriented 

protocol PlanetProtocol {
    var name: String { get }
    var isBreathable: Bool { get }
}

protocol Breathable {
    var oxygen: Double { get }
    var nitrogen: Double { get }
}

extension PlanetProtocol {
    var isBreathable: Bool {
        return self is Breathable
    }
}

extension Breathable {
    func airQuality() -> String {
        return (oxygen / nitrogen) >= 0.18 ? "good" : "bad"
    }
}

struct PlanetStruct: PlanetProtocol {
    var name: String
}

struct EarthStruct: PlanetProtocol, Breathable {
    var name: String
    var oxygen: Double
    var nitrogen: Double
}

let earth1 = EarthStruct(name: "Struct Earth", oxygen: 20, nitrogen: 80)
earth1.name
earth1.isBreathable
