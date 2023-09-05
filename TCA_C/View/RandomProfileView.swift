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
    @GestureState private var inDetectingLongPress = false
    
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
                        }
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

struct RandomProfileGenderScrollView: View {
    let viewStore: ViewStore<RandomProfileFeature.State, RandomProfileFeature.Action>
    let genderType: GenderType
    @State private var showingAlert = false
    @State var indexToDelete: Int? // 임시
    
    var body: some View {
        ScrollView {
            let columns = Array(repeating: GridItem(.flexible()), count: viewStore.columnCount)
            LazyVGrid(columns: columns, spacing: 10) {
                let profile = genderType == .female ? viewStore.femaleProfile : viewStore.maleProfile
                ForEach(profile.indices, id: \.self) { index in
                    RandomProfileRow(profileInfo: profile[index], columnCount: viewStore.columnCount)
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.5)
                                .onEnded { _ in
                                    showingAlert = true
                                    indexToDelete = index
                                }
                        )
                        .alert(isPresented: $showingAlert) {
                            Alert(
                                title: Text("삭제할까요?"), message: nil,
                                primaryButton: .default(Text("NO"), action: {
                                    showingAlert = false
                                }),
                                secondaryButton: .destructive(Text("Remove"), action: {
                                    guard let indexToDelete = indexToDelete else { return }
                                    viewStore.send(.removeProfile(indexToDelete))
                                    self.indexToDelete = nil
                                    showingAlert = false
                                })
                            )
                        }
                }
            }
        }
        .highPriorityGesture(TapGesture())
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
