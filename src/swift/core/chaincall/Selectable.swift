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

public class Selectable {
    public final let statement: StatementSelect
    private final var handle: Handle
    private final var preparedStatement: PreparedStatement?

    init(with handle: Handle, statement: StatementSelect) {
        self.statement = statement
        self.handle = handle
    }

    deinit {
        handle.finalize()
    }

    final func getOrCreatePrepareStatement() throws -> PreparedStatement {
        if preparedStatement == nil {
            preparedStatement = try handle.getOrCreatePreparedStatement(with: statement)
            return preparedStatement!
        } else {
            return preparedStatement!
        }
    }

    // Since `next()` may throw errors, it can't conform to `Sequence` protocol to fit a `for in` loop.
    @discardableResult
    public final func next() throws -> Bool {
        do {
            return try preparedStatement!.step()
        } catch let error {
            preparedStatement?.finalize()
            throw error
        }
    }

    /// WINQ interface
    ///
    /// - Parameter condition: Expression convertible
    /// - Returns: `self`
    @discardableResult
    public final func `where`(_ condition: Condition) -> Self {
        statement.where(condition)
        return self
    }

    /// WINQ interface for SQL
    ///
    /// - Parameter orderList: Order convertible list
    /// - Returns: `self`
    @discardableResult
    public final func order(by orderConvertibleList: OrderBy...) -> Self {
        return order(by: orderConvertibleList)
    }

    /// WINQ interface for SQL
    ///
    /// - Parameter orderList: Order convertible list
    /// - Returns: `self`
    @discardableResult
    public final func order(by orderConvertibleList: [OrderBy]) -> Self {
        statement.order(by: orderConvertibleList)
        return self
    }

    /// WINQ interface for SQL
    ///
    /// - Parameters:
    ///   - begin: Expression convertible
    ///   - end: Expression convertible
    /// - Returns: `self`
    @discardableResult
    public final func limit(from begin: Limit, to end: Limit) -> Self {
        statement.limit(from: begin, to: end)
        return self
    }

    @discardableResult
    public final func limit(_ expressionConvertibleLimit: Limit) -> Self {
        statement.limit(expressionConvertibleLimit)
        return self
    }

    @discardableResult
    public final func limit(_ expressionConvertibleLimit: Limit, offset expressionConvertibleOffset: Offset) -> Self {
        statement.limit(expressionConvertibleLimit).offset(expressionConvertibleOffset)
        return self
    }

    @discardableResult
    public final func group(by expressionConvertibleGroupList: GroupBy...) -> Self {
        return group(by: expressionConvertibleGroupList)
    }

    @discardableResult
    public final func group(by expressionConvertibleGroupList: [GroupBy]) -> Self {
        statement.group(by: expressionConvertibleGroupList)
        return self
    }

    @discardableResult
    public final func having(_ expressionConvertibleHaving: Having) -> Self {
        statement.having(expressionConvertibleHaving)
        return self
    }
}
