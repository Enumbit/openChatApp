    //
    //  ConnectorApi.swift
    //  ChatHur
    //
    //  Created by Mark Heijnekamp on 12/07/2025.
    //

import Foundation

struct ConnectorApi {
    static func request<T: Codable, U: Codable>(
        url: URL,
        data: T,
        responseType: U.Type,
        bearerToken: String? = nil,
        method: String = "GET"
        
    ) async throws -> U {  // Return type U instead of URLResponse
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = bearerToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if method == "POST"{
            do {
                request.httpBody = try JSONEncoder().encode(data)
                request.httpBody.map { print(String(data: $0, encoding: .utf8) ?? "No data") }
            } catch {
                throw ConnectorApiError.encodingFailed(error)
            }
        }
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Error in getting the response")
            throw ConnectorApiError.invalidResponse
        }
        
            // Check for HTTP errors
        guard 200...299 ~= httpResponse.statusCode else {
            print("Status code error: \(httpResponse.statusCode)")
            print(responseData)
            throw ConnectorApiError.httpError(httpResponse.statusCode, responseData)
        }
        
        print("Status code: \(httpResponse.statusCode)")
        
            // Decode the response to the specified type
        do {
            return try JSONDecoder().decode(responseType, from: responseData)
        } catch {
            throw ConnectorApiError.decodingFailed(error)
        }
    }
}

    // Add the missing error case
enum ConnectorApiError: Error {
    case encodingFailed(Error)
    case invalidResponse
    case httpError(Int, Data)
    case decodingFailed(Error)  // Add this
}
