//
//  RandomProfileClient.swift
//  TCA_C
//
//  Created by 김민석 on 2023/08/18.
//

import Foundation

import ComposableArchitecture

struct RandomProfileClient {
    var fetch: (_ page: Int, _ genderType: GenderType) async throws -> [RandomProfileData]
}

extension RandomProfileClient: DependencyKey {
    static let liveValue = Self { page, genderType in
        do {
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "https://randomuser.me/api/?page=\(page)&results=14&gender=\(genderType.rawValue)")!)
            if let decodedData = try? JSONDecoder().decode(RandomProfileResponse.self, from: data) {
                let randomProfile = decodedData.results.map {
                    RandomProfileData(
                        name: $0.name,
                        location: $0.location,
                        email: $0.email,
                        picture: $0.picture
                    )
                }
                return randomProfile
            } else {
                throw NSError(domain: "Decoding Error", code: 500)
            }
        } catch let error {
            throw error
        }
    }
}

extension DependencyValues {
    var randomProfile: RandomProfileClient {
        get { self[RandomProfileClient.self] }
        set { self[RandomProfileClient.self] = newValue }
    }
}
