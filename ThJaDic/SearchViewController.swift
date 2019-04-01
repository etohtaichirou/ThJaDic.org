//
//  FirstViewController.swift
//  ThJaDic
//
//  Created by 江藤太一郎 on 2019/02/09.
//  Copyright © 2019 Taichiro Etoh. All rights reserved.
//

import UIKit
import WebKit

class SearchViewController: UIViewController {

    var appDelegate: AppDelegate!
    var dataController: DataController!
    
    var searchResultsWords: [ThaiWord] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:42)
        searchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: 89)
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.showsSearchResultsButton = false
        searchBar.placeholder = "検索"
        //searchBar.setValue("キャンセル", forKey: "_cancelButtonText")
        searchBar.tintColor = UIColor.red
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        //AppDelegateのインスタンスを取得
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        dataController = appDelegate.dataController

        navigationItem.title = "検索"

        // セルをテーブルに紐付ける
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // データのないセルを表示しないようにするハック
        tableView.tableFooterView = UIView(frame: .zero)

        view = tableView
        
        tableView.tableHeaderView = searchBar
    }

    //遷移先Viewから戻る処理
    @objc func returnView(){
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// データ・ソース
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsWords.count
    }

    // セル生成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // セルに表示する値を設定する
        cell.textLabel!.text = searchResultsWords[indexPath.row].spell

        return cell
    }

}

// セルタップ時の動作定義など
extension SearchViewController: UITableViewDelegate {

    // 単語選択時の動作
    // 辞書コンテンツページに遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWord = searchResultsWords[indexPath.item]
        let contentPage = DicContentViewController(titleName: selectedWord.spell!)
        contentPage.thTargetWord = selectedWord
        
        //画面遷移
        navigationController?.pushViewController(contentPage, animated: true)
        //self.present(contentPage, animated: true, completion: nil)
    }
    
    // 遷移先のViewControllerにデータを渡す関数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == "Segue" {
        //    let vc = segue.destination as! ViewController
        //    vc.receiveData = giveData
        //}
    }

}

extension SearchViewController: UISearchBarDelegate {

    // フォーカスが当たる際に呼び出されるメソッド(編集の可否を定義可能).
    //private func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    //    print(#function)
    //    return true
    //}

    // original: テキストフィールド入力開始前に呼ばれる
    //func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    //    //searchBar.showsCancelButton = true
    //    return true
    //}

    // フォーカスがあたった際に呼び出されるメソッド.
    //func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    //    print(#function)
    //    searchBar.setShowsCancelButton(true, animated: true)
    //}

    // フォーカスが外れる際に呼び出されるメソッド(編集終了の可否を定義可能).
    //func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
    //    print(#function)
    //    return true
    //}
    
    // フォーカスが外れた際に呼び出されるメソッド.
    //func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    //    print(#function)
    //}
    
    // 入力に変更があった際に呼び出されるメソッド.
    // called when text changes (including clear)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResultsWords = dataController.fetchThaiWord(searchText: searchText)
        self.tableView.reloadData()
        //print(#function)
    }
    
    // 入力に変更があった際に呼び出されるメソッド.
    //func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    //    print(#function)
    //    return true
    //}
    
    // 検索キータップ時に呼び出されるメソッド.
    //func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //    print(#function)
    //    searchBar.resignFirstResponder()
    //    searchBar.setShowsCancelButton(false, animated: true)
    //}

    // original: 検索ボタンが押された時に呼ばれる
    //func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //    self.view.endEditing(true)
    //    searchResultsWords = dataController.fetchThaiWord()
        //searchBar.showsCancelButton = true
        //self.searchResults = DATA.filter{
        //    // 大文字と小文字を区別せずに検索
        //    $0.lowercased().contains(searchBar.text!.lowercased())
        //}
    //    self.tableView.reloadData()
    //}

    // called when bookmark button pressed.
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
    }
    
    // キャンセルボタンタップ時に呼び出されるメソッド.
    //func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //    print(#function)
    //    searchBar.resignFirstResponder()
    //    searchBar.setShowsCancelButton(false, animated: true)
    //}

    // original: キャンセルボタンが押された時に呼ばれる
    //func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //    searchBar.showsCancelButton = false
    //    self.view.endEditing(true)
    //    searchBar.text = ""
    //    self.tableView.reloadData()
    //}

    // called when search results button pressed
    //func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
    //    print(#function)
    //}
    
    //func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    //    print(#function)
    //}

}

extension SearchViewController: WKUIDelegate {
}
