//
//  AFJFileListViewController.swift
//  AFJ-iOS-Swift
//
//  Created by alfred on 2022/12/9.
//

import UIKit

class AFJFileListViewController: UITableViewController {

    var fullPath = ""
    var dataList: [AFJFileModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func caseListData() -> [AFJCaseItem] {
        
        dataList = FileManagerHelper.manager.getSubWithPath(fullPath)
        
        var fileList: [AFJCaseItem] = []
        
        for (_,model) in dataList.enumerated(){
            
            let text = (model.path as NSString).lastPathComponent
            let file = AFJCaseItem(title: (model.isDirectory ? "📁" : "") + text) { item in
                if model.isDirectory {
                    let vc = AFJFileListViewController()
                    vc.navigationItem.title = (model.path as NSString).lastPathComponent
                    vc.fullPath = model.path
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.showFileInfo(model.path)
                }
            }
            fileList.append(file)
        }
        
        return fileList
    }
    
    func showFileInfo(_ filePath: String){
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
            let fileSize:NSNumber = fileAttributes[FileAttributeKey.size] as! NSNumber? ?? 0
            let creationDate = fileAttributes[FileAttributeKey.creationDate]
            let modificationDate = fileAttributes[FileAttributeKey.modificationDate]
            
            self.navigationController?.view.makeToast("File Size: \(fileSize.uint32Value)\nFile Creation Date: \(String(describing: creationDate))\nFile Modification Date: \(String(describing: modificationDate))")
        } catch let error as NSError {
            self.navigationController?.view.makeToast("Get attributes errer: \(error)")
        }
    }
}
