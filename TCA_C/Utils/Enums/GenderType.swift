//
//  GenderType.swift
//  TCA_C
//
//  Created by 김민석 on 2023/08/14.
//

import Foundation

enum GenderType: String {
    case male
    case female
    
    var title: String {
        switch self {
        case .male: return "남자"
        case .female: return "여자"
        }
    }
}
