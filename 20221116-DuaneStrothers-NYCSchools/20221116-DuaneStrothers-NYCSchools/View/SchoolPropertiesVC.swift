//
//  SchoolPropertiesVC.swift
//  20221116-DuaneStrothers-NYCSchools
//
//  Created by Duane Strothers on 11/16/22.
//


import UIKit

//Simple scrollview and labels.

class SchoolPropertiesVC: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var schoolTitleLbl: UILabel!
    
    @IBOutlet weak var mathSATScoreLbl: UILabel!
    @IBOutlet weak var readingSATScoreLbl: UILabel!
    @IBOutlet weak var writingSATScoreLbl: UILabel!
    
    var schoolViewModel: SchoolListViewModelType?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popUpView.layer.cornerRadius = 12
        self.popUpView.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //updating the view on main queue
        self.schoolViewModel?.bind { [weak self] in
            DispatchQueue.main.async {
                self?.update()
            }
        }

        self.schoolViewModel?.getSchoolSATInfo(index: self.index ?? 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.schoolViewModel?.unbind()
    }
    
    func setData(vm: SchoolListViewModelType?, index: Int) {
        self.schoolViewModel = vm
        self.index = index
    }
    
    func update() {
        self.schoolTitleLbl.text = self.schoolViewModel?.getSchoolName(index: self.index ?? 0) ?? ""
        self.mathSATScoreLbl.text = self.schoolViewModel?.getSATMath(index: self.index ?? 0) ?? ""
        self.readingSATScoreLbl.text = (self.schoolViewModel?.getSATReading(index: self.index ?? 0) ?? "")
        self.writingSATScoreLbl.text = (self.schoolViewModel?.getSATWriting(index: self.index ?? 0) ?? "")
        
    }
    
    
    @IBAction func DismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
