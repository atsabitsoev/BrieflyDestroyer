//
//  ViewController.swift
//  BrieflyDestroyer
//
//  Created by Ацамаз Бицоев on 24.01.2020.
//  Copyright © 2020 Ацамаз Бицоев. All rights reserved.
//

import UIKit
import SwiftSoup
import JavaScriptCore
import WebKit


class ViewController: UIViewController, WKUIDelegate {

    
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        
        webView.addJavascriptInterface(JSInterface(), forKey: "Native")
        webView.load(URLRequest(url: URL(string: "https://briefly.ru/")!))
    }
    
    
    private func sendDestroyingRequest(_ searchText: String?) {
        
        guard let searchText = searchText else { return }
        
        let urlString = "https://briefly.ru/search/?q=\(searchText)"
        guard let url = URL(string: urlString) else { return }
        
        let urlTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { return }
            
            let htmlString = String(data: data!, encoding: String.Encoding.utf8)
            
            print(htmlString ?? "Не удалось получить html страницу")
        }
        
        urlTask.resume()
        
    }

    
    @IBAction func tfDestroyTextChanged(_ sender: UITextField) {
        
        //sendDestroyingRequest(sender.text)
        
        
        
        webView.callJSMethod(name: "document.getElementById('h-search-q').value = ", agruments: "Кап") { (str, error) in
            print(error ?? str ?? "хз")
            self.webView.callJSMethod(name: "document.getElementById('h-search-q').focus") { (str, error) in
                print(error ?? str ?? "fhelwkfjskle")
                self.webView.callJSMethod(name: "updateQuery") { (str, error) in
                    print(error ?? str ?? "whaaat")
                    self.webView.callJSMethod(name: "showSuggests") { (str, error) in
                        print(error ?? str ?? "whaaatsdfdsfsdffds")
                        self.webView.callJSMethod(name: "updateSuggestsDB") { (str, error) in
                            print(error ?? str ?? "ouuu")
                            
                            self.webView.evaluateJavaScript("document.getElementById('h-search').innerHTML") { (html, error) in
                                print(html ?? error ?? "ничего не понятно")
                                let htmlString = "\(html ?? "")"
                                
                                let doc: Document = try! SwiftSoup.parse(htmlString)
                                let firstSuggestion = try! doc.select("li")
                                
                                for element in firstSuggestion.array() {
                                    guard try! element.attr("class") == "w" else { continue }
                                    
                                    let author = try! element.select("span").text()
                                    let bookName = try! element.text().dropLast(try! author.count)
                                    print(bookName)
                                    print(author)
                                }
                                
                            }
                            
                        }
                    }
                }
            }
            
            
            self.webView.evaluateJavaScript("hSearchQ.value") { (data, error) in
                print(error ?? data ?? "че")
            }
        }
        
        
    }
    
    
}

