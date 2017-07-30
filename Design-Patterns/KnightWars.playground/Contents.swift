import PlaygroundSupport
import UIKit
PlaygroundPage.current.needsIndefiniteExecution = true

// ***********************************************************
// ========================== Model ==========================
// ***********************************************************

// ========================== Abstract Troop ==========================

protocol Troop {
    var health: Int { get set }
    var defense: Int { get set }
}

protocol Attacker {
    var attack: Int { get }
}

// Decorator Pattern
protocol AttackerRage: Attacker {
    var baseAttacker: Attacker { get set }
}

protocol BuildingAttacker {
    var buildingAttack: Int { get }
}

// ========================== Concrete Troop ==========================

struct Bowman: Troop, Attacker {
    var defense: Int = 4
    var health: Int = 200
    var range: Int = 100
    var speed: Int = 7
    var attack: Int = 8
}

struct Swordman: Troop, Attacker {
    var defense: Int = 6
    var health: Int = 300
    var speed: Int = 6
    var attack: Int = 10
}

struct MountedSwordman: Troop, Attacker {
    var defense: Int = 8
    var health: Int = 400
    var speed: Int = 10
    var attack: Int = 12
}

struct SiegeRam: Troop, Attacker, BuildingAttacker {
    var defense: Int = 15
    var health: Int = 500
    var speed: Int = 4
    var attack: Int = 16
    var buildingAttack: Int = 400
}

// Decorator Pattern
struct Berserker: AttackerRage {
    var baseAttacker: Attacker
    
    var attack: Int {
        return self.baseAttacker.attack + 20
    }
}

// ========================== Abstract Building ==========================

protocol Building {
    var health: Int { get }
}

protocol Academy {
    func train(_ count: Int) -> [Troop]
}

// FACTORY PATTERN
extension Academy {
    func train(_ count: Int) -> [Troop] {
        switch self {
        case is Barracks:
            return (0..<count).map({ _ in Swordman() })
        case is Range:
            return (0..<count).map({ _ in Bowman() })
        case is Stable:
            return (0..<count).map({ _ in MountedSwordman() })
        case is SiegeWorkshop:
            return (0..<count).map({ _ in SiegeRam() })
        default:
            return []
        }
    }
}

protocol Fort {
    var capacity: Int { get }
}

// ========================== Concrete Building ==========================

struct Barracks: Building {
    let health: Int = 5000
}

extension Barracks: Academy { }

struct Range: Building {
    let health: Int = 4000
}

extension Range: Academy { }

struct Stable: Building {
    let health: Int = 6000
}

extension Stable: Academy { }

struct SiegeWorkshop: Building {
    let health: Int = 8000
}

extension SiegeWorkshop: Academy { }

struct Fortress: Building, Fort {
    let health: Int = 10000
    let capacity: Int = 5000
}


// ***********************************************************
// ========================= Managers ========================
// ***********************************************************

protocol Battle {
    func fight(_ troops: [Troop], against enemyTroops: [Troop], enraged: Bool) -> ([Troop], [Troop])
    func fight(_ troops: [Troop], against enemyBuilding: Building, enraged: Bool) -> ([Troop], Building)
    func fight(_ troops: [Troop], against enemyFort: Fort, enraged: Bool) -> ([Troop], Fort)
}

struct OpenGroundBattle: Battle {
    func fight(_ troops: [Troop], against enemyTroops: [Troop], enraged: Bool) -> ([Troop], [Troop]) {
        // Fight code here
        // No bonus or penalties
        return (troops, enemyTroops)
    }
    func fight(_ troops: [Troop], against enemyBuilding: Building, enraged: Bool) -> ([Troop], Building) {
        // Fight code here
        return (troops, enemyBuilding)
    }
    func fight(_ troops: [Troop], against enemyFort: Fort, enraged: Bool) -> ([Troop], Fort) {
        // Fight code here
        var totalAttack = 0
        if enraged {
            totalAttack = troops.flatMap({ $0 as? Attacker }).map({ Berserker(baseAttacker: $0) }).reduce(0, { $0 + $1.attack })
        } else {
            totalAttack = troops.flatMap({ $0 as? Attacker }).reduce(0, { $0 + $1.attack })
        }
        print("TOTAL ARMY ATTACK: \(totalAttack)")
        
        return (troops, enemyFort)
    }
}

struct ForestBattle: Battle {
    func fight(_ troops: [Troop], against enemyTroops: [Troop], enraged: Bool) -> ([Troop], [Troop]) {
        // Fight code here
        // Bowmen makes -40% damage
        // Siege makes -10% damage
        // Cavalry gains +1 attack
        return (troops, enemyTroops)
    }
    func fight(_ troops: [Troop], against enemyBuilding: Building, enraged: Bool) -> ([Troop], Building) {
        // Fight code here
        return (troops, enemyBuilding)
    }
    func fight(_ troops: [Troop], against enemyFort: Fort, enraged: Bool) -> ([Troop], Fort) {
        // Fight code here
        return (troops, enemyFort)
    }
}

