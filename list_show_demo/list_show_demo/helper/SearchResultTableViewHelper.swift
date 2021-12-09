//
//  SearchResultTableViewHelper.swift
//  list_show_demo
//
//  Created by ezrealzhang on 2021/12/7.
//

import Foundation
import UIKit

class SearchResultTableViewHelper: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    
    static let CELL_IDENTIFIER = "Cell_Identifier_Result"
    private let SCREEN_WIDTH = UIScreen.main.bounds.width
    private let SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    var data: [String]!
    private var helper: CellClickHelper!
    
    init(_ data: [String], _ helper: CellClickHelper) {
        self.data = data
        self.helper = helper
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewHelper.CELL_IDENTIFIER,
                                                 for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.frame = CGRect(x: 10, y: 0, width: SCREEN_WIDTH, height: 25)
        cell.textLabel?.textAlignment = .left
        print("data : \(data)")
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("click event response")
        helper.responseClickEvent(data[indexPath.row])
    }
    
}
