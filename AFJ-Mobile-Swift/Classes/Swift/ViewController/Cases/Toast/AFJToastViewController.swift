//
//  AFJToastViewController.swift
//  AFJ-iOS-Swift
//
//  Created by alfred on 2022/11/21.
//

import UIKit
import Toast_Swift

class AFJToastViewController: UITableViewController {
    
    fileprivate var showingActivity = false
    
    fileprivate struct ReuseIdentifiers {
        static let switchCellId = "switchCell"
        static let exampleCellId = "exampleCell"
    }
    
    // MARK: - Constructors
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        self.title = "Toast-Swift"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not used")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReuseIdentifiers.exampleCellId)
    }
    
    // MARK: - Events
    
    @objc
    private func handleTapToDismissToggled() {
        ToastManager.shared.isTapToDismissEnabled = !ToastManager.shared.isTapToDismissEnabled
    }
    
    @objc
    private func handleQueueToggled() {
        ToastManager.shared.isQueueEnabled = !ToastManager.shared.isQueueEnabled
    }
}

// MARK: - UITableViewDelegate & DataSource Methods

extension AFJToastViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 11
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "SETTINGS"
        } else {
            return "EXAMPLES"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.switchCellId)
            
            if indexPath.row == 0 {
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: ReuseIdentifiers.switchCellId)
                    let tapToDismissSwitch = UISwitch()
                    tapToDismissSwitch.onTintColor = UIColor(red: 62.0 / 255.0, green: 128.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0)
                    tapToDismissSwitch.isOn = ToastManager.shared.isTapToDismissEnabled
                    tapToDismissSwitch.addTarget(self, action: #selector(AFJToastViewController.handleTapToDismissToggled), for: .valueChanged)
                    cell?.accessoryView = tapToDismissSwitch
                    cell?.selectionStyle = .none
                    cell?.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
                }
                cell?.textLabel?.text = "Tap to dismiss"
            } else {
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: ReuseIdentifiers.switchCellId)
                    let queueSwitch = UISwitch()
                    queueSwitch.onTintColor = UIColor(red: 62.0 / 255.0, green: 128.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0)
                    queueSwitch.isOn = ToastManager.shared.isQueueEnabled
                    queueSwitch.addTarget(self, action: #selector(AFJToastViewController.handleQueueToggled), for: .valueChanged)
                    cell?.accessoryView = queueSwitch
                    cell?.selectionStyle = .none
                    cell?.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
                }
                cell?.textLabel?.text = "Queue toast"
            }
            
            return cell!
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.exampleCellId, for: indexPath)
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
            cell.accessoryType = .disclosureIndicator
            
            switch indexPath.row {
            case 0: cell.textLabel?.text = "Make toast"
            case 1: cell.textLabel?.text = "Make toast on top for 3 seconds"
            case 2: cell.textLabel?.text = "Make toast with a title"
            case 3: cell.textLabel?.text = "Make toast with an image"
            case 4: cell.textLabel?.text = "Make toast with a title, image, and completion closure"
            case 5: cell.textLabel?.text = "Make toast with a custom style"
            case 6: cell.textLabel?.text = "Show a custom view as toast"
            case 7: cell.textLabel?.text = "Show an image as toast at point\n(110, 110)"
            case 8: cell.textLabel?.text = showingActivity ? "Hide toast activity" : "Show toast activity"
            case 9: cell.textLabel?.text = "Hide toast"
            case 10: cell.textLabel?.text = "Hide all toasts"
            default: cell.textLabel?.text = nil
            }
            
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section > 0 else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            // Make Toast
             self.navigationController?.view.makeToast("This is a piece of toast")
        case 1:
            // Make toast with a duration and position
            self.navigationController?.view.makeToast("This is a piece of toast on top for 3 seconds", duration: 3.0, position: .top)
        case 2:
            // Make toast with a title
            self.navigationController?.view.makeToast("This is a piece of toast with a title", duration: 2.0, position: .top, title: "Toast Title", image: nil)
        case 3:
            // Make toast with an image
            self.navigationController?.view.makeToast("This is a piece of toast with an image", duration: 2.0, position: .center, title: nil, image: UIImage(named: "toast.png"))
        case 4:
            // Make toast with an image, title, and completion closure
            self.navigationController?.view.makeToast("This is a piece of toast with a title, image, and completion closure", duration: 2.0, position: .bottom, title: "Toast Title", image: UIImage(named: "toast.png")) { didTap in
                if didTap {
                    print("completion from tap")
                } else {
                    print("completion without tap")
                }
            }
        case 5:
            // Make toast with a custom style
            var style = ToastStyle()
            style.messageFont = UIFont(name: "Zapfino", size: 14.0)!
            style.messageColor = UIColor.red
            style.messageAlignment = .center
            style.backgroundColor = UIColor.yellow
            self.navigationController?.view.makeToast("This is a piece of toast with a custom style", duration: 3.0, position: .bottom, style: style)
        case 6:
            // Show a custom view as toast
            let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 400.0))
            customView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
            customView.backgroundColor = UIColor(red: 76.0 / 255.0, green: 152.0 / 255.0, blue: 213.0 / 255.0, alpha: 1.0)
            self.navigationController?.view.showToast(customView, duration: 2.0, position: .center)
        case 7:
            // Show an image view as toast, on center at point (110,110)
            let toastView = UIImageView(image: UIImage(named: "toast.png"))
            self.navigationController?.view.showToast(toastView, duration: 2.0, point: CGPoint(x: 110.0, y: 110.0))
        case 8:
            // Make toast activity
            if !showingActivity {
                self.navigationController?.view.makeToastActivity(.center)
            } else {
                self.navigationController?.view.hideToastActivity()
            }
            
            showingActivity.toggle()
            
            tableView.reloadData()
        case 9:
            // Hide toast
            self.navigationController?.view.hideToast()
        case 10:
            // Hide all toasts
            self.navigationController?.view.hideAllToasts()
        default:
            break
        }
    }
}
