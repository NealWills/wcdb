//
// Created by qiuwenchen on 2022/4/21.
//

/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#if WCDB_SWIFT_BRIDGE_OBJC

import Foundation
import WCDB_Author

extension WCTBridgeProperty: PropertyOperable {

    public func isSwiftProperty() -> Bool {
        return false
    }

    public var codingTableKey: CodingTableKeyBase? {
        return nil
    }

    public var wctProperty: WCTBridgeProperty? {
        return self
    }

    public func asProperty() -> Property {
        let property = Property(named: propertyName, with: codingTableKey, with: wctProperty)
        property.tableBinding = tableBinding()
        return property
    }

    public func asColumn() -> Column {
        return asProperty().asColumn()
    }

    public func `as`(_ propertyConvertible: PropertyConvertible) -> Property {
        return Property(named: propertyName, with: propertyConvertible.codingTableKey, with: propertyConvertible.wctProperty)
    }

    public func `in`(table: String) -> Property {
        return asProperty().`in`(table: table)
    }

    public func of(schema schemaConvertible: SchemaConvertible) -> Property {
        return asProperty().of(schema: schemaConvertible)
    }

    public func asExpression() -> Expression {
        return asColumn().asExpression()
    }
}

public extension Array where Element==WCTBridgeProperty {
    var any: Column {
        return Column.all()
    }
}

#endif
