//
// Created by qiuwenchen on 2022/5/30.
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

public final class CommonTableExpression: Identifier<CPPCommonTableExpression> {

    public init(_ table: String) {
        super.init(with: WCDBCommonTableExpressionCreate(table.cString))
    }

    @discardableResult
    public func column(_ columnConvertible: ColumnConvertible) -> CommonTableExpression {
        let column = columnConvertible.asColumn()
        withExtendedLifetime(column) {
            WCDBCommonTableExpressionAddColumn(cppObj, column.cppObj)
        }
        return self
    }

    @discardableResult
    public func `as`(_ select: StatementSelect) -> CommonTableExpression {
        withExtendedLifetime(select) {
            WCDBCommonTableExpressionAsSelection(cppObj, select.cppObj)
        }
        return self
    }
}
