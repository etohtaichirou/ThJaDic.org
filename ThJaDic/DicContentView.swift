//
//  DicContentView.swift
//  ThJaDic
//
//  Created by 江藤太一郎 on 2019/02/23.
//  Copyright © 2019 Taichiro Etoh. All rights reserved.
//

import Foundation
import UIKit
import WebKit

final class DicContentViewController: UIViewController {
    
    let titleName: String
    var thTargetWord: ThaiWord?

    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        return webView
    }()

    init(titleName: String) {
        self.titleName = titleName
        self.thTargetWord = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = titleName
        
        view = webView

        let errorHtmlPath = Bundle.main.path(forResource: thTargetWord?.content, ofType: "html")!
        let htmlString = try! String(contentsOfFile: errorHtmlPath)
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension DicContentViewController: WKUIDelegate {
}
