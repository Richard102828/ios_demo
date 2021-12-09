//
//  DataSource.swift
//  list_show_demo
//
//  Created by ezrealzhang on 2021/12/7.
//

import Foundation
import UIKit

// 数据源
class DataSource {
    
    private static var sections: [String]!
    private static var models: [String : Model]!
    
    // net
    static func loadSectionsFromNet() -> [String] {
        // net ...
        // hardcode
        sections = ["fruit", "color rgb", "number", "phone", "os"]
        return sections
    }
    
    static func loadModelsFromNet() -> [String : Model] {
        // net ...
        // hardcode
        let model1 = DebugModel(data: ["apple", "banana", "watermelon", "mango"])
        let model2 = DebugModel(data: ["red", "green", "blue"])
        let model3 = DebugModel(data: ["one", "two", "three"])
        let model4 = DebugModel(data: ["about"])
        let model5 = DebugModel(data: ["android", "ios", "linux", "windowx", "mac os"])
        models = [
            sections[0]: model1,
            sections[1]: model2,
            sections[2]: model3,
            sections[3]: model4,
            sections[4]: model5,
        ]
        return models
    }
    
    // 数据库
    func query() {
        
    }
    
}
