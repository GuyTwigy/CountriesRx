//
//  NetworkManager.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import Foundation
import RxSwift

class NetworkManager {

    private var session: URLSessionProtocol = URLSession.shared

    func setSession(session: URLSessionProtocol) {
        self.session = session
    }

    func getRequestData<T: Decodable>(components: URLComponents?, type: T.Type) -> Single<T> {
        return Single.create { [weak self] single in
            guard let url = components?.url else {
                single(.failure(URLError(.badURL)))
                return Disposables.create()
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            let task = self?.session.dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    single(.failure(URLError(.badServerResponse)))
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    single(.failure(URLError(.badServerResponse)))
                    return
                }

                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data ?? Data())
                    single(.success(decodedData))
                } catch {
                    single(.failure(error))
                }
            }

            task?.resume()
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
