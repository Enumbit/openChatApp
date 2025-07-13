//
//  Useage.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 13/07/2025.
//

struct Usage: Codable {
    let responseTokenPerS: Double?        // Tokens generated per second
    let promptTokenPerS: Double?          // Tokens processed per second (input)
    let totalDuration: Int?               // Total time in nanoseconds
    let loadDuration: Int?                // Model loading time in nanoseconds
    let promptEvalCount: Int?             // Number of prompt tokens processed
    let promptTokens: Int?                // Same as promptEvalCount
    let promptEvalDuration: Int?          // Time to process prompt in nanoseconds
    let evalCount: Int?                   // Number of response tokens generated
    let completionTokens: Int?            // Same as evalCount
    let evalDuration: Int?                // Time to generate response in nanoseconds
    let approximateTotal: String?         // Human-readable total time ("0h0m17s")
    let totalTokens: Int?                 // Total tokens (prompt + completion)
    let completionTokensDetails: CompletionTokensDetails?
    
    enum CodingKeys: String, CodingKey {
        case responseTokenPerS = "response_token/s"
        case promptTokenPerS = "prompt_token/s"
        case totalDuration = "total_duration"
        case loadDuration = "load_duration"
        case promptEvalCount = "prompt_eval_count"
        case promptTokens = "prompt_tokens"
        case promptEvalDuration = "prompt_eval_duration"
        case evalCount = "eval_count"
        case completionTokens = "completion_tokens"
        case evalDuration = "eval_duration"
        case approximateTotal = "approximate_total"
        case totalTokens = "total_tokens"
        case completionTokensDetails = "completion_tokens_details"
    }
}
