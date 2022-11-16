//
//  ViewModel.swift
//  20221116-DuaneStrothers-NYCSchools
//
//  Created by Duane Strothers on 11/16/22.
//


import Foundation

protocol SchoolListViewModelType {
    // setting protocols neccessary for view updates and data fetching
    func bind(updateHandler: @escaping () -> Void)
    func unbind()
    func getSchools()
    func getSchoolSATInfo(index: Int)
    var count: Int { get }
    func getSchoolName(index: Int) -> String?
    func getSchoolID(index: Int) -> String?
    func getSATReading(index: Int) -> String?
    func getSATMath(index: Int) -> String?
    func getSATWriting(index: Int) -> String?
}

class SchoolListViewModel: SchoolListViewModelType {
    
    var schools: [SchoolInformation] {
        didSet {
            self.updateHandler?()
        }
    }
    
    let dataFetcher: DataFetcher
    
    var updateHandler: (() -> Void)?
    
    init(schools: [SchoolInformation] = [], dataFetcher: DataFetcher = NetworkManager()) {
        self.schools = schools
        self.dataFetcher = dataFetcher
    }
    
    func bind(updateHandler: @escaping () -> Void) {
        self.updateHandler = updateHandler
    }
    
    func unbind() {
        self.updateHandler = nil
    }
    
    func getSchools() {
        self.dataFetcher.fetchModel(url: URL(string: NetworkConstants.schoolList)) { [weak self] (result: Result<[SchoolInformation], Error>) in
            switch result {
            case .success(let page):
                self?.schools.append(contentsOf: page)
                print(page)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getSchoolSATInfo(index: Int) {
        guard index < self.count else { return }
        
        self.dataFetcher.fetchModel(url: URL(string: NetworkConstants.satInfo + self.schools[index].dbn)) { [weak self] (result: Result<[SchoolSATInformation], Error>) in
            switch result {
            case .success(let SATs):
                self?.schools[index].satInfo = SATs.first
            case .failure(let error):
                print(error)
            }
        }
    }
    
    var count: Int {
        return self.schools.count
    }
    
    func getSchoolName(index: Int) -> String?{
        guard index < self.count else { return nil }
        return self.schools[index].schoolName
    }
    
    func getSchoolID(index: Int) -> String?{
        guard index < self.count else { return nil }
        return self.schools[index].dbn
    }
    
    func getSATMath(index: Int) -> String?{
        guard index < self.count else { return nil }
        return self.schools[index].satInfo?.satMathAvgScore
    }
    
    func getSATReading(index: Int) -> String?{
        guard index < self.count else { return nil }
        return self.schools[index].satInfo?.satCriticalReadingAvgScore
    }
    
    func getSATWriting(index: Int) -> String?{
        guard index < self.count else { return nil }
        return self.schools[index].satInfo?.satWritingAvgScore
    }
}
