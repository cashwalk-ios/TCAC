//
//  dependencies.swift
//  TCACManifests
//
//  Created by 김하늘 on 11/14/23.
//

import ProjectDescription

extension TargetDependency {
  public static let Moya = TargetDependency.package(product: "Moya")
  public static let CombineMoya = TargetDependency.package(product: "CombineMoya")
  public static let RxMoya = TargetDependency.package(product: "RxMoya")
  public static let TCA = TargetDependency.package(product: "ComposableArchitecture")
  public static let Kingfisher = TargetDependency.package(product: "Kingfisher")
}
