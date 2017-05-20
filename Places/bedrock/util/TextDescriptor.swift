//
//  TextDescriptor.swift
//  Bedrock
//
//  Created by Nick Bolton on 8/16/16.
//  Copyright © 2016 Pixelbleed LLC. All rights reserved.
//

import UIKit

struct TextDescriptor {

    public var text: String
    public var font: UIFont
    public var textColor: UIColor
    
    public var textAlignment: NSTextAlignment = .left
    public var leading: CGFloat = 0.0
    public var kerning: CGFloat = 0.0
    public var baselineAdjustment: CGFloat = 0.0
    public var lineBreakMode: NSLineBreakMode = .byTruncatingTail
    public var underline = false
    
    func boundingRect(constrainedBy size: CGSize) -> CGRect {
        let paragraph = NSMutableParagraphStyle()
        paragraph.minimumLineHeight = leading
        let boundingBox = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraph], context: nil)
        return boundingBox
    }
    
    func textWidth(constraintedBy height: CGFloat) -> CGFloat {
        let size = CGSize(width: .greatestFiniteMagnitude, height: height)
        return ceil(boundingRect(constrainedBy: size).width)
    }
    
    func textHeight(constraintedBy width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        return ceil(boundingRect(constrainedBy: size).height)
    }
    
    var attributes: Dictionary<String, Any> {
        get {
            var result = [String: Any]()
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.lineBreakMode = lineBreakMode
            paragraphStyle.alignment = textAlignment
            
            if leading > 0.0 {
                paragraphStyle.minimumLineHeight = leading
                paragraphStyle.maximumLineHeight = leading
            }
            
            result[NSFontAttributeName] = font
            result[NSForegroundColorAttributeName] = textColor
            result[NSParagraphStyleAttributeName] = paragraphStyle;
            
            if kerning != 0.0 {
                result[NSKernAttributeName] = kerning
            }
            
            if underline {
                result[NSUnderlineStyleAttributeName] = NSUnderlineStyle.styleSingle.rawValue
            }
            
            if baselineAdjustment != 0.0 {
                result[NSBaselineOffsetAttributeName] = self.baselineAdjustment
            }
            
            return result;
        }
    }
    
    public var attributedText: NSAttributedString {
        get {
            return NSAttributedString(string: text, attributes: attributes)
        }
    }
    
    init(text: String,
         color: UIColor,
         font: UIFont,
         align: NSTextAlignment = .left,
         leading: CGFloat = 0.0,
         kerning: CGFloat = 0.0,
         baselineAdjustment: CGFloat = 0.0,
         lineBreakMode: NSLineBreakMode = .byTruncatingTail,
         underline: Bool = false) {
        self.text = text
        self.textColor = color
        self.font = font
        self.textAlignment = align
        self.leading = leading
        self.kerning = kerning
        self.baselineAdjustment = baselineAdjustment
        self.lineBreakMode = lineBreakMode
        self.underline = underline
    }
}
