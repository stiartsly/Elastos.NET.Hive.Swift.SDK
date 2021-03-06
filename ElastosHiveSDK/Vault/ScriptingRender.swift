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

public class ScriptingRender: ScriptingProtocol {
    let connectionManager: ConnectionManager
    let scriptRunner: ScriptRunner
    
    public init(_ vault: Vault) {
        self.connectionManager = vault.connectionManager
        self.scriptRunner = ScriptRunner(vault.appContext, vault.providerAddress, vault.userDid, vault.ownerDid, vault.appDid)
    }
    
    public func registerScript(_ name: String, _ executable: Executable, _ allowAnonymousUser: Bool, _ allowAnonymousApp: Bool) -> Promise<Bool> {
        return self.registerScriptImp(name, nil, executable, allowAnonymousUser, allowAnonymousApp)
    }
    
    public func registerScript(_ name: String, _ condition: Condition, _ executable: Executable, _ allowAnonymousUser: Bool, _ allowAnonymousApp: Bool) -> Promise<Bool> {
        return self.registerScriptImp(name, condition, executable, allowAnonymousUser, allowAnonymousApp)
    }
    
    private func registerScriptImp(_ name: String, _ accessCondition: Condition?, _ executable: Executable,_ allowAnonymousUser: Bool, _ allowAnonymousApp: Bool) -> Promise<Bool> {
        Promise<Bool> { resolver in
            
            var param = ["name": name] as [String : Any]
            param["allowAnonymousUser"] = allowAnonymousUser
            param["allowAnonymousApp"] = allowAnonymousApp
            if let _ = accessCondition {
                param["accessCondition"] = try accessCondition!.jsonSerialize()
            }
            param["executable"] = try executable.jsonSerialize()
            let url = self.connectionManager.hiveApi.registerScript()
            let header = try self.connectionManager.headers()
            _ = try AF.request(url,
                               method: .post,
                               parameters: param,
                               encoding: JSONEncoding.default,
                               headers:header).responseJSON().validateResponse()
            resolver.fulfill(true)
        }
    }
    
    public func callScript<T>(_ name: String, _ params: [String : Any]?, _ appDid: String?, _ resultType: T.Type) -> Promise<T> {
        return Promise<Any>.async().then{ [self] _ -> Promise<T> in
            return scriptRunner.callScript(name, params, appDid, resultType)
        }
    }
    
    public func callScriptUrl<T>(_ name: String, _ params: String?, _ appDid: String, _ resultType: T.Type) -> Promise<T> {
        return Promise<Any>.async().then{ [self] _ -> Promise<T> in
            return scriptRunner.callScriptUrl(name, params, appDid, resultType)
        }
    }
    
    public func uploadFile(_ transactionId: String) -> Promise<FileWriter> {
        return Promise<Any>.async().then{ [self] _ -> Promise<FileWriter> in
            return scriptRunner.uploadFile(transactionId)
        }
    }
    
    public func downloadFile(_ transactionId: String) -> Promise<FileReader> {
        return Promise<Any>.async().then{ [self] _ -> Promise<FileReader> in
            return scriptRunner.downloadFile(transactionId)
        }
    }
}
