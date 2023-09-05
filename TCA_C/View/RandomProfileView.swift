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
    @State private var showingAlert = false
    @State var indexToDelete: Int? // 임시
    
    var subscriptions: Set<AnyCancellable> = []
//    @ObservedObject var viewModel = RandomProfileViewModel()
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack(spacing: 0) {
                    GenderTopTapView(genderType: viewStore.$genderType)
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
                                let columns = Array(repeating: GridItem(.flexible()), count: viewStore.columnCount)
                                ScrollView {
                                    LazyVGrid(columns: columns, spacing: 10) {
                                        ForEach(viewStore.maleProfile.indices, id: \.self) { index in
                                            let profileInfo = viewStore.maleProfile[index]
                                            
                                            RandomProfileRow(profileInfo: profileInfo, columnCount: viewStore.columnCount)
                                                .onAppear {
                                                    
                                                }
                                                .contextMenu {
                                                    Button {
                                                        viewStore.send(.removeProfile(index))
                                                    } label: {
                                                        Text("Remove")
                                                    }

                                                }
                                        }
                                    }
                                }
                                .padding(10)
                                .frame(width: proxy.size.width, height: proxy.size.height)
                                .tag(GenderType.male)
                                
                                ScrollView {
                                    LazyVGrid(columns: columns, spacing: 10) {
                                        ForEach(viewStore.femaleProfile.indices, id: \.self) { index in
                                            RandomProfileRow(profileInfo: viewStore.femaleProfile[index], columnCount: viewStore.columnCount)
                                                .simultaneousGesture(
                                                    LongPressGesture(minimumDuration: 0.5)
                                                        .onEnded { _ in
                                                            showingAlert.toggle()
                                                            indexToDelete = index
                                                        }
                                                )
                                                .alert(isPresented: $showingAlert) {
                                                    Alert(
                                                        title: Text("삭제할까요?"), message: nil,
                                                        primaryButton: .default(Text("NO"), action: {
                                                            showingAlert.toggle()
                                                        }),
                                                        secondaryButton: .destructive(Text("Remove"), action: {
                                                            guard let indexToDelete = indexToDelete else { return }
                                                            viewStore.send(.removeProfile(indexToDelete))
                                                            self.indexToDelete = nil
                                                        })
                                                    )
                                                }
                                        }
                                    }
                                }
                                .padding(10)
                                .frame(width: proxy.size.width, height: proxy.size.height)
                                .tag(GenderType.female)
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
    
    var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .updating($inDetectingLongPress) { value, gestureState, _ in
                gestureState = value
            }.onEnded { value in
                self.showingAlert.toggle()
            }
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
