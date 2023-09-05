//
//  GenderTopTapView.swift
//  TCA_C
//
//  Created by 김민석 on 2023/08/17.
//

import SwiftUI

struct GenderTopTapView: View {
    
    @Binding var genderType: GenderType
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(spacing: 0) {
                Spacer()
                Text(GenderType.male.title)
                Spacer()
                Color(genderType == .male ? .black : .white).frame(height: 1)
            }
            .frame(maxWidth: .infinity / 2)
            .onTapGesture {
                genderType = .male
            }
            
            VStack(spacing: 0) {
                Spacer()
                Text(GenderType.female.title)
                Spacer()
                Color(genderType == .female ? .black : .white).frame(height: 1)
            }
            .frame(maxWidth: .infinity / 2)
            .onTapGesture {
                genderType = .female
            }
        }.frame(height: 50)
    }
}

struct GenderTopTapView_Previews: PreviewProvider {
    static var previews: some View {
        GenderTopTapView(genderType: .constant(.male))
    }
}
