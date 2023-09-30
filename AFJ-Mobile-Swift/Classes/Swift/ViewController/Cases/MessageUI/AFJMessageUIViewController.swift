//
//  AFJMessageUIViewController.swift
//  AFJ-iOS-Swift
//
//  Created by alfred on 2022/11/19.
//

import UIKit
import MessageUI

class AFJMessageUIViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    lazy var conversation = ConversationManager(presentingController: self, mailDelegate: nil, messageDelegate: nil, viewController: self)
    
    func caseListData() -> [AFJCaseItem] {
        return [AFJCaseItem(title: "Send Email",callback: {[weak self] (caseItem) in
            self?.conversation.sendEmail(feedback: MailFeedback(recipients: ["abcd@google.com"], subject: "FeedBack", body: "Write feedback here"))
        }),
                AFJCaseItem(title: "Send Message",callback: {[weak self] (caseItem) in
            self?.conversation.sendMessage(feedback: MessageFeedBack(recipients: ["1111111111"], body: "Type here"))
        }),
                AFJCaseItem(title: "Start Call",callback: {[weak self] (caseItem) in
            self?.conversation.makeCall(number: "1111111111")
        })]
    }
}
