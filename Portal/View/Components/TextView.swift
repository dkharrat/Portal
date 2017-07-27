//
//  TextView.swift
//  Portal
//
//  Created by Cristian Ames on 7/18/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import Foundation

public enum TextType {
    
    case regular(String)
    case attributed(NSAttributedString)
    
}

public func textView<MessageType>(
    text: String,
    style: StyleSheet<TextViewStyleSheet> = TextViewStyleSheet.`default`,
    layout: Layout = layout()) -> Component<MessageType> {
    return .textView(.regular(text), style, layout)
}

public func textView<MessageType>(
    text: NSAttributedString,
    style: StyleSheet<TextViewStyleSheet> = TextViewStyleSheet.`default`,
    layout: Layout = layout()) -> Component<MessageType> {
    return .textView(.attributed(text), style, layout)
}

// MARK: - Style sheet

public struct TextViewStyleSheet {
    
    static let `default` = StyleSheet<TextViewStyleSheet>(component: TextViewStyleSheet())
    
    public var textColor: Color
    public var textFont: Font
    public var textSize: UInt
    public var textAligment: TextAligment
    public init(
        textColor: Color = .black,
        textFont: Font = defaultFont,
        textSize: UInt = defaultButtonFontSize,
        textAligment: TextAligment = .natural ) {
        self.textColor = textColor
        self.textFont = textFont
        self.textSize = textSize
        self.textAligment = textAligment
    }
    
}

public func textViewStyleSheet(
    configure: (inout BaseStyleSheet, inout TextViewStyleSheet) -> Void = { _ in }
    ) -> StyleSheet<TextViewStyleSheet> {
    var base = BaseStyleSheet()
    var component = TextViewStyleSheet()
    configure(&base, &component)
    return StyleSheet(component: component, base: base)
}