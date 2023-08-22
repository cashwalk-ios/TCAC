//
//  RandomProfileFeature.swift
//  TCA_C
//
//  Created by 김민석 on 2023/08/17.
//

import Foundation

import ComposableArchitecture

struct RandomProfileFeature: Reducer {
    
    struct State: Equatable {
        @BindingState var genderType: GenderType = .male
        var maleProfile: [RandomProfileData] = []
        var femaleProfile: [RandomProfileData] = []
        var malePage: Int = 1
        var femalePage: Int = 1
        var isLoading: Bool = false
    }
    
    // 바인딩을 하기 위해서는 BindingState 프로퍼티 래퍼가 필요함
    // 이걸 쓸려면 액션에 BindableAction을 해줘야함
    // 이걸 하면 case bind ... 을해야댐
    // var body: some ReduceOf<Self> 로 해야함 func reducer를 쓰지 말고
    // body 안에 BindingReducer() 를 넣어줘야함
    // Reduce { state, action in 으로 시작 해주면 댐
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case request(GenderType, Int)
        case maleTapped
        case femaleTapped
        case maleProfileResponse([RandomProfileData])
        case femaleProfileResponse([RandomProfileData])
        case pullToRefresh(GenderType)
    }
    
    @Dependency(\.randomProfile) var ramdomProfile
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .maleTapped:
                state.genderType = .male
                return .none
            case .femaleTapped:
                state.genderType = .female
                return .none
            case .binding(_):
                return .none
            case .request(let genderType, let page):
                
                // MARK: 네트워크 통신은 Envirment에서 해주어야 하는지..?
                return .run { send in
                    if genderType == .male {
                        try await send(.maleProfileResponse(self.ramdomProfile.fetch(page, .male)))
                    } else {
                        try await send(.femaleProfileResponse(self.ramdomProfile.fetch(page, .female)))
                    }
                }
            case .maleProfileResponse(let maleProfile):
                if state.malePage == 1 {
                    state.maleProfile = maleProfile
                } else {
                    state.maleProfile += maleProfile
                }
                if !maleProfile.isEmpty {
                    state.malePage += 1
                }
                return .none
            case .femaleProfileResponse(let femaleProfile):
                if state.femalePage == 1 {
                    state.femaleProfile = femaleProfile
                } else {
                    state.femaleProfile += femaleProfile
                }
                if !femaleProfile.isEmpty {
                    state.femalePage += 1
                }
                return .none
            case .pullToRefresh(let genderType):
                if genderType == .male {
                    state.malePage = 1
                    return .run { send in
                        await send(.request(.male, 1))
                    }
                } else {
                    state.femalePage = 1
                    return .run { send in
                        await send(.request(.female, 1))
                    }
                }
            }
        }
    }
}
