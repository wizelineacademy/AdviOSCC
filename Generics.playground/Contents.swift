


/*:
 
 # Generics in swift
 
 ## Guillermo Anaya, @wanaya
 
 */


import UIKit

/*:
 Generic code allows you to write reusable functions and data types that can work with any type that matches the constraints you define
 
 Generic functions
 
 ``` swift-example
 func identity<A>(input: A) -> A
 ```
 
 Protocols with an associated type as “generic protocols".
 
 ``` swift-example
 protocol Value {
    associatedtype ValueType
    var value: ValueType { get }
 }
 ```
 */

//: ## Overload
func raise(_ base: Double, to exponent: Double) -> Double {
    return pow(base, exponent)
}

func raise(_ base: Float, to exponent: Float) -> Float {
    return powf(base, exponent)
}

let double = raise(2.0, to: 3.0) // 8.0 type(of: double) // Double
let float: Float = raise(2.0, to: 3.0) // 8.0 type(of: float) // Float

//----

/*:
 Swift “pick the most specific one.” This means that non-generic functions are picked over generic ones
 */

func log<View: UIView>(_ view: View) {
    print("It's a \(type(of: view)), frame: \(view.frame)")
}

func log(_ view: UILabel) {
    let text = view.text ?? "(empty)"
    print("It's a label, text: \(text)")
}

let label = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 32))
label.text = "Password"

log(label) // It's a label, text: Password
let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
log(button) // It's a UIButton, frame: (0.0, 0.0, 100.0, 50.0)



let views = [label, button]
for view in views {
    log(view)
}

/*:
 It’s important to note that overloads are resolved statically at compile time. This means the compiler bases its decision of which overload to call on the static types of the variables involved, and not on the values dynamic types at runtime.
 */


//----



/*
 It's a UILabel, frame: (20.0, 20.0, 200.0, 32.0) 
 It's a UIButton, frame: (0.0, 0.0, 100.0, 50.0)
 */


//: ### Overloading with Generic Constraints

extension Sequence where Iterator.Element: Equatable { /// Returns true if all elements in `self` are also in `other`. 
    func isSubset(of other: [Iterator.Element]) -> Bool {
        for element in self {
            guard other.contains(element) else {
                return false
            }
        }
        return true
    }
}

let oneToThree = [1,2,3]
let fiveToOne = [5,4,3,2,1]
oneToThree.isSubset(of:  fiveToOne) // true

//: `O(n * m)`

/*: we can increasing performance by changing constraints
 we can convert the other array into a `Set`, taking advantage of the fact that a `Set` performs lookups in constant time `O(1)`
 */

extension Sequence where Iterator.Element: Hashable { /// Returns true if all elements in `self` are also in `other`.
    func isSubset(of other: [Iterator.Element]) -> Bool {
        let otherSet = Set(other)
        for element in self {
            guard otherSet.contains(element) else {
                return false
            }
        }
        return true
    }
}

//: O(n)

//: But the version that requires the elements to be Hashable is more specific, because Hashable extends Equatable


extension Sequence where Iterator.Element: Hashable { /// Returns true if all elements in `self` are also in `other`.
    func isSubset<Source>(of other: Source) -> Bool where Source: Sequence, Source.Iterator.Element == Iterator.Element {
        let otherSet = Set(other)
        for element in self {
            guard otherSet.contains(element) else {
                return false
            }
        }
        return true
    }
}
//: CountableRange
[5,4,3].isSubset(of: 1...10)





//: # Designing with Generics

//: ## Fetching data from network

typealias JSON = [AnyHashable: Any]

var webserviceURL = URL(string: "http://someendpoint.com")!

struct User {
    let name: String
    init(data: Any) {
        let json = data as! JSON
        self.name = json["name"] as! String
    }
}

func loadUsers(completion: @escaping ([User]?) -> ()) {
    let usersURL = webserviceURL.appendingPathComponent("/users")
    let data = try? Data(contentsOf: usersURL)
    let json = data.flatMap {
        try? JSONSerialization.jsonObject(with: $0, options: [])
    }
    let users = (json as? [Any]).flatMap { jsonObject in
        jsonObject.flatMap(User.init)
    }
    completion(users)
}

//: if we want to fetch other types
struct BlogPost {
    let title: String
    init(data: Any) {
        let json = data as! JSON
        self.title = json["title"] as! String
    }
}
//: func loadBlogPosts(completion: ([BlogPost]?) -> ()) {

//: ### Extracting Common Functionality

func loadResource<A>(at path: String,
                  parse: (Any) -> A?,
                  completion: (A?) -> ()) {
    let resourceURL = webserviceURL.appendingPathComponent(path)
    let data = try? Data(contentsOf: resourceURL)
    let json = data.flatMap {
        try? JSONSerialization.jsonObject(with: $0, options: [])
    }
    completion(json.flatMap(parse))
}

func loadUsers2(completion: ([User]?) -> ()) {
    loadResource(at: "/users", parse: jsonArray(User.init), completion: completion)
}

func jsonArray<A>(_ transform: @escaping (Any) -> A?) -> (Any) -> [A]? {
    return { array in
        guard let array = array as? [Any] else {
            return nil
        }
        return array.flatMap(transform)
    }
}

func loadBlogPosts(completion: ([BlogPost]?) -> ()) {
    loadResource(at: "/posts", parse: jsonArray(BlogPost.init), completion: completion)
}
//--

struct Resource<A> {
    let path: String
    let parse: (Any) -> A?
}

extension Resource {
    func loadSynchronously(completion: (A?) -> ()) {
        let resourceURL = webserviceURL.appendingPathComponent(path)
        let data = try? Data(contentsOf: resourceURL)
        let json = data.flatMap {
            try? JSONSerialization.jsonObject(with: $0, options: [])
        }
        completion(json.flatMap(parse))
    }
}

extension Resource {
    func loadAsynchronously(callback: @escaping (A?) -> ()) {
        let resourceURL = webserviceURL.appendingPathComponent(path)
        let session = URLSession.shared
        session.dataTask(with: resourceURL) { data, response, error in
            let json = data.flatMap {
                try? JSONSerialization.jsonObject(with: $0, options: [])
            }
            callback(json.flatMap(self.parse))
        }.resume()
    }
}


//: # Thanks

