//
//  DebuggingViewController.swift
//  AcademyCrashCourse
//
//  Created by Jorge R Ovalle Z on 7/11/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit



class DebuggingViewController: UIViewController {
    var users: [User]!
    
    var media:CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        users = [User(name: "Jorge", age: 25),
                 User(name: "Andres", age: 22),
                 User(name: "Carlos", age: 20),
                 User(name: "Maria", age: 19),
                 User(name: "John", age: -35),
                 User(name: "Sofia", age: 29),
                 User(name: "Antonia", age: 22),
                 User(name: "Renata", age: 21),
                 User(name: "Patrick", age: -20)]
        
        media = 20
        
/*
        // Conditional
        for user in users {
            // Something
        }
        
        
        for i in 0...10 {
            
        }
        
 */
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = self.average(users: users)

        do {
            _ = try Dog(name: "PepeRoni")
        }
        catch (Dog.PetError.invalidName) {
            print("invalidName")
        }
        catch (_) {
            print("Generic Error")
        }
        
        self.mediaTest()
    }
    
    
    func mediaTest() {
        let media: CGFloat = 0   
        print("\(media)")
        
    }
    
    
    func average(users: [User]) -> Double {
        var average: Double = 0
        for user in users {
            average = average + Double(user.age)
        }
        return average/Double(users.count)
    }
    
    struct User {
        let name: String
        let age: Int
    }
    
    struct Dog {
        enum PetError: Error {
            case invalidName
        }
        
        let name: String
        
        init(name: String) throws {
            if name.characters.count > 6 {
                throw PetError.invalidName
            }
            self.name = name
        }
    }
    

}
