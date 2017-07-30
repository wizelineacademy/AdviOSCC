
import Foundation

struct Share: Equatable {
    
    var firstName: String
    var lastName: String
    var createdAt: Date
    var updatedAt: Date
    var amount: Double
    
    init(firstName: String, lastName: String, createdAt: Date, amount: Double) {
        self.firstName = firstName
        self.lastName = lastName
        self.createdAt = createdAt
        self.updatedAt = createdAt
        self.amount = amount
    }
    
}

func ==(l: Share, r: Share) -> Bool {
    return l.firstName == r.firstName &&
           l.lastName == r.lastName &&
           l.createdAt == r.createdAt &&
           l.amount == r.amount
}