struct MountainBattle: Battle {
    func fight(_ troops: [Troop], against enemyTroops: [Troop], enraged: Bool) -> ([Troop], [Troop]) {
        // Fight code here
        // Bowmen makes +10% damage
        // Siege makes +40% damage
        // Infantry makes -30% damage
        // Cavalry gains +3 attack
        return (troops, enemyTroops)
    }
    func fight(_ troops: [Troop], against enemyBuilding: Building, enraged: Bool) -> ([Troop], Building) {
        // Fight code here
        return (troops, enemyBuilding)
    }
    func fight(_ troops: [Troop], against enemyFort: Fort, enraged: Bool) -> ([Troop], Fort) {
        // Fight code here
        return (troops, enemyFort)
    }
}

struct DesertBattle: Battle {
    func fight(_ troops: [Troop], against enemyTroops: [Troop], enraged: Bool) -> ([Troop], [Troop]) {
        // Fight code here
        // Bowmen makes -30% damage
        // Infantry makes -30% damage
        // Cavalry makes -10 damage
        // No bonus or penalties for Siege troops
        return (troops, enemyTroops)
    }
    func fight(_ troops: [Troop], against enemyBuilding: Building, enraged: Bool) -> ([Troop], Building) {
        // Fight code here
        return (troops, enemyBuilding)
    }
    func fight(_ troops: [Troop], against enemyFort: Fort, enraged: Bool) -> ([Troop], Fort) {
        // Fight code here
        return (troops, enemyFort)
    }
}

// Utils

protocol Identifiable {
    var id: Int { get set }
}

class IdProvider {
    static let shared = IdProvider()
    private var id: Int = 0
    var newId: Int {
        self.id += 1
        return id
    }
    
    private init() { }
}

// SINGLETON PATTERN
class Game {
    static let shared = Game()
    
    private init() { }
    
    func loadGraphics() {
        // loading and rendering
    }
    
    func establishChannel(forAccount accountId: Int, success: (_ channel: URLSession) -> Void) {
        // connect to server and validate security layers
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        success(URLSession.shared)
    }
    
    func connectToGameCenter(success: (_ accountId: Int) -> Void) {
        // connecting to Game center
        success(1)
    }
}

class PlayerSession {
    static let shared = PlayerSession()
    let playerId: Int
    var army: Army
    
    private init() {
        self.playerId = IdProvider.shared.newId
        self.army = Army()
    }
    
    func load(from accountId: Int) {
        // Load from the server all y persisted armies and stuff
    }
}

// STRATEGY PATTERN
struct Army {
    private var current = 0
    var troops = [Troop]()
    var isArmyOnRage = false
    
    init() { }
    
    func fightAgainst(troops enemyTroops: [Troop], at point: CGPoint) {
        getBattleStrategy(at: point).fight(troops, against: enemyTroops, enraged: isArmyOnRage)
    }
    
    func fightAgainst(building enemyBuilding: Building, at point: CGPoint) {
        getBattleStrategy(at: point).fight(troops, against: enemyBuilding, enraged: isArmyOnRage)
    }
    
    func fightAgainst(fort enemyFort: Fort, at point: CGPoint) {
        getBattleStrategy(at: point).fight(troops, against: enemyFort, enraged: isArmyOnRage)
    }
    
    private func getBattleStrategy(at point: CGPoint) -> Battle {
        switch (point.x, point.y) {
        case (0..<100, 0..<100):
            print("Will fight in Open Ground ⚔️")
            return OpenGroundBattle()
        case (100..<200, 0..<100):
            print("Will fight in Forest ⚔️")
            return ForestBattle()
        case (0..<100, 100..<200):
            print("Will fight in Mountain ⚔️")
            return MountainBattle()
        case (100..<200, 100..<200):
            print("Will fight in Desert ⚔️")
            return DesertBattle()
        default:
            return OpenGroundBattle()
        }
    }
}

// ***********************************************************
// ============================ API ==========================
// ***********************************************************

// FACADE PATTERN
class KnightWarsKit {
    static let shared = KnightWarsKit()
    
    func loadGame(success: @escaping () -> Void) {
        Game.shared.connectToGameCenter(success: { (accountId) in
            Game.shared.establishChannel(forAccount: accountId, success: { (session) in
                guard let url = URL(string: "http://MyGame.json") else {
                    return
                }
                let dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                    guard error == nil else {
                        //print("The server is down (It's always the server, not the App 😉)")
                        return
                    }
                    Game.shared.loadGraphics()
                    PlayerSession.shared.load(from: accountId)
                    success()
                })
                dataTask.resume()
            })
        })
    }
}


// ***********************************************************
// ====================== Implementation =====================
// ***********************************************************

KnightWarsKit.shared.loadGame { 
    // This looks very nice
}

print("Start game 👾")
let range = Range()
let stable = Stable()
let newTrainedBowmen = range.train(5)
let newTrainedCavalry = stable.train(8)
PlayerSession.shared.army.troops.append(contentsOf: newTrainedBowmen)
PlayerSession.shared.army.troops.append(contentsOf: newTrainedCavalry)

PlayerSession.shared.army.fightAgainst(fort: Fortress(), at: CGPoint(x: 0, y: 0))

PlayerSession.shared.army.isArmyOnRage = true
print("Army has been enraged!!! 😱😨😱")

PlayerSession.shared.army.fightAgainst(fort: Fortress(), at: CGPoint(x: 0, y: 0))


//
