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
        @BindingState var maleProfile: [RandomProfileData] = []
        @BindingState var femaleProfile: [RandomProfileData] = []
        var malePage: Int = 1
        var femalePage: Int = 1
        var isLoading: Bool = false
        var columnCount: Int = 1
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
        case changeColumnButtonTapped
        case maleTapped
        case femaleTapped
        case maleProfileResponse(TaskResult<[RandomProfileData]>)
        case femaleProfileResponse(TaskResult<[RandomProfileData]>)
        case pullToRefresh(GenderType)
        case removeProfile(Int)
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
            case .changeColumnButtonTapped:
                state.columnCount = state.columnCount == 1 ? 2 : 1
                return .none
                
            case .binding(_):
                return .none
            case .request(let genderType, let page):
                return .run { send in
                    if genderType == .male {
                        await send(.maleProfileResponse(
                            TaskResult { try await ramdomProfile.fetch(page, genderType) }
                        ))
                    } else {
                        await send(.femaleProfileResponse(
                            TaskResult { try await ramdomProfile.fetch(page, genderType) }
                        ))
                    }
                }
                
                
            case .maleProfileResponse(.success(let response)):
                if state.malePage == 1 {
                    state.maleProfile = response
                } else {
                    state.maleProfile += response
                }
                return .none
            case .maleProfileResponse(.failure):
                return .none
                
            case .femaleProfileResponse(.success(let response)):
                if state.femalePage == 1 {
                    state.femaleProfile = response
                } else {
                    state.femaleProfile += response
                }
                return .none
            case .femaleProfileResponse(.failure):
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
            case let .removeProfile(index):
                switch state.genderType {
                case .female:
                    state.femaleProfile.remove(at: index)
                case .male:
                    state.maleProfile.remove(at: index)
                }
                return .none
            }
        }
    }
}
