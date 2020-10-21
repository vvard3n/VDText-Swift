//
//  NamespaceWrappable.swift
//
//  Created by Harwyn T'an on 2020/10/21.
//

import Foundation

//public struct VDKit<Base> {
//    public let base: Base
//
//    public init(_ base: Base) {
//        self.base = base;
//    }
//}
//
//public protocol VDKitNamespaceWrappable {
//    associatedtype WrapperType
//
//    static var vd: VDKit<WrapperType>.Type { get }
//    var vd: VDKit<WrapperType> { get }
//}
//
//
//extension VDKitNamespaceWrappable {
//    public static var vd: VDKit<Self>.Type {
//        get { return VDKit<Self>.self }
//    }
//
//    public var vd: VDKit<Self> {
//        get { return VDKit(self) }
//    }
//}
//
//extension NSObject : VDKitNamespaceWrappable { }

public struct VDKit<Base> {
    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }
}

public protocol VDKitNamespaceWrappable {
    associatedtype WrapperType

    static var vd: VDKit<WrapperType>.Type { get }
    var vd: VDKit<WrapperType> { get }
}

extension VDKitNamespaceWrappable {
    public static var vd: VDKit<Self>.Type {
        get {
            return VDKit<Self>.self
        }
        set {
            
        }
    }

    public var vd: VDKit<Self> {
        get {
            return VDKit(self)
        }
        set {
            
        }
    }
}

extension NSObject: VDKitNamespaceWrappable { }

//public struct Reactive<Base> {
//    /// Base object to extend.
//    public let base: Base
//
//    /// Creates extensions with base object.
//    ///
//    /// - parameter base: Base object.
//    public init(_ base: Base) {
//        self.base = base
//    }
//}
//
///// A type that has reactive extensions.
//public protocol ReactiveCompatible {
//    /// Extended type
//    associatedtype ReactiveBase
//
//    @available(*, deprecated, renamed: "ReactiveBase")
//    typealias CompatibleType = ReactiveBase
//
//    /// Reactive extensions.
//    static var rx: Reactive<ReactiveBase>.Type { get set }
//
//    /// Reactive extensions.
//    var rx: Reactive<ReactiveBase> { get set }
//}
//
//extension ReactiveCompatible {
//    /// Reactive extensions.
//    public static var rx: Reactive<Self>.Type {
//        get {
//            return Reactive<Self>.self
//        }
//        // swiftlint:disable:next unused_setter_value
//        set {
//            // this enables using Reactive to "mutate" base type
//        }
//    }
//
//    /// Reactive extensions.
//    public var rx: Reactive<Self> {
//        get {
//            return Reactive(self)
//        }
//        // swiftlint:disable:next unused_setter_value
//        set {
//            // this enables using Reactive to "mutate" base object
//        }
//    }
//}
//
//import class Foundation.NSObject
//
///// Extend NSObject with `rx` proxy.
//extension NSObject: ReactiveCompatible { }
//
