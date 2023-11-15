//
//  packages.swift
//  ProjectDescriptionHelpers
//
//  Created by 김하늘 on 11/14/23.
//

import ProjectDescription

extension Package {
  public static let TCA: Package = .remote(url: "https://github.com/pointfreeco/swift-composable-architecture.git", requirement: .upToNextMajor(from: "1.4.0"))
  public static let Moya: Package = .remote(url: "https://github.com/Moya/Moya", requirement: .upToNextMajor(from: "15.0.3"))
  public static let Kingfisher: Package = .remote(url: "https://github.com/onevcat/Kingfisher", requirement: .upToNextMajor(from: "7.10.0"))
}
