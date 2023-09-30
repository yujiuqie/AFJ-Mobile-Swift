//
//  AFJNetworkLayerViewController.swift
//  AFJ-iOS-Swift
//
//  Created by alfred on 2022/11/19.
//

import UIKit
import Alamofire

class AFJNetworkLayerViewController: UITableViewController {
    
    private var reachability: NetworkReachabilityManager!
    
    var request: Request? {
        didSet {
            oldValue?.cancel()
            
            title = request?.description
            request?.onURLRequestCreation { [weak self] _ in
                self?.title = self?.request?.description
            }
            
            headers.removeAll()
            body = nil
            elapsedTime = nil
        }
    }
    
    var headers: [String: String] = [:]
    var body: String?
    var elapsedTime: TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reachability = NetworkReachabilityManager.default
        monitorReachability()
    }
    
    func caseListData() -> [AFJCaseItem] {
        return [
            AFJCaseItem(title: "GET Request",callback: { (caseItem) in
                print("子类回调示例：你选中了【\(caseItem.title)】")
                self.request = AF.request("https://httpbin.org/get")
                self.refresh()
            }),
            AFJCaseItem(title: "POST Request",callback: { (caseItem) in
                print("子类回调示例：你选中了【\(caseItem.title)】")
                self.request = AF.request("https://httpbin.org/post", method: .post)
                self.refresh()
            }),
            AFJCaseItem(title: "PUT Request",callback: { (caseItem) in
                print("子类回调示例：你选中了【\(caseItem.title)】")
                self.request = AF.request("https://httpbin.org/put", method: .put)
                self.refresh()
            }),
            AFJCaseItem(title: "DELETE Request",callback: { (caseItem) in
                print("子类回调示例：你选中了【\(caseItem.title)】")
                self.request = AF.request("https://httpbin.org/delete", method: .delete)
                self.refresh()
            }),
            
            AFJCaseItem(title: "DOWNLOAD Request",callback: { (caseItem) in
                print("子类回调示例：你选中了【\(caseItem.title)】")
                let destination = DownloadRequest.suggestedDownloadDestination(for: .cachesDirectory,
                                                                               in: .userDomainMask)
                self.request = AF.download("https://httpbin.org/stream/1", to: destination)
                self.refresh()
            }),
            
            AFJCaseItem(title: "Reachability Status",callback: { (caseItem) in
                self.navigationController?.view.makeToast("Reachability Status: \(self.reachability.status)")
            }),
        ]
    }
    
    func refresh() {
        guard let request = request else {
            return
        }
        
        self.navigationController?.view.makeToastActivity(.center)
        
        let start = CACurrentMediaTime()
        
        if let request = request as? DataRequest {
            request.responseString { response in
                self.requestComplete(start, response.response, response.result)
            }
        } else if let request = request as? DownloadRequest {
            request.responseString { response in
                self.downloadComplete(start, response.response, response.result)
            }
        }
    }
    
    private func requestComplete(_ start : CFTimeInterval,_ response : HTTPURLResponse?,_  result : Result<String, AFError>){
        let end = CACurrentMediaTime()
        self.elapsedTime = end - start
        
        if let response = response {
            for (field, value) in response.allHeaderFields {
                self.headers["\(field)"] = "\(value)"
            }
        }
        
        if case let .success(value) = result { self.body = value }
        
        self.navigationController?.view.hideToastActivity()
        self.navigationController?.view.makeToast("Headers \(self.headers)\nBody \(String(describing: self.body))")
    }
    
    private func downloadComplete(_ start : CFTimeInterval,_ response : HTTPURLResponse?,_  result : Result<String, AFError>){
        let end = CACurrentMediaTime()
        self.elapsedTime = end - start
        
        if let response = response {
            for (field, value) in response.allHeaderFields {
                self.headers["\(field)"] = "\(value)"
            }
        }
        
        self.body = self.downloadedBodyString()
        
        self.navigationController?.view.hideToastActivity()
        self.navigationController?.view.makeToast("Headers \(self.headers)\nBody \(String(describing: self.body))")
    }
    
    private func downloadedBodyString() -> String {
        let fileManager = FileManager.default
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        
        do {
            let contents = try fileManager.contentsOfDirectory(at: cachesDirectory,
                                                               includingPropertiesForKeys: nil,
                                                               options: .skipsHiddenFiles)
            
            if let fileURL = contents.first, let data = try? Data(contentsOf: fileURL) {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                let prettyData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                
                if let prettyString = String(data: prettyData, encoding: String.Encoding.utf8) {
                    try fileManager.removeItem(at: fileURL)
                    return prettyString
                }
            }
        } catch {
            // No-op
        }
        
        return ""
    }
    
    // MARK: - Private - Reachability
    
    private func monitorReachability() {
        reachability.startListening { status in
            print("Reachability Status Changed: \(status)")
        }
    }
}
