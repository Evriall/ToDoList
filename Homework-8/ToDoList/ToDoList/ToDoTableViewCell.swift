//
//  ToDoTableViewCell.swift
//  ToDoList
//
//  Created by Sergey Guznin on 09.12.16.
//  Copyright © 2016 Sergey Guznin. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
// MARK: - Outlet
  

  @IBOutlet weak var checkImgae: UIImageView!
  
  @IBOutlet weak var name: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
