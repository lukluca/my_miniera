//
//  String+AttributedHTML.swift
//  MyMiniera
//
//  Created by lukluca on 31/03/24.
//

import Foundation

extension String {
    
    var attributedHTML: AttributedString {
        if let nsAttributedString = try? NSAttributedString(data: Data(self.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil),
           var attributedString = try? AttributedString(nsAttributedString, including: \.uiKit) {
            attributedString.font = .system(size: 15, weight: .regular)
            return attributedString
        } else {
            var attr = AttributedString(self)
            attr.font = .system(size: 15, weight: .regular)
            return attr
        }
    }
}
