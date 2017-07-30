
import Foundation

open class DetailViewModel {

    var title = "New Share"
    var name = ""
    var amount = ""
    weak var delegate: DetailViewModelDelegate?
    
    open var infoText: String {
        let amount = (self.amount as NSString).doubleValue
        return "\(name)\n\(amount)"
    }
    
    fileprivate var index: Int = -1
    
    var isNew: Bool {
        return index == -1
    }
    
    // new initializer
    public init(delegate: DetailViewModelDelegate) {
        self.delegate = delegate
    }
    
    // edit initializer
    public convenience init(delegate: DetailViewModelDelegate, index: Int) {
        self.init(delegate: delegate)
        self.index = index
        print(index)
        title = "Edit Share"
        let share = ShareManager.shared.shares[index]
        name = share.firstName + " " + share.lastName
        amount = "\(share.amount)"
    }
    
    open func handleDonePressed() {
        if !validateName() {
            delegate?.handleError(withMessage: "Invalid name")
        }
        else if !validateAmount() {
            delegate?.handleError(withMessage: "Invalid amount")
        }
        else {
            if isNew {
                addShare()
            }
            else {
                saveShare()
            }
            delegate?.dismissAddView()
        }
    }
    
    fileprivate var nameComponents : [String] {
        return name.components(separatedBy: " ").filter { !$0.isEmpty }
    }
    
    
    func validateName() -> Bool {
        return nameComponents.count >= 2
    }
    
    func validateAmount() -> Bool {
        let value = (amount as NSString).doubleValue
        return value.isNormal && value > 0
    }
    
    func addShare() {
        let names = nameComponents
        let amount = (self.amount as NSString).doubleValue
        let share = Share(firstName: names[0], lastName: names[1], createdAt: Date(), amount: amount)
        ShareManager.shared.addShare(share)
    }
    
    func saveShare() {
        let names = nameComponents
        let amount = (self.amount as NSString).doubleValue
        ShareManager.shared.editShare(index, firstName: names[0], lastname: names[1], amount: amount, updated: Date())
    }
    
}

public protocol DetailViewModelDelegate: class {
    func dismissAddView()
    func handleError(withMessage message: String)
}
