import Foundation

protocol ListContactServiceViewModelProtocol: AnyObject {
    func SuccessLoadContacts(_ contacts: [Contact])
    func FailedToLoadContacts(with error: ListContactsServiceError)
}

class ListContactsViewModel {
    private let service: ListContactServiceProtocol
    
    weak var delegate: ListContactServiceViewModelProtocol?
    
    init(service: ListContactServiceProtocol = ListContactService()) {
        self.service = service
    }
    
    func loadContacts() {
        service.fetchContacts {
            [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let contacts):
                    self?.delegate?.SuccessLoadContacts(contacts)
                case .failure(let error):
                    self?.delegate?.FailedToLoadContacts(with: error)
                }
            }
        }
    }
}
