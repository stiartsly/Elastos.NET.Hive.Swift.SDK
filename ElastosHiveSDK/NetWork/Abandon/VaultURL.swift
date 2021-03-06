/*
* Copyright (c) 2019 Elastos Foundation
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

class VaultURL {

    private var baseUrl: String = ""

    init(_ baseUrl: String) {
        self.baseUrl = baseUrl
    }

    public func resetVaultApi(baseUrl: String) {
        self.baseUrl = baseUrl
    }

    func checkToken() -> String {
        return baseUrl + "/api/v1/did/check_token"
    }

    func signIn() -> String {
        return baseUrl + "/api/v1/did/sign_in"
    }

    func auth() -> String {
        return baseUrl + "/api/v1/did/auth"
    }

    func synchronization() -> String {
        return baseUrl + "/api/v1/sync/setup/google_drive"
    }

    // db
    func mongoDBSetup() -> String {
        return baseUrl + "/api/v1/db/create_collection"
    }

    func deleteMongoDBCollection() -> String {
        return baseUrl + "/api/v1/db/delete_collection"
    }

    func mongoDBCollection() -> String {
        return baseUrl + "/api/v1/db/col/*"
    }

    func insertOne() -> String {
        return baseUrl + "/api/v1/db/insert_one"
    }

    func insertMany() -> String {
        return baseUrl + "/api/v1/db/insert_many"
    }

    func countDocuments() -> String {
        return baseUrl + "/api/v1/db/count_documents"
    }

    func findOne() -> String {
        return baseUrl + "/api/v1/db/find_one"
    }

    func findMany() -> String {
        return baseUrl + "/api/v1/db/find_many"
    }

    func updateOne() -> String {
        return baseUrl + "/api/v1/db/update_one"
    }

    func updateMany() -> String {
        return baseUrl + "/api/v1/db/update_many"
    }

    func deleteOne() -> String {
        return baseUrl + "/api/v1/db/delete_one"
    }

    func deleteMany() -> String {
        return baseUrl + "/api/v1/db/delete_many"
    }
    
    // files
    func upload(_ path: String) -> String {
        return baseUrl + "/api/v1/files/upload/" + path
    }

    func download(_ path: String) -> String {//dir.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        return baseUrl + "/api/v1/files/download?path=" + path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    func deleteFileOrFolder() -> String {
        return baseUrl + "/api/v1/files/delete"
    }

    func move() -> String {
        return baseUrl + "/api/v1/files/move"
    }

    func copy() -> String {
        return baseUrl + "/api/v1/files/copy"
    }

    func hash(_ path: String) -> String {
        return baseUrl + "/api/v1/files/file/hash?path=" + path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    func list(_ path: String) -> String {
        return baseUrl + "/api/v1/files/list/folder?path=" + path
    }

    func stat(_ path: String) -> String {
        return baseUrl + "/api/v1/files/properties?path=" + path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    // scripting
    func registerScript() -> String {
        return baseUrl + "/api/v1/scripting/set_script"
    }

    func call() -> String {
        return baseUrl + "/api/v1/scripting/run_script"
    }
    
    func runScriptUpload(_ transactionId: String) -> String {
        return baseUrl + "/api/v1/scripting/run_script_upload/\(transactionId)"
    }
    
    func runScriptDownload(_ transactionId: String) -> String {
        return baseUrl + "/api/v1/scripting/run_script_download/\(transactionId)"
    }
    
    func callScriptUrl(_ targetDid: String, _ appDid: String
                        , _ scriptName: String, _ params: String) -> String {
        return baseUrl + "/api/v1/scripting/run_script_url/" + targetDid + "@" + appDid + "/" + scriptName + "?params=" + params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    func createFreeVault() -> String {
        return baseUrl + "/api/v1/service/vault/create"
    }
    
    // version
    func version() -> String {
        return baseUrl + "/api/v1/hive/version"
    }
    
    func commitId() -> String {
        return baseUrl + "/api/v1/hive/commithash"
    }
    
    // payment
    func vaultPackageInfo() -> String {
        return baseUrl + "/api/v1/payment/vault_package_info"
    }
    
    func pricingPlan(_ name: String) -> String {
        return baseUrl + "/api/v1/payment/vault_pricing_plan?name=\(name)"
    }
 
    func paymentVersion() -> String {
        return baseUrl + "/api/v1/payment/version"
    }
    
    func createOrder() -> String {
        return baseUrl + "/api/v1/payment/create_vault_package_order"
    }
   
    func payOrder() -> String {
        return baseUrl + "/api/v1/payment/pay_vault_package_order"
    }
    
    func orderInfo(_ order_id: String) -> String {
        return baseUrl + "/api/v1/payment/vault_package_order?order_id=\(order_id)"
    }
    
    func orderList() -> String {
        return baseUrl + "/api/v1/payment/vault_package_order_list"
    }
    
    func serviceInfo() -> String {
        return baseUrl + "/api/v1/service/vault"
    }
    
    // backup
    func state() -> String {
        return baseUrl + "/api/v1/backup/state"
    }
    
    func save() -> String {
        return baseUrl + "/api/v1/backup/save_to_node"
    }
    
    func restore() -> String {
        return baseUrl + "/api/v1/backup/restore_from_node"
    }
    
    func activate() -> String {
        return baseUrl + "/api/v1/backup/activate_to_vault"
    }
    
    // service
    func createVault() -> String {
        return baseUrl + "/api/v1/service/vault/create"
    }
    
    func removeVault() -> String {
        return baseUrl + "/api/v1/service/vault/remove"
    }
    
    func freezeVault() -> String {
        return baseUrl + "/api/v1/service/vault/freeze"
    }
    
    func unfreezeVault() -> String {
        return baseUrl + "/api/v1/service/vault/unfreeze"
    }

    func vaultServiceInfo() -> String {
        return baseUrl + "/api/v1/service/vault"
    }
    
    func createBackupVault() -> String {
        return baseUrl + "/api/v1/service/vault_backup/create"
    }

    func backupVaultInfo() -> String {
        return baseUrl + "/api/v1/service/vault_backup"
    }
}
