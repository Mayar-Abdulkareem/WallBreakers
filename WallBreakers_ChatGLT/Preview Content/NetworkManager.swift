//
//  NetworkManager.swift
//  WallBreakers
//
//  Created by ftsmobileteam on 16/04/2024.
//

import Foundation

class NetworkManager {
    static func askQuestion(message: String) async throws -> ReceivedMessage? {
        let urlString = "http://51.12.248.73:443/answer_question"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["question": message]
        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        } catch {
            throw error
        }

//        try await Task.sleep(nanoseconds: 2_000_000_000)
//        return ReceivedMessage(answer: "test")
        return try await performRequest(request: request)
    }
    
    @discardableResult
    internal static func performRequest<T: Decodable>(
        request: URLRequest
    ) async throws -> T {
       
        let (data, response) = try await URLSession.shared.data(for: request)

        return try JSONDecoder().decode(
            T.self,
            from: data
        )
    }
}

