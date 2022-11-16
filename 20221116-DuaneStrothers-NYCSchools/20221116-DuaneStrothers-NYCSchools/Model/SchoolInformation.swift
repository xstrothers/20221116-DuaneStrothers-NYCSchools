//
//  Model.swift
//  20221116-DuaneStrothers-NYCSchools
//
//  Created by Duane Strothers on 11/16/22.
//

import Foundation

struct SchoolInformation: Decodable {
    let dbn: String
    let schoolName: String
    var satInfo: SchoolSATInformation?

    enum CodingKeys: String, CodingKey {
        case dbn, satInfo
        case schoolName = "school_name"
    }
}

