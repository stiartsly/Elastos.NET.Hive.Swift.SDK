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

public class DbFindQuery: Executable {
    private let TYPE = "find"
    private var query: Query

    public init(_ name: String, _ collection: String, _ filter: [String: Any]) {
        self.query = Query(collection, filter)
        super.init(TYPE, name)
    }

    public init(_ name: String, _ collection: String, _ filter: [String: Any], _ options: [String: Any]) {
        self.query = Query(collection, filter, options)
        super.init(TYPE, name)
    }

    public override func serialize(_ jsonGenerator: JsonGenerator) throws {
        jsonGenerator.writeStartObject()
        jsonGenerator.writeStringField("type", type)
        if let _ = name {
            jsonGenerator.writeStringField("name", name!)
        }
        jsonGenerator.writeFieldName("body")
        try query.serialize(jsonGenerator)
        jsonGenerator.writeEndObject()
    }

    public override func jsonSerialize() throws -> [String : Any] {
        let jsonGenerator = JsonGenerator()
        try serialize(jsonGenerator)
        let datafilter = jsonGenerator.toString().data(using: String.Encoding.utf8)
        return try (JSONSerialization.jsonObject(with: datafilter!,options: .mutableContainers) as? [String : Any])!
    }
}

