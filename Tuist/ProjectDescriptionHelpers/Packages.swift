//
//  packages.swift
//  ProjectDescriptionHelpers
//
//  Created by 김하늘 on 11/14/23.
//

import ProjectDescription

extension Package {
  public static let packages: [Package] = [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.4.0"),
    .package(url: "https://github.com/Moya/Moya", from: "15.0.3"),
    .package(url: "https://github.com/onevcat/Kingfisher", from: "7.10.0")
  ]
}
