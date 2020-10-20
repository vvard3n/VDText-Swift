//
//  NamespaceWrappable.swift
//
//  Created by Haijun on 2019/4/17.
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
    public static var vd: VDKit<Self>.Type { return VDKit<Self>.self }

    public var vd: VDKit<Self> { return VDKit(self) }
}

extension NSObject: VDKitNamespaceWrappable { }
