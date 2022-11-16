//
//  TableViewCell.swift
//  20221116-DuaneStrothers-NYCSchools
//
//  Created by Duane Strothers on 11/16/22.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var schoolTitleView: UIView!
    @IBOutlet weak var schoolTitleLbl: UILabel!
    
    
    //configure cell w/ data from network call
    func configure(schoolName: String?) {
        self.schoolTitleView.layer.cornerRadius = 10
        self.schoolTitleLbl.text = "School: \(schoolName ?? "???")"
    }
}
