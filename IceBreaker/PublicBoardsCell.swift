//
//  ChatroomCell.swift
//  Chat
//
//  Created by Ryan Walsh on 4/30/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit

class PublicBoardsCell : UITableViewCell
{
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var chatroomLabel: UILabel!
    
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

