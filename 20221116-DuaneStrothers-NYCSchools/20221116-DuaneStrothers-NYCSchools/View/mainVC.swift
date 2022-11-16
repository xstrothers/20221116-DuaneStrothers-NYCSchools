//
//  ViewController.swift
//  20221116-DuaneStrothers-NYCSchools
//
//  Created by Duane Strothers on 11/16/22.
//

import UIKit

class mainVC: UIViewController {
    // decided storyboard would be simplest based on limiting views
    
    @IBOutlet weak var mainTableView: UITableView!
    // initilizing VM
    let schoolListViewModel: SchoolListViewModelType? = SchoolListViewModel()
    
    
    override func viewDidLoad() {
        self.title = "NYC Schools"
        super.viewDidLoad()
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.backgroundColor = .black
        mainTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        mainTableView.estimatedRowHeight = 65
        mainTableView.rowHeight = UITableView.automaticDimension
        mainTableView.separatorColor = UIColor.clear
        self.schoolListViewModel?.getSchools()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.schoolListViewModel?.bind { [weak self] in
            DispatchQueue.main.async {
                self?.mainTableView.reloadData()
            }
        }
        
        if self.schoolListViewModel?.count == 0 {
            self.schoolListViewModel?.getSchools()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.schoolListViewModel?.unbind()
    }
    
}

extension mainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let schoolDetailVC = SchoolPropertiesVC.loadController()
        schoolDetailVC.setData(vm: self.schoolListViewModel, index: indexPath.row)
        self.present(schoolDetailVC, animated: true)
        //let schoolProperties = SchoolPropertiesVC(vm: self.schoolListViewModel, index: indexPath.row)

        //self.navigationController?.pushViewController(schoolProperties, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(schoolListViewModel!.count)
        return self.schoolListViewModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.configure(schoolName: self.schoolListViewModel?.getSchoolName(index: indexPath.row))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension UIViewController {

    class func loadController() -> Self {
         return Self(nibName: String(describing: self), bundle: nil)
         //Or You can use this as well
         //Self.init(nibName: String(describing: self), bundle: nil)
    }
}

