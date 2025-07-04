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

internal protocol Lockable: AnyObject {
    func lock()
    func unlock()
}

@available(iOS 10.0, OSX 10.12, watchOS 3.0, tvOS 10.0, *)
internal final class UnfairLock: Lockable {
    private var unfairLock = os_unfair_lock_s()

    internal func lock() {
        os_unfair_lock_lock(&unfairLock)
    }

    internal func unlock() {
        os_unfair_lock_unlock(&unfairLock)
    }
}

internal final class Mutex: Lockable {
    private var mutex = pthread_mutex_t()

    internal init() {
        pthread_mutex_init(&mutex, nil)
    }

    deinit {
        pthread_mutex_destroy(&mutex)
    }

    internal func lock() {
        pthread_mutex_lock(&mutex)
    }

    internal func unlock() {
        pthread_mutex_unlock(&mutex)
    }
}

// internal final class RecursiveMutex: Lockable {
//    private var mutex = pthread_mutex_t()
//
//    internal init() {
//        // No idea why this line can cause compile failure in SwiftPM.
//        var attr = pthread_mutexattr_t()
//        pthread_mutexattr_init(&attr)
//        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE)
//        pthread_mutex_init(&mutex, &attr)
//    }
//
//    deinit {
//        pthread_mutex_destroy(&mutex)
//    }
//
//    internal func lock() {
//        pthread_mutex_lock(&mutex)
//    }
//
//    internal func unlock() {
//        pthread_mutex_unlock(&mutex)
//    }
// }

internal final class Spin: Lockable {
    private let locker: Lockable

    internal init() {
        if #available(iOS 10.0, macOS 10.12, watchOS 3.0, tvOS 10.0, *) {
            locker = UnfairLock()
        } else {
            locker = Mutex()
        }
    }

    internal func lock() {
        locker.lock()
    }

    internal func unlock() {
        locker.unlock()
    }
}

internal final class ConditionLock: Lockable {
    private var mutex = pthread_mutex_t()
    private var cond = pthread_cond_t()

    internal init() {
        pthread_mutex_init(&mutex, nil)
        pthread_cond_init(&cond, nil)
    }

    deinit {
        pthread_cond_destroy(&cond)
        pthread_mutex_destroy(&mutex)
    }

    internal func lock() {
        pthread_mutex_lock(&mutex)
    }

    internal func unlock() {
        pthread_mutex_unlock(&mutex)
    }

    internal func wait() {
        pthread_cond_wait(&cond, &mutex)
    }

    internal func wait(timeout: TimeInterval) {
        let integerPart = Int(timeout.nextDown)
        let fractionalPart = timeout - Double(integerPart)
        var ts = timespec(tv_sec: integerPart, tv_nsec: Int(fractionalPart * 1000000000))

        pthread_cond_timedwait_relative_np(&cond, &mutex, &ts)
    }

    internal func signal() {
        pthread_cond_signal(&cond)
    }
}

internal extension DispatchQueue {
    nonisolated(unsafe) private static let spin = Spin()
    nonisolated(unsafe) private static var tracker: Set<String> = []

    static func once(name: String, _ block: () -> Void) {
        spin.lock(); defer { spin.unlock() }
        guard !tracker.contains(name) else {
            return
        }
        block()
        tracker.insert(name)
    }
}
