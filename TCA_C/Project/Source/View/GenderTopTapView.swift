//
//  GenderTopTapView.swift
//  TCA_C
//
//  Created by 김민석 on 2023/08/17.
//

import SwiftUI

struct GenderTopTapView: View {
    
    @Binding var selectedGenderType: GenderType
    
    var body: some View {
        HStack(alignment: .top) {
            GenderButton(selectedGenderType: $selectedGenderType, type: .male)
            GenderButton(selectedGenderType: $selectedGenderType, type: .female)
        }.frame(height: 50)
    }
}

struct GenderButton: View {
    @Binding var selectedGenderType: GenderType
    var type: GenderType
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text(type.title)
            Spacer()
            Color(type == selectedGenderType ? .black : .white).frame(height: 1)
        }
        .frame(maxWidth: .infinity / 2)
        .onTapGesture {
            selectedGenderType = selectedGenderType == .female ? .male : .female
        }
    }
}

struct GenderTopTapView_Previews: PreviewProvider {
    static var previews: some View {
        GenderTopTapView(selectedGenderType: .constant(.male))
    }
}
