//
//  CometChatCreatePollQuestions.swift
//  CometChatSwift
//
//  Created by Pushpsen Airekar on 16/09/20.
//  Copyright © 2020 MacMini-03. All rights reserved.
//

import UIKit

class CometChatCreatePollQuestions: UITableViewCell {
    @IBOutlet weak var question: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = CometChatTheme.palatte.background
        question.font = CometChatTheme.typography.text1
        question.textColor = CometChatTheme.palatte.accent
        question.attributedPlaceholder =  NSAttributedString(
            string: "Question",
            attributes: [NSAttributedString.Key.foregroundColor: CometChatTheme.palatte.accent500]
        )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
