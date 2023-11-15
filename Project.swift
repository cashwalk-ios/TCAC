import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "TCA_C",
  packages: [.TCA, .Moya, .Kingfisher],
  targets: [
    Target(name: "TCA_C",
           platform: .iOS,
           product: .app,
           bundleId: "com.TCA-C",
           infoPlist: .default,
           sources: ["TCA_C/Project/Source/**"],
           resources: ["TCA_C/Project/Resource/**"],
           dependencies: [
            TargetDependency.Moya,
            TargetDependency.CombineMoya,
            TargetDependency.RxMoya,
            TargetDependency.TCA,
            TargetDependency.Kingfisher
           ]
          )
  ],
  schemes: [.Debug]
)

