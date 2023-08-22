//
//  RandomProfileDetailView.swift
//  TCA_C
//
//  Created by 김민석 on 2023/08/17.
//

import SwiftUI

struct RandomProfileDetailView: View {
    
    let profile: RandomProfileData
    
    var body: some View {
        Text("detail 화면")
            .onAppear {
                print(profile)
            }
    }
}
