//
// Created by qiuwenchen on 2022/11/10.
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

import Foundation
import WCDB_Author

public final class ForeignKeyConfig<CodingTableKeyType: CodingTableKey>: TableConfiguration {
    let codingKeys: [CodingTableKeyType]
    let foreignKey: ForeignKey

    public init(_ codingKeys: CodingTableKeyType..., foreignKey: ForeignKey) {
        self.codingKeys = codingKeys
        self.foreignKey = foreignKey
    }

    public func config(with tableBinding: TableBindingBase) {
        let tableConstraint = TableConstraint().foreignKey(codingKeys, foreignKey: foreignKey)
        withExtendedLifetime(tableConstraint) {
            WCDBBindingAddTableConstraint(tableBinding.cppBinding, $0.cppObj)
        }
    }
}
