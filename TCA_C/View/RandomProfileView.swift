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
                                RandomProfileGenderScrollView(viewStore: viewStore)
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                                RandomProfileGenderScrollView(viewStore: viewStore)
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
            store.send(.fetchInitData)
        }
    }
}

struct RandomProfileGenderScrollView: View {
    var viewStore: ViewStore<RandomProfileFeature.State, RandomProfileFeature.Action>
    @State private var showingAlert = false
    @State private var isTapped: Bool = false
    @State private var selectedIndex: Int?
    
    var body: some View {
        ScrollView {
            let columns = Array(repeating: GridItem(.flexible()), count: viewStore.columnCount)
            LazyVGrid(columns: columns, spacing: 10) {
                let profile = viewStore.genderType == .female ? viewStore.femaleProfile : viewStore.maleProfile
                ForEach(profile.indices, id: \.self) { index in
                    NavigationLink(isActive: $isTapped) {
                        if let selectedIndex {
                            RandomProfileDetailView(profile: profile[selectedIndex])
                        }
                    } label: {
                        RandomProfileRow(profileInfo: profile[index], columnCount: viewStore.columnCount)
                            .onTapGesture {
                                isTapped.toggle()
                                selectedIndex = index
                            }
                            .onLongPressGesture {
                                print("long Tapped")
                                selectedIndex = index
                                showingAlert = true
                            }
                            .alert(isPresented: $showingAlert) {
                                Alert(
                                    title: Text("삭제할까요?"), message: nil,
                                    primaryButton: .default(Text("NO"), action: {
                                        showingAlert = false
                                    }),
                                    secondaryButton: .destructive(Text("Remove"), action: {
                                        guard let selectedIndex = selectedIndex else { return }
                                        viewStore.send(.removeProfile(selectedIndex))
                                        self.selectedIndex = nil
                                        showingAlert = false
                                    })
                                )
                            }
                            .onAppear {
                                switch viewStore.genderType {
                                case .male:
                                    if index > viewStore.maleProfile.count - 2 {
                                        viewStore.send(.request)
                                    }
                                case .female:
                                    if index > viewStore.femaleProfile.count - 2 {
                                        viewStore.send(.request)
                                    }
                                }
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .refreshable { viewStore.send(.pullToRefresh) }
        .padding(10)
        .tag(viewStore.genderType)
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
