//
//  EmptyObject.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 14/07/2025.
//

    //    // MARK: - Empty Object for params
struct EmptyObject: Codable {
    init(){
        
    }
    init(from decoder: Decoder) throws {
        _ = try decoder.container(keyedBy: CodingKeys.self)
    }
    
    func encode(to encoder: Encoder) throws {
        _ = encoder.container(keyedBy: CodingKeys.self)
    }
    
    private enum CodingKeys: CodingKey {}
}
