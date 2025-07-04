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

/// ChainCall interface for inserting
public protocol InsertChainCallInterface: AnyObject {

    /// Prepare chain call for inserting of `TableEncodable` object
    ///
    /// - Parameters:
    ///   - cls: Type of table object
    ///   - table: Table name
    /// - Returns: `Insert`
    func prepareInsert<Root: TableEncodable>(of cls: Root.Type, intoTable table: String) throws -> Insert

    /// Prepare chain call for inserting or replacing of `TableEncodable` object
    ///
    /// - Parameters:
    ///   - cls: Type of table object
    ///   - table: Table name
    /// - Returns: `Insert`
    func prepareInsertOrReplace<Root: TableEncodable>(of cls: Root.Type, intoTable table: String) throws -> Insert

    /// Prepare chain call for inserting or ignoring of `TableEncodable` object
    ///
    /// - Parameters:
    ///   - cls: Type of table object
    ///   - table: Table name
    /// - Returns: `Insert`
    func prepareInsertOrIgnore<Root: TableEncodable>(of cls: Root.Type, intoTable table: String) throws -> Insert

    /// Prepare chain call for inserting on specific properties
    ///
    /// - Parameters:
    ///   - propertyConvertibleList: `Property` or `CodingTableKey` list 
    ///   - table: Table name
    /// - Returns: `Insert`
    func prepareInsert(on propertyConvertibleList: PropertyConvertible..., intoTable table: String) throws -> Insert

    /// Prepare chain call for inserting or replacing on specific properties
    ///
    /// - Parameters:
    ///   - propertyConvertibleList: `Property` or `CodingTableKey` list
    ///   - table: Table name
    /// - Returns: `Insert`
    func prepareInsertOrReplace(on propertyConvertibleList: PropertyConvertible...,
                                intoTable table: String) throws -> Insert

    /// Prepare chain call for inserting or ignoring on specific properties
    ///
    /// - Parameters:
    ///   - propertyConvertibleList: `Property` or `CodingTableKey` list
    ///   - table: Table name
    /// - Returns: `Insert`
    func prepareInsertOrIgnore(on propertyConvertibleList: PropertyConvertible...,
                                intoTable table: String) throws -> Insert

    /// Prepare chain call for inserting on specific properties
    ///
    /// - Parameters:
    ///   - propertyConvertibleList: `Property` or `CodingTableKey` list
    ///   - table: Table name
    /// - Returns: `Insert`
    func prepareInsert(on propertyConvertibleList: [PropertyConvertible]?,
                       intoTable table: String) throws -> Insert

    /// Prepare chain call for inserting or replacing on specific properties
    ///
    /// - Parameters:
    ///   - propertyConvertibleList: `Property` or `CodingTableKey` list
    ///   - table: Table name
    /// - Returns: `Insert`
    func prepareInsertOrReplace(on propertyConvertibleList: [PropertyConvertible],
                                intoTable table: String) throws -> Insert

    /// Prepare chain call for inserting or ignoring on specific properties
    ///
    /// - Parameters:
    ///   - propertyConvertibleList: `Property` or `CodingTableKey` list
    ///   - table: Table name
    /// - Returns: `Insert`
    func prepareInsertOrIgnore(on propertyConvertibleList: [PropertyConvertible],
                                intoTable table: String) throws -> Insert
}

extension InsertChainCallInterface where Self: HandleRepresentable {
    public func prepareInsert<Root: TableEncodable>(of cls: Root.Type, intoTable table: String) throws -> Insert {
        return Insert(with: try getHandle(writeHint: true), named: table, on: cls.Properties.all)
    }

    public func prepareInsertOrReplace<Root: TableEncodable>(
        of cls: Root.Type,
        intoTable table: String) throws -> Insert {
            return Insert(with: try getHandle(writeHint: true), named: table, on: cls.Properties.all, onConflict: .Replace)
    }

    public func prepareInsertOrIgnore<Root: TableEncodable>(
        of cls: Root.Type,
        intoTable table: String) throws -> Insert {
            return Insert(with: try getHandle(writeHint: true), named: table, on: cls.Properties.all, onConflict: .Ignore)
    }

    public func prepareInsert(on propertyConvertibleList: PropertyConvertible...,
                              intoTable table: String) throws -> Insert {
        return try prepareInsert(on: propertyConvertibleList, intoTable: table)
    }

    public func prepareInsertOrReplace(on propertyConvertibleList: PropertyConvertible...,
                                       intoTable table: String) throws -> Insert {
        return try prepareInsertOrReplace(on: propertyConvertibleList, intoTable: table)
    }

    public func prepareInsertOrIgnore(on propertyConvertibleList: PropertyConvertible...,
                                       intoTable table: String) throws -> Insert {
        return try prepareInsertOrIgnore(on: propertyConvertibleList, intoTable: table)
    }

