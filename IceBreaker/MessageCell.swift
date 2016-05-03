//
//  MessageCell.swift
//  Chat
//
//  Created by Ryan Walsh on 5/1/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell
{
    @IBOutlet weak var imgUserLogo: UIImageView!
    @IBOutlet weak var imgBackgroundColor: UIImageView!
    @IBOutlet weak var txvwMessageText: UITextView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
