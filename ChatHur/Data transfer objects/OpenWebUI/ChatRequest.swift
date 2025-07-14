//
//  ChatRequest.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 13/07/2025.
//

//{
//    "chat": {
//        "models": [
//            "gemma3:1b"
//        ],
//        "history": {
//            "messages": {
//                "5c42c170-1313-4563-a140-7e4d4ef43711": {
//                    "id": "5c42c170-1313-4563-a140-7e4d4ef43711",
//                    "parentId": null,
//                    "childrenIds": [
//                        "9ef6ab65-8911-4df0-b624-59a944c0d631"
//                    ],
//                    "role": "user",
//                    "content": "hihi",
//                    "timestamp": 1752349438,
//                    "models": [
//                        "gemma3:1b"
//                    ]
//                },
//                "9ef6ab65-8911-4df0-b624-59a944c0d631": {
//                    "parentId": "5c42c170-1313-4563-a140-7e4d4ef43711",
//                    "id": "9ef6ab65-8911-4df0-b624-59a944c0d631",
//                    "childrenIds": [
//                        "328a1d10-8d6e-49ab-95b7-1188fc671567"
//                    ],
//                    "role": "assistant",
//                    "content": "Hey there! 👋 How's your day going so far? Is there anything you'd like to chat about or need help with?",
//                    "model": "gemma3:1b",
//                    "modelName": "gemma3:1b",
//                    "modelIdx": 0,
//                    "timestamp": 1752349438,
//                    "usage": {
//                        "response_token/s": 107.11,
//                        "prompt_token/s": 162.51,
//                        "total_duration": 1010081250,
//                        "load_duration": 671140916,
//                        "prompt_eval_count": 11,
//                        "prompt_tokens": 11,
//                        "prompt_eval_duration": 67686459,
//                        "eval_count": 29,
//                        "completion_tokens": 29,
//                        "eval_duration": 270757708,
//                        "approximate_total": "0h0m1s",
//                        "total_tokens": 40,
//                        "completion_tokens_details": {
//                            "reasoning_tokens": 0,
//                            "accepted_prediction_tokens": 0,
//                            "rejected_prediction_tokens": 0
//                        }
//                    },
//                    "done": true,
//                    "followUps": [
//                        "What are you working on today?",
//                        "Can you tell me a little more about what you're interested in?",
//                        "What's your goal for this conversation?"
//                    ]
//                },
//                "328a1d10-8d6e-49ab-95b7-1188fc671567": {
//                    "id": "328a1d10-8d6e-49ab-95b7-1188fc671567",
//                    "parentId": "9ef6ab65-8911-4df0-b624-59a944c0d631",
//                    "childrenIds": [
//                        "13054b3b-a987-40e6-891b-d3189c5a13f5"
//                    ],
//                    "role": "user",
//                    "content": "this is a new message",
//                    "timestamp": 1752350476,
//                    "models": [
//                        "gemma3:1b"
//                    ]
//                },
//                "13054b3b-a987-40e6-891b-d3189c5a13f5": {
//                    "parentId": "328a1d10-8d6e-49ab-95b7-1188fc671567",
//                    "id": "13054b3b-a987-40e6-891b-d3189c5a13f5",
//                    "childrenIds": [],
//                    "role": "assistant",
//                    "content": "",
//                    "model": "gemma3:1b",
//                    "modelName": "gemma3:1b",
//                    "modelIdx": 0,
//                    "timestamp": 1752350476
//                }
//            },
//            "currentId": "13054b3b-a987-40e6-891b-d3189c5a13f5"
//        },
//        "messages": [
//            {
//                "id": "5c42c170-1313-4563-a140-7e4d4ef43711",
//                "parentId": null,
//                "childrenIds": [
//                    "9ef6ab65-8911-4df0-b624-59a944c0d631"
//                ],
//                "role": "user",
//                "content": "hihi",
//                "timestamp": 1752349438,
//                "models": [
//                    "gemma3:1b"
//                ]
//            },
//            {
//                "parentId": "5c42c170-1313-4563-a140-7e4d4ef43711",
//                "id": "9ef6ab65-8911-4df0-b624-59a944c0d631",
//                "childrenIds": [
//                    "328a1d10-8d6e-49ab-95b7-1188fc671567"
//                ],
//                "role": "assistant",
//                "content": "Hey there! 👋 How's your day going so far? Is there anything you'd like to chat about or need help with?",
//                "model": "gemma3:1b",
//                "modelName": "gemma3:1b",
//                "modelIdx": 0,
//                "timestamp": 1752349438,
//                "usage": {
//                    "response_token/s": 107.11,
//                    "prompt_token/s": 162.51,
//                    "total_duration": 1010081250,
//                    "load_duration": 671140916,
//                    "prompt_eval_count": 11,
//                    "prompt_tokens": 11,
//                    "prompt_eval_duration": 67686459,
//                    "eval_count": 29,
//                    "completion_tokens": 29,
//                    "eval_duration": 270757708,
//                    "approximate_total": "0h0m1s",
//                    "total_tokens": 40,
//                    "completion_tokens_details": {
//                        "reasoning_tokens": 0,
//                        "accepted_prediction_tokens": 0,
//                        "rejected_prediction_tokens": 0
//                    }
//                },
//                "done": true,
//                "followUps": [
//                    "What are you working on today?",
//                    "Can you tell me a little more about what you're interested in?",
//                    "What's your goal for this conversation?"
//                ]
//            },
//            {
//                "id": "328a1d10-8d6e-49ab-95b7-1188fc671567",
//                "parentId": "9ef6ab65-8911-4df0-b624-59a944c0d631",
//                "childrenIds": [
//                    "13054b3b-a987-40e6-891b-d3189c5a13f5"
//                ],
//                "role": "user",
//                "content": "this is a new message",
//                "timestamp": 1752350476,
//                "models": [
//                    "gemma3:1b"
//                ]
//            },
//            {
//                "parentId": "328a1d10-8d6e-49ab-95b7-1188fc671567",
//                "id": "13054b3b-a987-40e6-891b-d3189c5a13f5",
//                "childrenIds": [],
//                "role": "assistant",
//                "content": "",
//                "model": "gemma3:1b",
//                "modelName": "gemma3:1b",
//                "modelIdx": 0,
//                "timestamp": 1752350476
//            }
//        ],
//        "params": {},
//        "files": []
//    }
//}

import Foundation

    // MARK: - Main Request Model
struct ChatRequest: Codable {
    let chat: ChatRequestData
    
    init(messages: [ChatmessageModel], models: [String] ) {
        self.chat = ChatRequestData(messages: messages, models: models)
    }
}

    // MARK: - Chat Request Data
struct ChatRequestData: Codable {
    let models: [String]
    let history: History
    let messages: [ChatmessageModel]
    let params: EmptyObject
    let files: [String]
    
    init(messages: [ChatmessageModel], models: [String]) {
        self.models = models
        self.messages = messages.sorted(by: { a, b in
            a.timestamp < b.timestamp
        })
        self.params = EmptyObject()  // Empty params
        self.files = []   // Empty files
        
            // Build history from messages
        var historyMessages: [String: ChatmessageModel] = [:]
        var currentId = ""
        
            // Convert messages array to history dictionary
        for message in messages {
            historyMessages[message.id] = message
            currentId = message.id  // Last message ID becomes current
        }
        
        self.history = History(
            messages: historyMessages,
            currentId: currentId
        )
    }
}