    public func prepareInsert(on propertyConvertibleList: [PropertyConvertible]?,
                              intoTable table: String) throws -> Insert {
        return Insert(with: try getHandle(writeHint: true), named: table, on: propertyConvertibleList)
    }

    public func prepareInsertOrReplace(on propertyConvertibleList: [PropertyConvertible],
                                       intoTable table: String) throws -> Insert {
        return Insert(with: try getHandle(writeHint: true), named: table, on: propertyConvertibleList, onConflict: .Replace)
    }

    public func prepareInsertOrIgnore(on propertyConvertibleList: [PropertyConvertible],
                                       intoTable table: String) throws -> Insert {
        return Insert(with: try getHandle(writeHint: true), named: table, on: propertyConvertibleList, onConflict: .Ignore)
    }
}

/// ChainCall interface for deleting
public protocol DeleteChainCallInterface: AnyObject {

    /// Prepare chain call for deleting on specific properties
    ///
    /// - Parameter table: Table name
    /// - Returns: `Delete`
    func prepareDelete(fromTable table: String) throws -> Delete
}

extension DeleteChainCallInterface where Self: HandleRepresentable {
    public func prepareDelete(fromTable table: String) throws -> Delete {
        return Delete(with: try getHandle(writeHint: true), andTableName: table)
    }
}

/// ChainCall interface for updating
public protocol UpdateChainCallInterface: AnyObject {

    /// Prepare chain call for updating on specific properties
    ///
    /// - Parameters:
    ///   - table: Table name
    ///   - propertyConvertibleList: `Property` or `CodingTableKey` list
    /// - Returns: `Update`
    func prepareUpdate(table: String, on propertyConvertibleList: PropertyConvertible...) throws -> Update

    /// Prepare chain call for updating on specific properties
    ///
    /// - Parameters:
    ///   - table: Table name
    ///   - propertyConvertibleList: `Property` or `CodingTableKey` list
    /// - Returns: `Update`
    func prepareUpdate(table: String, on propertyConvertibleList: [PropertyConvertible]) throws -> Update
}

extension UpdateChainCallInterface where Self: HandleRepresentable {
    public func prepareUpdate(table: String, on propertyConvertibleList: PropertyConvertible...) throws -> Update {
        return try prepareUpdate(table: table, on: propertyConvertibleList)
    }

    public func prepareUpdate(table: String, on propertyConvertibleList: [PropertyConvertible]) throws -> Update {
        return Update(with: try getHandle(writeHint: true), on: propertyConvertibleList, andTable: table)
    }
}

/// ChainCall interface for row-selecting
public protocol RowSelectChainCallInterface: AnyObject {

    /// Prepare chain call for row-selecting on specific column results
    ///
    /// - Parameters:
    ///   - resultColumnConvertibleList: `ResultColumn` list
    ///   - tables: Table name list
    ///   - isDistinct: Is distinct or not
    /// - Returns: `RowSelect`
    func prepareRowSelect(on resultColumnConvertibleList: ResultColumnConvertible...,
                          fromTables tables: [String],
                          isDistinct: Bool) throws -> RowSelect

    /// Prepare chain call for row-selecting on specific column results
    ///
    /// - Parameters:
    ///   - resultColumnConvertibleList: `ResultColumn` list
    ///   - tables: Table name list
    ///   - isDistinct: Is distinct or not
    /// - Returns: `RowSelect`
    func prepareRowSelect(on resultColumnConvertibleList: [ResultColumnConvertible],
                          fromTables tables: [String],
                          isDistinct: Bool) throws -> RowSelect

    /// Prepare chain call for row-selecting on specific column results
    ///
    /// - Parameters:
    ///   - resultColumnConvertibleList: `ResultColumn` list
    ///   - tables: Table name
    ///   - isDistinct: Is distinct or not
    /// - Returns: `RowSelect`
    func prepareRowSelect(on resultColumnConvertibleList: ResultColumnConvertible...,
                          fromTable table: String,
                          isDistinct: Bool) throws -> RowSelect

    /// Prepare chain call for row-selecting on specific column results
    ///
    /// - Parameters:
    ///   - resultColumnConvertibleList: `ResultColumn` list
    ///   - tables: Table name
    ///   - isDistinct: Is distinct or not
    /// - Returns: `RowSelect`
    func prepareRowSelect(on resultColumnConvertibleList: [ResultColumnConvertible],
                          fromTable table: String,
                          isDistinct: Bool) throws -> RowSelect
}

extension RowSelectChainCallInterface where Self: HandleRepresentable {
    public func prepareRowSelect(on resultColumnConvertibleList: ResultColumnConvertible...,
                                 fromTables tables: [String],
                                 isDistinct: Bool = false) throws -> RowSelect {
        return try prepareRowSelect(on: resultColumnConvertibleList.isEmpty ?
                                    [Column.all()] : resultColumnConvertibleList,
                                    fromTables: tables,
                                    isDistinct: isDistinct)
    }

