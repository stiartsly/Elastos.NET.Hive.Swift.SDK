/*
* Copyright (c) 2020 Elastos Foundation
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/

import Foundation
import ObjectMapper

public class VaultInfo: Mappable {
    var _myDid: String?
    var _appInstanceDid: String?
    var appId: String?
    var provider: String?

    var _serviceDid: String?
    var pricingUsing: String?
    var createTime: String?
    var modifyTime: String?
    var maxSpace: Int8?
    var dbSpaceUsed: Int8?
    var fileSpaceUsed: Int8?
    var existing: Bool?
    
    public init(_ appInstanceDid: String?, _ myDid: String, _ serviceDid: String?) {
        self._appInstanceDid = appInstanceDid
        self._myDid = myDid
        self._serviceDid = serviceDid
    }

    public var appInstanceDid: String? {
        return _appInstanceDid;
    }

    public var myDid: String? {
        return _myDid;
    }

    public var serviceDid: String? {
        return _serviceDid;
    }
    
    public required init?(map: Map) {}

    public func mapping(map: Map) {

    }
}

public class SubscriptionRender: ServiceEndpoint, SubscriptionService, PaymentService {
    
    public func subscribe<T>(_ pricingPlan: String, type: T.Type) -> Promise<T> {
        // TODO
        return Promise<T> { resolver in
            resolver.fulfill(true as! T)
        }
    }
    
    public func checkSubscription() -> Promise<Void> {
        // TODO
        return Promise<Void> { resolver in
            resolver.fulfill(Void())
        }
    }
    
    public func getReceipt(_ receiptId: String) -> Promise<Receipt> {
        // TODO
        return Promise<Receipt> { resolver in
            resolver.fulfill(true as! Receipt)
        }
    }
        
    public func subscribe<T: Mappable>(_ pricingPlan: String?,_ type: T.Type) throws -> Promise<T> {
        return Promise<T> { resolver in
            let header = try self.connectionManager.headers()
            let vaultInfo = VaultInfo(nil, self.context.userDid!, nil)
            let response = AF.request(self.connectionManager.hiveApi.createVault(), method: .post, encoding: JSONEncoding.default, headers:header).responseJSON()
            switch response.result {
            case .success(let json):
                let response: CreateServiceResponse = CreateServiceResponse(JSON: json as! [String : Any])!
                if response.existing == true {
                    throw HiveError.vaultAlreadyExist
                }
                resolver.fulfill(vaultInfo as! T)
            case .failure(let error):
                resolver.reject(error)
            }
        }
    }
    
    public func unsubscribe() throws -> Promise<Void> {
        return Promise<Void> { resolver in
            let header = try self.connectionManager.headers()
            let response = AF.request(self.connectionManager.hiveApi.removeVault(), method: .post, encoding: JSONEncoding.default, headers: header).responseJSON()
            switch response.result {
            case .success(let json):
                print(json)
                resolver.fulfill(Void())
            case .failure(let error):
                resolver.reject(error)
            }
        }
    }
    
    public func activate() throws -> Promise<Void> {
        return Promise<Void> { resolver in
            let header = try self.connectionManager.headers()
            let response = AF.request(self.connectionManager.hiveApi.unfreeze(), method: .post, encoding: JSONEncoding.default, headers: header).responseJSON()
            switch response.result {
            case .success(let json):
                print(json)
                resolver.fulfill(Void())
            case .failure(let error):
                resolver.reject(error)
            }
        }
    }
    
    public func deactivate() throws -> Promise<Void> {
        return Promise<Void> { resolver in
            let header = try self.connectionManager.headers()
            let response = AF.request(self.connectionManager.hiveApi.freeze(), method: .post, encoding: JSONEncoding.default, headers: header).responseJSON()
            switch response.result {
            case .success(let json):
                resolver.fulfill(Void())
            case .failure(let error):
                resolver.reject(error)
            }
        }
    }
    
    public func checkSubscription() throws -> Promise<VaultInfo> {
        return Promise<VaultInfo> { resolver in
            resolver.fulfill(true as! VaultInfo)
        }
    }
    
    
    public func getPricingPlanList() -> Promise<Array<PricingPlan>> {
        return Promise<Void>.async().then { [self] _ -> Promise<Array<PricingPlan>> in
            return Promise<Array<PricingPlan>> { resolver in
                do {
                    let url = self.connectionManager.hiveApi.getPackageInfo()
                    let response = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: try self.connectionManager.headers()).responseJSON()
                    let json = try VaultApi.handlerJsonResponse(response)
                    let plan = PricingPlan.deserialize(json)
                    resolver.fulfill([plan])
                } catch {
                    resolver.reject(error)
                }
            }
        }
    }

    public func getPricingPlan(_ planName: String) -> Promise<PricingPlan> {
        return Promise<Void>.async().then { [self] _ -> Promise<PricingPlan> in
            return Promise<PricingPlan> { resolver in
                do {
                    let url = self.connectionManager.hiveApi.getPricingPlan(planName)
                    let response = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: try self.connectionManager.headers()).responseJSON()
                    let json = try VaultApi.handlerJsonResponse(response)
                    let plan = PricingPlan.deserialize(json)
                    resolver.fulfill(plan)
                } catch {
                    resolver.reject(error)
                }
            }
        }
    }
    
    public func placeOrder(_ planName: String) -> Promise<Order> {
        return Promise<Void>.async().then { [self] _ -> Promise<Order> in
            return Promise<Order> { resolver in
                do {
                    let url = self.connectionManager.hiveApi.createOrder()
                    let params = ["pricing_name": planName]
                    let response = AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: try self.connectionManager.headers()).responseJSON()
                    let json = try VaultApi.handlerJsonResponse(response)
                    resolver.fulfill(Order.deserialize(json["order_info"]))
                } catch {
                    resolver.reject(error)
                }
            }
        }
    }

    public func getOrder(_ orderId: String) -> Promise<Order> {
        return Promise<Void>.async().then { [self] _ -> Promise<Order> in
            return Promise<Order> { resolver in
                do {
                    let url = self.connectionManager.hiveApi.orderInfo(orderId)
                    let json = try AF.request(url, method: .get, encoding: JSONEncoding.default, headers: try self.connectionManager.headers()).responseJSON().validateResponse()
                    resolver.fulfill(Order.deserialize(json["order_info"]))
                } catch {
                    resolver.reject(error)
                }
            }
        }
    }
    
    
    public func payOrder(_ orderId: String, _ transId: String) -> Promise<Receipt> {
        return Promise<Void>.async().then { [self] _ -> Promise<Receipt> in
            return Promise<Receipt> { resolver in
                do {
                    let url = self.connectionManager.hiveApi.payOrder
                    let params = ["order_id": orderId, "pay_txids": transId] as [String : Any]
                    let response = AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: try self.connectionManager.headers()).responseJSON()
                    let json = try VaultApi.handlerJsonResponse(response)
                    resolver.fulfill(Receipt(json))
                } catch {
                    resolver.reject(error)
                }
            }
        }
    }
    
    public func getReceipt() throws -> Promise<Receipt> {
        // TODO
        return Promise<Receipt> { resolver in
            resolver.fulfill(true as! Receipt)
        }
    }
}

public class VaultSubscription {
    public var render: SubscriptionRender
    public var context: AppContext
    private var connectionManager: ConnectionManager

    public init (_ context: AppContext,_ userDid: String, _ providerAddress: String) {
        self.context = context
        self.connectionManager = self.context.connectionManager
        self.render = SubscriptionRender(context, providerAddress, userDid)
    }

    public func subscribe(_ pricingPlan: String) throws -> Promise<VaultInfo> {
        return try self.render.subscribe(pricingPlan, VaultInfo.self);
    }
    
    public func unsubscribe() throws -> Promise<Void> {
        return try self.render.unsubscribe();
    }
    
    public func activate() throws -> Promise<Void> {
        return try self.render.activate();
    }
    
    public func deactivate() throws -> Promise<Void> {
        return try self.render.deactivate();
    }
    
    public func checkSubscription() throws -> Promise<VaultInfo> {
        return try self.render.checkSubscription();
    }
    
    public func getPricingPlanList() -> Promise<Array<PricingPlan>> {
        return render.getPricingPlanList()
    }

    public func getPricingPlan(_ planName: String) -> Promise<PricingPlan> {
        return render.getPricingPlan(planName)
    }

    public func getOrder(_ orderId: String) -> Promise<Order> {
        return render.getOrder(orderId)
    }

    public func payOrder(_ orderId: String, _ transId: String) -> Promise<Receipt> {
        return render.payOrder(orderId, transId)
    }
    
    public func getReceipt(_ receiptId: String) throws -> Promise<Receipt> {
        return render.getReceipt(receiptId)
    }
}
