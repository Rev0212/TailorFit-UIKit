import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    var gpuServerURL: String?

    func fetchGPUUrl(completion: @escaping (String?) -> Void) {
        // Use the GitHub Pages URL provided by GitHub
        guard let url = URL(string: "https://yourusername.github.io/gpu-server-url/gpuServerUrl.json") else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching URL: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }
            
            // Parse the JSON data
            if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: String],
               let fetchedUrl = jsonObject["url"] {
                self.gpuServerURL = fetchedUrl
                print("Fetched GPU Server URL: \(fetchedUrl)")
                completion(fetchedUrl)
            } else {
                print("Failed to decode JSON.")
                completion(nil)
            }
        }
        task.resume()
    }
}
