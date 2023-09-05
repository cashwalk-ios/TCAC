//
//  TCA_CApp.swift
//  TCA_C
//
//  Created by Taeuk on 2023/08/08.
//

import SwiftUI

import ComposableArchitecture

@main
struct TCA_CApp: App {
    static let store = Store(initialState: RandomProfileFeature.State()) {
        RandomProfileFeature()
            ._printChanges()
    }
    var body: some Scene {
        WindowGroup {
            RandomProfileView(store: TCA_CApp.store)
        }
    }
}
