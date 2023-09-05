//
//  RandomProfileAPI.swift
//  TCA_C
//
//  Created by 김민석 on 2023/08/14.
//

import Foundation

import Moya
import CombineMoya

enum RandomProfileAPI {
    case male(Int)
    case female(Int)
}

extension RandomProfileAPI: TargetType {
    var baseURL: URL { URL(string: Constants.BASE_URL)! }
    
    var path: String {
        return "/api"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        var param: [String: Any] = [:]
        switch self {
        case .male(let page):
            param.updateValue(page, forKey: "page")
            param.updateValue(14, forKey: "results")
            param.updateValue(GenderType.male.rawValue, forKey: "gender")
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case .female(let page):
            param.updateValue(page, forKey: "page")
            param.updateValue(14, forKey: "results")
            param.updateValue(GenderType.female.rawValue, forKey: "gender")
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? { [:] }
}
