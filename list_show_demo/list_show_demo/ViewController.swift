//
//  ViewController.swift
//  list_show_demo
//
//  debug 列表实现（二级列表、或者是跟 ios 设置页面一样的，通过 搜索框 + section 来实现）
//  第一种实现方式已经写过demo了，感觉挺简单的，最终选择第二种实现方式，可以学点数据方面的东西
//  Created by ezrealzhang on 2021/12/7.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
                      UISearchBarDelegate, CellClickHelper {
    
    private let SCREEN_WIDTH = UIScreen.main.bounds.width
    private let SCREEN_HEIGHT = UIScreen.main.bounds.height
    private let CELL_IDENTIFIER = "Cell_Identifier"
    
    private var contentTableView: UITableView!
    private var searchResultTableView: UITableView!
    private var searchBar: UISearchBar!
    private var helper: SearchResultTableViewHelper!
    
    private var sections: [String]!
    private var models: [String : Model ]!
    private var resultData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initData()
        initView()
    }

    private func initView() {
        initSearchBar()
        initContentTableView()
    }
    
    private func initSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 20,
                                              width: SCREEN_WIDTH, height: 35))
        searchBar.placeholder = "input to search"
        searchBar.delegate = self
        self.view.addSubview(searchBar)
    }
    
    private func initContentTableView() {
        contentTableView = UITableView(frame: CGRect(x: 0,
                                              y: searchBar.frame.height + 20,
                                              width: SCREEN_WIDTH,
                                              height: SCREEN_HEIGHT))
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.backgroundColor = UIColor.white
        contentTableView.register(UITableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
        self.view.addSubview(contentTableView)
    }
    
    // 模拟网络请求返回 model
    private func initData() {
        // net ...
        // hardcode
        sections = DataSource.loadSectionsFromNet()
        models = DataSource.loadModelsFromNet()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[sections[section]]?.getData().count ?? 0
    }
    
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER,
                                                 for: indexPath)
        let data = models[sections[indexPath.section]]?.getData() ?? []
        cell.textLabel?.text = data[indexPath.row]
        cell.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 30)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0,
                                                     width: SCREEN_WIDTH, height: 25))
        sectionHeaderView.backgroundColor = UIColor.gray
        let textLabel = UILabel(frame: CGRect(x: 10, y: 0, width: SCREEN_WIDTH, height: 25))
        textLabel.textAlignment = .left
//        textLabel.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        textLabel.backgroundColor = UIColor.gray
        textLabel.textColor = UIColor.black
        textLabel.text = sections[section]
        sectionHeaderView.addSubview(textLabel)
        return sectionHeaderView
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    // UISearchBar 的 代理回调
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 查询，其实不用从数据库里面查，因为我在用缓存，所以是同步的，直接查缓存就可以了
        // 设置另一个 tabelview 盖在上面，根据查询结果展示对应的cell
        
        // TODO 这段代码效率很低，需要优化，以及当 searchText 改变时，没有匹配的，那么之前匹配的 cell 就需要清除掉了
        print("searchBar : \(searchText)")
        var index = 0
        var isValued = false;
        for section in sections {
            let tmpData = models[section]?.getData() ?? []
            for cellName in tmpData {
                if searchText.caseInsensitiveCompare(cellName) == .orderedSame {
                    resultData[index] = searchText
                    index += 1
                    if (!isValued) {
                        print("isValued : \(isValued)")
                        isValued = true
                    }
                }
            }
        }
        
        if (isValued) {
            self.view.addSubview(searchResultTableView)
            contentTableView.isHidden = true
            searchResultTableView.isHidden = false;
            print("resultData : \(resultData)")
            helper.data = resultData
            // TODO 第二次收缩不生效？
            searchResultTableView.reloadData()
        }

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing called")
        // TODO resetResultData 在 click event 里也会调一次
        resetResultData()
        initResultTableView()
    }
    
    private func resetResultData() {
        let numOfModel = models[sections[0]]?.getData().count ?? 1
        resultData = [String](repeating: "",
                                  count: sections.count * numOfModel)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing called")
    }
    
    private func initResultTableView() {
        searchResultTableView = UITableView(frame: CGRect(x: 0,
                                                          y: searchBar.frame.height + 20,
                                                          width: SCREEN_WIDTH,
                                                          height: SCREEN_HEIGHT))
        helper = SearchResultTableViewHelper(resultData, self)
        searchResultTableView.delegate = helper
        searchResultTableView.dataSource = helper
        searchResultTableView.backgroundColor = UIColor.gray
        searchResultTableView.register(UITableViewCell.self,
                                       forCellReuseIdentifier: SearchResultTableViewHelper.CELL_IDENTIFIER)
    }
    
    func responseClickEvent(_ cellText: String) {
        
        // cell 点击就回到原来的 tabelView 上（当前 hide，之前的 show），并将对应的 cell 移到顶部
        // 清空 查询到的数据
        contentTableView.isHidden = false
        searchResultTableView.removeFromSuperview()
        // scroll to postion
        var sec = 0
        var row = 0
        for section in sections {
            let tmpData = models[section]?.getData() ?? []
            for text in tmpData {
                if text.caseInsensitiveCompare(cellText) == .orderedSame {
                    // 找到了，滚动到指定位置
                    let indexPath = IndexPath(row: row, section: sec)
                    contentTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                    contentTableView.cellForRow(at: indexPath)?.setHighlighted(true, animated: true)
                    break
                }
                row += 1
            }
            sec += 1
            row = 0
        }
        resultData = nil
        searchBar.text = ""
        resetResultData()
    }
    
}

