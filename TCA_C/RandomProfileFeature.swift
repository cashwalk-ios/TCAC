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
        @BindingState var showingFailureAlert: Bool = false
        
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
        case fetchInitData
        case request
        case changeColumnButtonTapped
        case maleProfileResponse(TaskResult<[RandomProfileData]>)
        case femaleProfileResponse(TaskResult<[RandomProfileData]>)
        case pullToRefresh
        case removeProfile(Int)
        case retryRequest
    }
    
    @Dependency(\.randomProfile) var ramdomProfile
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .changeColumnButtonTapped:
                state.columnCount = state.columnCount == 1 ? 2 : 1
                return .none
            case .binding(_):
                return .none
            case .request:
                let gender = state.genderType
                let page = gender == .male ? state.malePage : state.femalePage
                
                return .run { send in
                    switch gender {
                    case .male:
                        await send(.maleProfileResponse(
                            TaskResult { try await ramdomProfile.fetch(page, gender) }
                        ))
                    case .female:
                        await send(.femaleProfileResponse(
                            TaskResult { try await ramdomProfile.fetch(page, gender) }
                        ))
                    }
                }
            case .maleProfileResponse(.success(let response)):
                if state.malePage == 1 {
                    state.maleProfile = response
                } else {
                    state.maleProfile += response
                }
                state.malePage += 1
                state.showingFailureAlert = false
                return .none
            case .maleProfileResponse(.failure), .femaleProfileResponse(.failure):
                state.showingFailureAlert = true
                return .none
                
            case .femaleProfileResponse(.success(let response)):
                if state.femalePage == 1 {
                    state.femaleProfile = response
                } else {
                    state.femaleProfile += response
                }
                state.femalePage += 1
                state.showingFailureAlert = false
                return .none
                
            case .pullToRefresh:
                let gender = state.genderType
                switch gender {
                case .male:
                    state.malePage = 1
                    return .run { send in
                        await send(.request)
                    }
                case .female:
                    state.femalePage = 1
                    return .run { send in
                        await send(.request)
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
                
            case .retryRequest:
                state.showingFailureAlert = false
                return .run { send in
                    await send(.request)
                }
            case .fetchInitData:
                return .run { send in
                    await send(.maleProfileResponse(
                        TaskResult {
                            try await ramdomProfile.fetch(1, .male)
                        }
                    ))
                    await send(.femaleProfileResponse(
                        TaskResult {
                            try await ramdomProfile.fetch(1, .female)
                        }
                    ))
                    
                }
            }
        }
    }
}
