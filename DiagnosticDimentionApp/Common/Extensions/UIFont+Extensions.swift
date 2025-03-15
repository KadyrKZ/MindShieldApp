// UIFont+Extensions.swift
// Copyright © KadyrKZ. All rights reserved.

import UIKit

extension UIFont {
    static func notoSans(ofSize size: CGFloat) -> UIFont {
        UIFont(name: "NotoSans-VariableFont_wdth,wght", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }

    static func notoSansBold(ofSize size: CGFloat) -> UIFont {
        UIFont(name: "NotoSans-VariableFont_wdth,wght", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }

    static func inriaSansBold(ofSize size: CGFloat) -> UIFont {
        UIFont(name: "InriaSans-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }

    static func inriaSansRegular(ofSize size: CGFloat) -> UIFont {
        UIFont(name: "InriaSans-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
}
