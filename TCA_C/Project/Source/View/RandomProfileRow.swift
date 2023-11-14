//
//  RandomProfileRow.swift
//  TCA_C
//
//  Created by 김민석 on 2023/08/14.
//

import SwiftUI

import Kingfisher

struct RandomProfileRow: View {
    
    var profileInfo: RandomProfileData
    var columnCount: Int
    
    var body: some View {
        switch columnCount {
        case 2:
            VStack(spacing: 5) {
                KFImage(URL(string: profileInfo.picture.thumbnail)!)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(profileInfo.name.title) \(profileInfo.name.first) \(profileInfo.name.last)")
                        .font(.system(size: 20, weight: .bold))
                    Text(profileInfo.location.country)
                        .font(.system(size: 20))
                    Text(profileInfo.email)
                        .font(.system(size: 20))
                        .lineLimit(nil)
                }
            }
            .padding(10)
            .frame(width: UIScreen.main.bounds.width / 2, height: 200)
        default:
            HStack {
                KFImage(URL(string: profileInfo.picture.thumbnail)!)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                VStack(alignment: .leading) {
                    Text("\(profileInfo.name.title) \(profileInfo.name.first) \(profileInfo.name.last)")
                        .font(.system(size: 20, weight: .bold))
                        .lineLimit(nil)
                        .padding(.bottom, 5)
                    Text(profileInfo.location.country)
                        .font(.system(size: 20))
                    Text(profileInfo.email)
                        .font(.system(size: 20))
                        .lineLimit(nil)
                }
                .padding(10)
                Spacer()
            }
            .frame(height: 100)
        }
    }
}

struct RandomProfileRow_Previews: PreviewProvider {
    static var previews: some View {
        RandomProfileRow(profileInfo: RandomProfileData(
            name: RandomProfileName(title: "Mr", first: "Joaquin", last: "Sáez"),
            location: RandomProfileLocation(country: "Spain"),
            email: "joaquin.saez@example.com",
            picture: RandomProfilePicture(
                large: "https://randomuser.me/api/portraits/men/8.jpg",
                medium: "https://randomuser.me/api/portraits/med/men/8.jpg",
                thumbnail: "https://randomuser.me/api/portraits/thumb/men/8.jpg"
            )), columnCount: 2
        )
    }
}
