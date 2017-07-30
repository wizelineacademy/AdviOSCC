
import Foundation

class ShareManager {
    static let shared = ShareManager()
    
    var shares = [Share]()
    
    func addShare(_ share: Share) {
        shares.insert(share, at: 0)
    }
    
    func editShare(_ index: Int, firstName: String, lastname: String, amount: Double, updated: Date) {
        var share = shares[index]
        share.firstName = firstName
        share.lastName = lastname
        share.amount = amount
        share.updatedAt = updated
        shares[index] = share
    }
    
    func removeShare(_ index: Int) {
        shares.remove(at: index)
    }
    
}
