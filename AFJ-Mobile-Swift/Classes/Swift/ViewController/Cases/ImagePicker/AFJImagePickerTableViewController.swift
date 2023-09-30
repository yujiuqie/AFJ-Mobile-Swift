//
//  AFJImagePickerTableViewController.swift
//  AFJ-iOS-Swift
//
//  Created by alfred on 2022/11/22.
//

import UIKit

class AFJImagePickerTableViewController: UITableViewController {
    
    lazy var imagePicker = ImagePicker(presentationController: self, delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func caseListData() -> [AFJCaseItem] {
        return [
            AFJCaseItem(title: "Image Picker",callback: { (caseItem) in
                self.imagePicker.present(from: self.view)
            }),
        ]
    }
}


extension AFJImagePickerTableViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.navigationController?.view.makeToast(nil, duration: 2.0, position: .center, title: nil, image: image)
        self.dismiss(animated: true, completion: nil)
    }
}
