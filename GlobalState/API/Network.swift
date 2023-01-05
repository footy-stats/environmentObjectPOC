import SwiftUI

class Network: ObservableObject {
    @Published var users: [User] = []
    @Published var resources: [Resource] = []
    
    enum NetworkError: Error {
      case invalidURL
      case requestFailed
      case decodingFailed
    }
    
    @MainActor func getUsers() async throws {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedUsers = try JSONDecoder().decode([User].self, from: data)
        self.users = decodedUsers
    }
    
    @MainActor func getResources() async throws {
        guard let url = URL(string: "http://localhost:3000") else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode([Resource].self, from: data)
        print(decodedData)
        self.resources = decodedData
    }
    
    @MainActor func updateResources() async throws {
        guard let url = URL(string: "http://localhost:3000") else {
            throw NetworkError.invalidURL
        }
        
        let httpBody: Data
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(Resource(id: 1, data: "This is updated again"))
            httpBody = data
        } catch {
            print(error)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let _ = try decoder.decode(Resource.self, from: data)
                //                completion(updatedResource)
            } catch {
                print(error)
            }
        }.resume()
    }
}
