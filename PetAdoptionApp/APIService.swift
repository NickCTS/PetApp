import Foundation

class APIService {
    static let shared = APIService()
    
    // Define the base URL for your API
    private let baseURL = "http://192.168.4.62:5001/api"
    
    // MARK: - Register User
    func registerUser(user: User, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/register") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let responseUser = try JSONDecoder().decode(User.self, from: data)
                completion(.success(responseUser))
            } catch {
                print("Decoding error during registration:", error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Login User
    func loginUser(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginData = ["username": username, "password": password]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: loginData, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                print("Decoding error during login:", error)
                completion(.failure(error))
            }
        }.resume()
    }
    // MARK: - Fetch Pets
    func fetchPets(completion: @escaping (Result<[Pet], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/pets") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching pets:", error)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received for pets")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let pets = try JSONDecoder().decode([Pet].self, from: data)
                completion(.success(pets))
            } catch {
                print("Decoding error during fetchPets:", error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Fetch User Applications
    func fetchUserApplications(userID: Int, completion: @escaping (Result<[AdoptionApplication], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/applications?user_id=\(userID)") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Network error while fetching applications:", error)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let applications = try JSONDecoder().decode([AdoptionApplication].self, from: data)
                completion(.success(applications))
            } catch {
                print("Decoding error during fetchUserApplications:", error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Apply for Adoption
    func applyForAdoption(petID: Int, userID: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/applications") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let applicationData = ["pet_id": petID, "user_id": userID]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: applicationData, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Application failed"])))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    // Fetch user's favorite pets
    func fetchFavoritePets(userID: Int, completion: @escaping (Result<[Pet], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/favorites/\(userID)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            do {
                let pets = try JSONDecoder().decode([Pet].self, from: data)
                completion(.success(pets))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Add pet to favorites
    func addFavorite(userID: Int, petID: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/favorites") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["user_id": userID, "pet_id": petID]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false)
                return
            }
            completion(true)
        }.resume()
    }
    
    // Remove pet from favorites
    func removeFavorite(userID: Int, petID: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/favorites") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["user_id": userID, "pet_id": petID]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false)
                return
            }
            completion(true)
        }.resume()
    }
}
