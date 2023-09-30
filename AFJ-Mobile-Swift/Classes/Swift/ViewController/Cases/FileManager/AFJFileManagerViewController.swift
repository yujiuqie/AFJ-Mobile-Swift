//
//  AFJFileManagerViewController.swift
//  AFJ-iOS-Swift
//
//  Created by alfred on 2022/12/9.
//

import UIKit

class AFJFileManagerViewController: UITableViewController {

    let fileMgr = FileManagerHelper.manager

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func caseListData() -> [AFJCaseItem] {
        
        return [
            AFJCaseItem(title: "File List",callback: { (caseItem) in
                let basePath = Bundle.main.bundlePath
                let vc = AFJFileListViewController()
                vc.fullPath = basePath
                self.navigationController?.pushViewController(vc, animated: true)
            }),
        ]
    }

}
