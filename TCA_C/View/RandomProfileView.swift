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
                    GenderTopTapView(selectedGenderType: viewStore.$genderType)
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                viewStore.send(.changeColumnButtonTapped)
                            }, label: {
                                HStack {
                                    Text("보기 옵션 : \(viewStore.columnCount)열")
                                        .foregroundColor(Color.black)
                                }
                            })
                            .padding(.trailing, 20)
                            .padding(.top, 10)
                        }
                        GeometryReader { proxy in
                            TabView(selection: viewStore.$genderType) {
                                RandomProfileGenderScrollView(viewStore: viewStore, genderType: .male)
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                                RandomProfileGenderScrollView(viewStore: viewStore, genderType: .female)
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                            }.tabViewStyle(.page)
                        }.ignoresSafeArea()
                    }
                }
                .alert(isPresented: viewStore.$showingFailureAlert) {
                    Alert(
                        title: Text("네트워크를 확인해주세요"), message: nil,
                        primaryButton: .default(Text("Close")),
                        secondaryButton: .destructive(Text("Retry"), action: {
                            viewStore.send(.retryRequest)
                        })
                    )
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

struct RandomProfileGenderScrollView: View {
    var viewStore: ViewStore<RandomProfileFeature.State, RandomProfileFeature.Action>
    let genderType: GenderType
    @State private var showingAlert = false
    @State var indexToDelete: Int? // 임시
    
    var body: some View {
        ScrollView {
            let columns = Array(repeating: GridItem(.flexible()), count: viewStore.columnCount)
            LazyVGrid(columns: columns, spacing: 10) {
                let profile = genderType == .female ? viewStore.femaleProfile : viewStore.maleProfile
                ForEach(profile.indices, id: \.self) { index in
                    NavigationLink {
                        RandomProfileDetailView(profile: profile[index])
                    } label: {
                        RandomProfileRow(profileInfo: profile[index], columnCount: viewStore.columnCount)
                            .contextMenu {
                                Button {
                                    viewStore.send(.removeProfile(index))
                                } label: {
                                    Text("Remove")
                                }
                            }
                            .onAppear {
                                switch genderType {
                                case .male:
                                    if index > (viewStore.malePage - 1) * 14 - 2 - viewStore.maleRemoveCount {
                                        viewStore.send(.request(.male, viewStore.malePage))
                                    }
                                case .female:
                                    if index > (viewStore.femalePage - 1) * 14 - 2 - viewStore.femaleRemoveCount {
                                        viewStore.send(.request(.female, viewStore.femalePage))
                                    }
                                }
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .refreshable { viewStore.send(.pullToRefresh(genderType)) }
        .padding(10)
        .tag(genderType)
    }
}

struct RandomProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: RandomProfileFeature.State()) {
            RandomProfileFeature()
                ._printChanges()
        }
        RandomProfileView(store: store)
    }
}
