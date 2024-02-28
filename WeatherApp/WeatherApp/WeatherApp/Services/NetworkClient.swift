//
//  NetworkClient.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 1.02.22.
//

import Foundation

class NetworkClient {

    private let decoder = JSONDecoder()


    func perform<T: Decodable>(urlPath: URL?, completion: @escaping (Result<T>) -> ()) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        guard let url = urlPath else {
            completion(.failure(WeatherError.badConnection))
            return
        }

        session.dataTask(with: url) {  data, resp, error in
            if error != nil {
                completion(.failure(WeatherError.badConnection))
            } else {
                if let httpResponse = resp as? HTTPURLResponse {

                    if httpResponse.statusCode == 200, let data = data {
                        do {
                            let result = try self.decoder.decode(T.self, from: data)
                            completion(.success(result.self))
                        } catch {
                            completion(.failure(WeatherError.badResponse))
                        }
                    } else if httpResponse.statusCode == 401  {
                        completion(.failure(WeatherError.invalidAPIKey))
                    } else {
                        completion(.failure(WeatherError.serverUnavailable))
                    }

                } else {
                    completion(.failure(WeatherError.badResponse))
                }
            }
        }.resume()

    }

}

