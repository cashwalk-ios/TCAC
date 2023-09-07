//
//  RandomProfileDetailView.swift
//  TCA_C
//
//  Created by 김민석 on 2023/08/17.
//

import SwiftUI
import Kingfisher

struct RandomProfileDetailView: View {
    
    let profile: RandomProfileData
    
	@State var currentAmount: CGFloat = 0
	
    var body: some View {
		
		KFImage(URL(string:profile.picture.medium)!)
					.resizable()
					.scaledToFit()
					.scaleEffect(1 + currentAmount)
					.gesture(
						MagnificationGesture()
							.onChanged { value in
								currentAmount = value - 1
							}
							.onEnded { value in
								withAnimation(.spring()) {
									currentAmount = 0
								}
							}
					)
					.zIndex(1.0)
    }
}
