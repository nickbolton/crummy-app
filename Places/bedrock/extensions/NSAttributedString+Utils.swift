//
//  NSAttributedString+Utils.swift
//  Bedrock
//
//  Created by Nick Bolton on 5/20/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import UIKit

extension NSAttributedString {

    func textSize(width: CGFloat = CGFloat(MAXFLOAT), height: CGFloat = CGFloat(MAXFLOAT)) -> CGSize {
        return textSizeWithSize(CGSize(width: width, height: height))
    }
    
    func textSizeWithSize(_ size: CGSize = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))) -> CGSize {
        let options = NSStringDrawingOptions.usesLineFragmentOrigin//.union(.usesFontLeading)
        let rect = boundingRect(with: size, options: options, context: nil)
        return CGSize(width: ceil(rect.width), height: ceil(rect.height))
    }
    
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}
