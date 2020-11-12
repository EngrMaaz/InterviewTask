//
//  DataModel.swift
//  InterviewTask
//
//  Created by HAPPY on 12/11/2020.
//

import Foundation

struct DataModel: Codable {
    
    var lat: Double?
    var lon: Double?
    var state: String?
    var city: String?
    
    static func toModel(_ json: [String: Any]?) -> DataModel? {
        guard let json = json else { return nil }
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) else { return nil }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let model = try? decoder.decode(DataModel.self, from: data) else { return nil }
        return model
    }
    
    static func toModels(_ json: [[String: Any]]?) -> [DataModel]? {
        guard let json = json else { return nil }
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) else { return nil }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let model = try? decoder.decode([DataModel].self, from: data) else { return nil }
        return model
    }
}