    public func prepareRowSelect(on resultColumnConvertibleList: [ResultColumnConvertible],
                                 fromTables tables: [String],
                                 isDistinct: Bool = false) throws -> RowSelect {
        return RowSelect(with: try getHandle(writeHint: false), results: resultColumnConvertibleList, tables: tables, isDistinct: isDistinct)
    }

    public func prepareRowSelect(on resultColumnConvertibleList: ResultColumnConvertible...,
                                 fromTable table: String,
                                 isDistinct: Bool = false) throws -> RowSelect {
        return try prepareRowSelect(on: resultColumnConvertibleList.isEmpty ?
                                    [Column.all()] : resultColumnConvertibleList,
                                    fromTable: table,
                                    isDistinct: isDistinct)
    }

    public func prepareRowSelect(on resultColumnConvertibleList: [ResultColumnConvertible],
                                 fromTable table: String,
                                 isDistinct: Bool = false) throws -> RowSelect {
        return RowSelect(with: try getHandle(writeHint: false),
                         results: resultColumnConvertibleList,
                         tables: [table],
                         isDistinct: isDistinct)
    }
}

/// ChainCall interface for selecting
public protocol SelectChainCallInterface: AnyObject {

    /// Prepare chain call for selecting of `TableDecodable` object
    ///
    /// - Parameters:
    ///   - cls: Type of table decodable object
    ///   - table: Table name
    ///   - isDistinct: Is distinct or not
    /// - Returns: `Select`
    func prepareSelect<Root: TableDecodable>(of cls: Root.Type,
                                             fromTable table: String,
                                             isDistinct: Bool) throws -> Select

    /// Prepare chain call for selecting on specific properties
    ///
    /// - Parameters:
    ///   - propertyConvertibleList: `Property` or `CodingTableKey` list
    ///   - table: Table name
    ///   - isDistinct: Is distinct or not
    /// - Returns: `Select`
    func prepareSelect(on propertyConvertibleList: PropertyConvertible...,
                       fromTable table: String,
                       isDistinct: Bool) throws -> Select

    /// Prepare chain call for selecting on specific properties
    ///
    /// - Parameters:
    ///   - propertyConvertibleList: `Property` or `CodingTableKey` list
    ///   - table: Table name
    ///   - isDistinct: Is distinct or not
    /// - Returns: `Select`
    func prepareSelect(on propertyConvertibleList: [PropertyConvertible],
                       fromTable table: String,
                       isDistinct: Bool) throws -> Select
}

extension SelectChainCallInterface where Self: HandleRepresentable {
    public func prepareSelect<Root: TableDecodable>(of cls: Root.Type,
                                                    fromTable table: String,
                                                    isDistinct: Bool = false) throws -> Select {
        return Select(with: try getHandle(writeHint: false), on: cls.Properties.all, table: table, isDistinct: isDistinct)
    }

    public func prepareSelect(on propertyConvertibleList: PropertyConvertible...,
                              fromTable table: String,
                              isDistinct: Bool = false) throws -> Select {
        return try prepareSelect(on: propertyConvertibleList,
                                 fromTable: table,
                                 isDistinct: isDistinct)
    }

    public func prepareSelect(on propertyConvertibleList: [PropertyConvertible],
                              fromTable table: String,
                              isDistinct: Bool = false) throws -> Select {
        return Select(with: try getHandle(writeHint: false), on: propertyConvertibleList, table: table, isDistinct: isDistinct)
    }
}

/// ChainCall interface for multi-selecting
public protocol MultiSelectChainCallInterface: AnyObject {

    /// Prepare chain call for multi-selecting on specific properties
    ///
    /// - Parameters:
    ///   - propertyConvertibleList: `Property` or `CodingTableKey` list
    ///   - tables: Table name list
    /// - Returns: `MultiSelect`
    func prepareMultiSelect(on propertyConvertibleList: PropertyConvertible...,
                            fromTables tables: [String]) throws -> MultiSelect

    /// Prepare chain call for multi-selecting on specific properties
    ///
    /// - Parameters:
    ///   - propertyConvertibleList: `Property` or `CodingTableKey` list
    ///   - tables: Table name list
    /// - Returns: `MultiSelect`
    func prepareMultiSelect(on propertyConvertibleList: [PropertyConvertible],
                            fromTables tables: [String]) throws -> MultiSelect
}

extension MultiSelectChainCallInterface where Self: HandleRepresentable {
    public func prepareMultiSelect(on propertyConvertibleList: PropertyConvertible...,
                                   fromTables tables: [String]) throws -> MultiSelect {
        return try prepareMultiSelect(on: propertyConvertibleList, fromTables: tables)
    }

    public func prepareMultiSelect(on propertyConvertibleList: [PropertyConvertible],
                                   fromTables tables: [String]) throws -> MultiSelect {
        return MultiSelect(with: try getHandle(writeHint: false), on: propertyConvertibleList, tables: tables)
    }
}
