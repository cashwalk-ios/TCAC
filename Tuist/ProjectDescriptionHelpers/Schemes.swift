//
//  Schemes.swift
//  ProjectDescriptionHelpers
//
//  Created by 김하늘 on 11/15/23.
//

import ProjectDescription

extension Scheme {
  public static let Debug = Scheme(name: "TCA_C", shared: true,
                                     buildAction: .buildAction(targets: [TargetReference(stringLiteral: "TCA_C")]),
                                     archiveAction: .archiveAction(configuration: "Debug"))
//  
//  public static let Inhouse = Scheme(name: "TCA_C", shared: true,
//                                     buildAction: .buildAction(targets: [TargetReference(stringLiteral: "TCA_C")]),
//                                     archiveAction: .archiveAction(configuration: "Inhouse"))
}
