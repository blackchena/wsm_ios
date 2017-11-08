//
//  ManageRequestProvider.swift
//  wsm
//
//  Created by DaoLQ on 10/31/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import Moya
import PromiseKit

fileprivate enum ManageRequestApiEndPoint: BaseApiTargetType {
    case getListManageRequest(requestType: RequestType, manageRequestApiInput: ManageRequestApiInputModel)
    case handleRequest(requestType: RequestType, handleRequestType: HandleRequestType, requestIds: [Int])
    
    public var path: String {
        switch self {
        case .getListManageRequest(let requestType, _):
            switch requestType {
            case RequestType.others:
                return AppConstant.apiVersion.appending("/dashboard/manager/request_leaves")
            case .overTime:
                return AppConstant.apiVersion.appending("/dashboard/manager/request_ots")
            case .dayOff:
                return AppConstant.apiVersion.appending("/dashboard/manager/request_offs")
            }
        case .handleRequest(_, _, _):
            return "/api/dashboard/manager/approvals"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getListManageRequest(_):
            return .get
        case .handleRequest(_):
            return .put
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .handleRequest(let requestType, let handleRequestType, let requestIds):
            var request: String {
                switch requestType {
                case .others:
                    return "leave"
                case .overTime:
                    return "ot"
                case .dayOff:
                    return "off"
                }
            }
            
            switch handleRequestType {
            case .approveSingleRequest:
                return ["request": request, "status": "approve", "request_id": requestIds[0]]
            case .approveMultiRequest:
                return ["request": request, "approve_all": true, "request_ids": requestIds]
            case .rejectSingleRequest:
                return ["request": request, "status": "discard", "request_id": requestIds[0]]
            }
        case .getListManageRequest(_, let manageRequestApiInput):
            return createParameters(fromDataModel: manageRequestApiInput)
        }
    }
}

enum HandleRequestType {
    case approveSingleRequest
    case approveMultiRequest
    case rejectSingleRequest
}

final class ManageRequestProvider {
    
    static func getListManageLeaveRequest(requestType: RequestType, manageRequestApiInput: ManageRequestApiInputModel) -> Promise<ManageLeaveRequestApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(ManageRequestApiEndPoint.getListManageRequest(requestType: requestType, manageRequestApiInput: manageRequestApiInput)))
    }
    
    static func getListManageOverTimeRequest(requestType: RequestType, manageRequestApiInput: ManageRequestApiInputModel) -> Promise<ManageOvertimeRequestApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(ManageRequestApiEndPoint.getListManageRequest(requestType: requestType, manageRequestApiInput: manageRequestApiInput)))
    }
    
    static func getListManageOffRequest(requestType: RequestType, manageRequestApiInput: ManageRequestApiInputModel) -> Promise<ManageOffRequestApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(ManageRequestApiEndPoint.getListManageRequest(requestType: requestType, manageRequestApiInput: manageRequestApiInput)))
    }
    
    static func acceptRequest(requestType: RequestType, handleRequestType: HandleRequestType, requestIds: [Int]) -> Promise<ResponseData> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(ManageRequestApiEndPoint.handleRequest(requestType: requestType, handleRequestType: handleRequestType, requestIds: requestIds)))
    }
}
