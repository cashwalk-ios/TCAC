//
//  RandomProfileView.swift
//  TCA_C
//
//  Created by 김민석 on 2023/08/14.
//

import SwiftUI
import Combine

import Moya
import CombineMoya
import ComposableArchitecture

struct RandomProfileView: View {
    
    let store: StoreOf<RandomProfileFeature>
    
    var subscriptions: Set<AnyCancellable> = []
//    @ObservedObject var viewModel = RandomProfileViewModel()
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack(spacing: 0) {
                    GenderTopTapView(genderType: viewStore.$genderType)
                    
                    GeometryReader { proxy in
                        TabView(selection: viewStore.$genderType) {
                            List(viewStore.maleProfile) { item in
                                ZStack{
                                    RandomProfileRow(profileInfo: item)
                                        .onAppear {
                                            // MARK: pull to refresh 시에도 호출되고있음;;;
                                            if viewStore.maleProfile.last == item {
                                                viewStore.send(.request(.male, viewStore.malePage))
                                            }
                                        }
                                    NavigationLink(destination: RandomProfileDetailView(profile: item)) {
                                        EmptyView()
                                    }
                                    .opacity(0.0)
                                    .buttonStyle(PlainButtonStyle())
                                    
                                }
                                
                            }
                            .frame(width: proxy.size.width, height: proxy.size.height)
                            .listStyle(.plain)
                            
                            .tag(GenderType.male)
                            .refreshable {
                                viewStore.send(.pullToRefresh(.male))
                            }
                            
                            List(viewStore.femaleProfile) { item in
                                ZStack{
                                    RandomProfileRow(profileInfo: item)
                                        .onAppear {
                                            // MARK: pull to refresh 시에도 호출되고있음;;;
                                            if viewStore.femaleProfile.last == item {
                                                viewStore.send(.request(.female, viewStore.femalePage))
                                            }
                                        }
                                    NavigationLink(destination: RandomProfileDetailView(profile: item)) {
                                        EmptyView()
                                    }
                                    .opacity(0.0)
                                    .buttonStyle(PlainButtonStyle())
                                    
                                }
                                
                            }
                            .frame(width: proxy.size.width, height: proxy.size.height)
                            .listStyle(.plain)
                            .tag(GenderType.female)
                            .refreshable {
                                viewStore.send(.pullToRefresh(.female))
                            }
                        }.tabViewStyle(.page)
                    }
                }
                .navigationTitle("랜덤 프로필")
                .navigationBarTitleDisplayMode(.inline)
            }
            
        }
        .onAppear {
            store.send(.request(.male, 1))
            store.send(.request(.female, 1))
        }
        
    }
}
