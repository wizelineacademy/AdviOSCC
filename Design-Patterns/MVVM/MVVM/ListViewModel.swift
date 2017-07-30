
import Foundation

open class ListViewModel {
    var items = [Item]()
    
    open func refresh() {
        items = ShareManager.shared.shares.map { self.itemForShare($0) }
        print(items)
    }
    
    func itemForShare(_ share: Share) -> Item {
        let singleLetter = share.lastName.substring(to: share.lastName.characters.index(after: share.lastName.startIndex))
        
        let title = "\(share.firstName) \(singleLetter)."
        let subtitle = DateFormatter.localizedString(from: share.createdAt as Date, dateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.none)
        
        let rounded = NSNumber(value: round(share.amount) as Double).int64Value
        let amount = "$\(rounded)"
        
        let item = Item(title: title, subtitle: subtitle, amount: amount)
        
        return item
    }
    
    func removePayback(_ index: Int) {
        ShareManager.shared.removeShare(index)
    }
    
    public struct Item {
        public let title: String
        public let subtitle: String
        public let amount: String
    }
    
}
