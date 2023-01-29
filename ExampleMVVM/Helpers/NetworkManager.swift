import Foundation

class NetworkManager {

    enum NetworkError: Error {
        case invalidResponse
        case invalidStatusCode(Int)
    }

    enum HttpMethod: String {
        case get
        case post

        var method: String { rawValue.uppercased() }
    }

    func request(fromURL url: String, httpMethod: HttpMethod = .get, paramenters: [String:String] = [:], completion: @escaping (Result<Data, Error>) -> Void) {

        let completionOnMain: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        var components = URLComponents(string: url)
        guard var components = components else { return }
        
        
        let queryItems = paramenters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.queryItems = queryItems
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.method
        

        let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionOnMain(.failure(error))
                return
            }

            guard let urlResponse = response as? HTTPURLResponse else { return completionOnMain(.failure(NetworkError.invalidResponse)) }
            if !(200..<300).contains(urlResponse.statusCode) {
                return completionOnMain(.failure(NetworkError.invalidStatusCode(urlResponse.statusCode)))
            }

            guard let data = data else { return }
            completionOnMain(.success(data))
            return
        }

        urlSession.resume()
    }
}
