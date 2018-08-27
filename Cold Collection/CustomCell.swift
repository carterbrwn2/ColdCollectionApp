//
//  CustomCell.swift
//  Cold Collection
//
//  Created by Carter Brown on 8/3/18.
//  Copyright © 2018 Carter Brown. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CustomCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var todaysView: UIView!
    @IBOutlet weak var eventView: UIView!
}
