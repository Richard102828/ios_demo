//
//  DebugModel.swift
//  list_show_demo
//
//  Created by ezrealzhang on 2021/12/7.
//

import Foundation

class DebugModel : Model {
    
    var data: [ String ]!
    
    init(data: [ String ]) {
        self.data = data
    }
    
    func getData() -> [ String ] {
        return data
    }
    
}
