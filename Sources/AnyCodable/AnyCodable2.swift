//
//  AnyCodable2.swift
//
//  Created by Sereivoan Yong on 11/28/22.
//

import Foundation

struct AA: Encodable {


}

@usableFromInline
enum DecodableStorage {

  case value(Any?)
  case container(SingleValueDecodingContainer)
}

func foo() {
  let decoder = JSONDecoder()
  let d2 = try! decoder.decode(AnyDecodable2.self, from: Data())
  //  d2.value()

  let dictionary: [String: AnyEncodable2] = [
    "boolean": .init(AA())
  ]

  let encoder = JSONEncoder()
  let json = try! encoder.encode(dictionary)
}

@usableFromInline
protocol _AnyDecodable2: Decodable {

  var storage: DecodableStorage { get }
}

extension _AnyDecodable2 {

  public var isNil: Bool {
    switch storage {
    case .value(let value):
      return value == nil
    case .container(let container):
      return container.decodeNil()
    }
  }

  public func value<T: Decodable>() -> T? {
    switch storage {
    case .value(let value):
      return value as? T
    case .container(let container):
      return container.decodeNil() ? nil : try? container.decode(T.self)
    }
  }

  public func decoded2<T: Decodable>() throws -> T? {
    switch storage {
    case .value(let value):
      return value as? T
    case .container(let container):
      return container.decodeNil() ? nil : try container.decode(T.self)
    }
  }
}

public struct AnyDecodable2: Decodable, _AnyDecodable2 {

  @usableFromInline
  let storage: DecodableStorage

  public init(_ value: Any?) {
    storage = .value(value)
  }

  public init(from decoder: Decoder) throws {
    storage = try .container(decoder.singleValueContainer())
  }
}

@usableFromInline
protocol _AnyEncodableBox {

  func encode(to encoder: Encoder) throws

  var base: Any { get }
}

struct _ConcreteEncodableBox<Base: Encodable>: _AnyEncodableBox {

  let baseEncodable: Base

  init(_ base: Base) {
    baseEncodable = base
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(baseEncodable)
  }

  var base: Any {
    return baseEncodable
  }
}

public struct AnyEncodable2: Encodable {

  let box: _AnyEncodableBox

  public init<E: Encodable>(_ base: E) {
    box = _ConcreteEncodableBox(base)
  }

  public func encode(to encoder: Encoder) throws {
    try box.encode(to: encoder)
  }

  public var base: Any {
    return box.base
  }
}

extension AnyEncodable2: CustomStringConvertible {

  public var description: String {
    return String(describing: base)
  }
}

extension AnyEncodable2: CustomDebugStringConvertible {

  public var debugDescription: String {
    return "AnyEncodable(" + String(reflecting: base) + ")"
  }
}

extension AnyEncodable2: CustomReflectable {

  public var customMirror: Mirror {
    return Mirror(self, children: ["value": base])
  }
}

public struct AnyCodable2: Decodable, _AnyDecodable2 {

  @usableFromInline
  let storage: DecodableStorage

  public init<C: Codable>(_ base: C?) {
    storage = .value(base)
  }

  public init(from decoder: Decoder) throws {
    storage = try .container(decoder.singleValueContainer())
  }
}

public struct AnyEncodable2: Encodable {

  let box: _AnyEncodableBox

  public init<E: Encodable>(_ base: E) {
    box = _ConcreteEncodableBox(base)
  }

  public func encode(to encoder: Encoder) throws {
    try box.encode(to: encoder)
  }

  public var base: Any {
    return box.base
  }
}

extension AnyEncodable2: CustomStringConvertible {

  public var description: String {
    return String(describing: base)
  }
}

extension AnyEncodable2: CustomDebugStringConvertible {

  public var debugDescription: String {
    return "AnyEncodable(" + String(reflecting: base) + ")"
  }
}

extension AnyEncodable2: CustomReflectable {

  public var customMirror: Mirror {
    return Mirror(self, children: ["value": base])
  }
}
