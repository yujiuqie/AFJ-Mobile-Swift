//
//  AFJSnapKitViewController.swift
//  AFJ-iOS-Swift
//
//  Created by alfred on 2022/12/13.
//

import UIKit
import SnapKit

class AFJSnapKitViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func caseListData() -> [AFJCaseItem] {
        
        return [
            AFJCaseItem(title: "Simple Layout",callback: { (caseItem) in
                let viewController = SimpleLayoutViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }),
            AFJCaseItem(title: "Basic UIScrollView",callback: { (caseItem) in
                let viewController = BasicUIScrollViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            })
        ]
    }

}
