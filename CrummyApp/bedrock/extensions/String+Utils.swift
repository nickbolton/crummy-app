//
//  String+Utils.swift
//  Bedrock
//
//  Created by Nick Bolton on 8/17/16.
//  Copyright © 2016 Pixelbleed LLC. All rights reserved.
//
import UIKit

extension String {
    var trimmed: String { get { return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) } }
    var length: Int { get { return characters.count } }
        
    public func textSize(using font: UIFont, withBounds: CGSize = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))) -> CGSize {
        
        let options = NSStringDrawingOptions.usesLineFragmentOrigin.union(.usesFontLeading)
        let rect = self.boundingRect(with: withBounds,
                                     options: options,
                                     attributes: [NSFontAttributeName : font],
                                     context: nil)
        
        let width = ceil(rect.width)
        let height = ceil(rect.height)
        
        return CGSize(width: width, height: height)
    }
}
