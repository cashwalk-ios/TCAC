//
//  RandomProfileResponse.swift
//  TCA_C
//
//  Created by 김민석 on 2023/08/14.
//

import Foundation

struct RandomProfileResponse: Decodable {
    let results: [RandomProfileInfo]
}

struct RandomProfileInfo: Decodable {
    let name: RandomProfileName
    let location: RandomProfileLocation
    let email: String
    let picture: RandomProfilePicture
}

struct RandomProfileName: Decodable, Hashable {
    let title: String
    let first: String
    let last: String
}

struct RandomProfileLocation: Decodable, Hashable {
    let country: String
}

struct RandomProfilePicture: Decodable, Hashable {
    let large: String
    let medium: String
    let thumbnail: String
}

struct RandomProfileData: Identifiable, Equatable {
    let id = UUID().uuidString
    let name: RandomProfileName
    let location: RandomProfileLocation
    let email: String
    let picture: RandomProfilePicture
}
