import Foundation

private let apiURL = "https://669ff1b9b132e2c136ffa741.mockapi.io/picpay/ios/interview/contatos"

enum ListContactsServiceError: Error {
    case invalidURL
    case decodingFailed
    case noData
}

protocol ListContactServiceProtocol {
    func fetchContacts(completion: @escaping (Result <[Contact], ListContactsServiceError>) -> Void)
}

class ListContactService: ListContactServiceProtocol {
    func fetchContacts(completion: @escaping (Result <[Contact], ListContactsServiceError>) -> Void) {
        guard let api = URL(string: apiURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: api) { (data, response, error) in
            guard let jsonData = data else {
                completion(.failure(.decodingFailed))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode([Contact].self, from: jsonData)
                
                completion(.success(decoded))
            } catch let error {
                completion(.failure(.decodingFailed))
            }
        }
        
        task.resume()
    }
}
