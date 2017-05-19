//
//  View+Layout.swift
//  Bedrock
//
//  Created by Nick Bolton on 6/28/16.
//  Copyright © 2016 Pixelbleed, LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
    typealias ViewClass = UIView
#else
    import AppKit
    typealias ViewClass = NSView
#endif

extension ViewClass {
    
    func constraint(with attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        for constraint in constraints {
            if (attribute == constraint.firstAttribute && constraint.firstItem as! NSObject == self) ||
                (attribute == constraint.secondAttribute && constraint.secondItem as! NSObject == self) {
                return constraint
            }
        }
        return nil
    }
    
    @discardableResult
    func layout(minWidth:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .width,
                                        relatedBy: .greaterThanOrEqual,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0,
                                        constant: minWidth)
        NSLayoutConstraint.activate([result])
        
        return result
    }

    @discardableResult
    func layout(maxWidth:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .width,
                                        relatedBy: .lessThanOrEqual,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0,
                                        constant: maxWidth)
        NSLayoutConstraint.activate([result])

        return result
    }

    @discardableResult
    func layout(width:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .width,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0,
                                        constant: width)
        NSLayoutConstraint.activate([result])

        return result
    }
    
    @discardableResult
    func layout(minWidth:CGFloat, maxWidth:CGFloat) -> [NSLayoutConstraint] {
        var result = Array<NSLayoutConstraint>()
        let minConstraint = layout(minWidth: minWidth)
        let maxConstraint = layout(maxWidth: maxWidth)
        result.append(minConstraint)
        result.append(maxConstraint)
        
        return result
    }
    
    @discardableResult
    func layout(minHeight:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .height,
                                        relatedBy: .greaterThanOrEqual,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0,
                                        constant: minHeight)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func layout(maxHeight:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .height,
                                        relatedBy: .lessThanOrEqual,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0,
                                        constant: maxHeight)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func layout(height:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0,
                                        constant: height)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func layout(minHeight:CGFloat, maxHeight:CGFloat) -> [NSLayoutConstraint] {
        var result = Array<NSLayoutConstraint>()
        let minConstraint = layout(minHeight: minHeight)
        let maxConstraint = layout(maxHeight: maxHeight)
        result.append(minConstraint)
        result.append(maxConstraint)
        
        return result
    }
    
    @discardableResult
    func layout(size:CGSize) -> [NSLayoutConstraint] {
        var result = Array<NSLayoutConstraint>()
        let widthConstraint = layout(width: size.width)
        let heightConstraint = layout(height: size.height)
        result.append(widthConstraint)
        result.append(heightConstraint)
        
        return result
    }
    
    @discardableResult
    func centerView() -> [NSLayoutConstraint] {
        var result = Array<NSLayoutConstraint>()
        let horizontalConstraint = centerX()
        let verticalConstraint = centerY();
        result.append(horizontalConstraint)
        result.append(verticalConstraint)
        
        return result
    }
    
    @discardableResult
    func centerX(offset:CGFloat = 0.0) -> NSLayoutConstraint {
        return centerX(toView: superview, offset: offset)
    }
    
    @discardableResult
    func centerX(toView: UIView?, offset:CGFloat = 0.0) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .centerX,
                                        relatedBy: .equal,
                                        toItem: toView,
                                        attribute: .centerX,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func centerY(offset:CGFloat = 0.0) -> NSLayoutConstraint {
        return centerY(toView: superview, offset: offset)
    }
    
    @discardableResult
    func centerY(toView: UIView?, offset:CGFloat = 0.0) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .centerY,
                                        relatedBy: .equal,
                                        toItem: toView,
                                        attribute: .centerY,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func expandWidth() -> [NSLayoutConstraint] {
        return expandWidth(insets: .zero)
    }

    @discardableResult
    func expandHeight() -> [NSLayoutConstraint] {
        return expandHeight(insets: .zero)
    }

    @discardableResult
    func expand() -> [NSLayoutConstraint] {
        return expand(insets: .zero)
    }
    
    @discardableResult
    func expandWidth(insets:UIEdgeInsets) -> [NSLayoutConstraint] {
        var result = Array<NSLayoutConstraint>()
        let leftConstraint = alignLeft(offset: insets.left)
        let rightConstraint = alignRight(offset: -insets.right)
        result.append(leftConstraint)
        result.append(rightConstraint)
        
        return result
    }
    
    @discardableResult
    func expandHeight(insets:UIEdgeInsets) -> [NSLayoutConstraint] {
        var result = Array<NSLayoutConstraint>()
        let topConstraint = alignTop(offset: insets.top)
        let bottomConstraint = alignBottom(offset: -insets.bottom)
        result.append(topConstraint)
        result.append(bottomConstraint)
        
        return result
    }
    
    @discardableResult
    func expand(insets:UIEdgeInsets) -> [NSLayoutConstraint] {
        var result = Array<NSLayoutConstraint>()
        let horizontalConstraint = expandWidth(insets: insets)
        let verticalConstraint = expandHeight(insets: insets)
        result.append(contentsOf: horizontalConstraint)
        result.append(contentsOf: verticalConstraint)
        
        return result
    }

    @discardableResult
    func alignWidth(offset: CGFloat) -> NSLayoutConstraint {
        return alignWidth(to: nil, offset: offset)
    }

    @discardableResult
    func alignWidth(to target: UIView? = nil, offset: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let targetView = target ?? superview
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .width,
                                        relatedBy: .equal,
                                        toItem: targetView,
                                        attribute: .width,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func alignWidthPercent(_ percent: CGFloat, to target: UIView? = nil, offset: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let targetView = target ?? superview
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .width,
                                        relatedBy: .equal,
                                        toItem: targetView,
                                        attribute: .width,
                                        multiplier: percent,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }

    @discardableResult
    func alignHeight(offset: CGFloat) -> NSLayoutConstraint {
        return alignHeight(to: nil, offset: offset)
    }
    
    @discardableResult
    func alignHeight(to target: UIView? = nil, offset: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let targetView = target ?? superview
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: targetView,
                                        attribute: .height,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func alignHeightPercent(_ percent: CGFloat, to target: UIView? = nil, offset: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let targetView = target ?? superview
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: targetView,
                                        attribute: .height,
                                        multiplier: percent,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func alignTop() -> NSLayoutConstraint {
        return alignTop(offset: 0.0)
    }
    
    @discardableResult
    func alignTop(offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: self.superview,
                                        attribute: .top,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func alignBottom() -> NSLayoutConstraint {
        return alignBottom(offset: 0.0)
    }

    @discardableResult
    func alignBottom(offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: self.superview,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }

    @discardableResult
    func alignBaseline() -> NSLayoutConstraint {
        return alignBaseline(offset: 0.0)
    }
    
    @discardableResult
    func alignBaseline(offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .lastBaseline,
                                        relatedBy: .equal,
                                        toItem: self.superview,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }

    @discardableResult
    func alignLeading() -> NSLayoutConstraint {
        return alignLeading(offset: 0.0)
    }
    
    @discardableResult
    func alignLeading(offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .leading,
                                        relatedBy: .equal,
                                        toItem: self.superview,
                                        attribute: .leading,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func alignTrailing() -> NSLayoutConstraint {
        return alignTrailing(offset: 0.0)
    }
    
    @discardableResult
    func alignTrailing(offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .trailing,
                                        relatedBy: .equal,
                                        toItem: self.superview,
                                        attribute: .trailing,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func alignLeft() -> NSLayoutConstraint {
        return alignLeft(offset: 0.0)
    }
    
    @discardableResult
    func alignLeft(offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .left,
                                        relatedBy: .equal,
                                        toItem: self.superview,
                                        attribute: .left,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func alignRight() -> NSLayoutConstraint {
        return alignRight(offset: 0.0)
    }
    
    @discardableResult
    func alignRight(offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .right,
                                        relatedBy: .equal,
                                        toItem: self.superview,
                                        attribute: .right,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func verticallySpace(toView:UIView) -> NSLayoutConstraint {
        return verticallySpace(toView: toView, offset: 0.0)
    }
    
    @discardableResult
    func verticallySpace(toView:UIView, offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: toView,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func horizontallySpace(toView:UIView) -> NSLayoutConstraint {
        return horizontallySpace(toView: toView, offset: 0.0)
    }
    
    @discardableResult
    func horizontallySpace(toView:UIView, offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .left,
                                        relatedBy: .equal,
                                        toItem: toView,
                                        attribute: .right,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }

    @discardableResult
    func alignTop(toTopOfView:UIView) -> NSLayoutConstraint {
        return alignTop(toTopOfView: toTopOfView, offset: 0.0)
    }
    
    @discardableResult
    func alignTop(toTopOfView:UIView, offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: toTopOfView,
                                        attribute: .top,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    

    @discardableResult
    func alignTop(toBottomOfView:UIView) -> NSLayoutConstraint {
        return alignTop(toBottomOfView: toBottomOfView, offset: 0.0)
    }
    
    @discardableResult
    func alignTop(toBottomOfView:UIView, offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: toBottomOfView,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }

    @discardableResult
    func alignTop(toBaselineOfView:UIView) -> NSLayoutConstraint {
        return alignTop(toBaselineOfView: toBaselineOfView, offset: 0.0)
    }
    
    @discardableResult
    func alignTop(toBaselineOfView:UIView, offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: toBaselineOfView,
                                        attribute: .lastBaseline,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func alignBottom(toTopOfView:UIView) -> NSLayoutConstraint {
        return alignBottom(toTopOfView: toTopOfView, offset: 0.0)
    }
    
    @discardableResult
    func alignBottom(toTopOfView:UIView, offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: toTopOfView,
                                        attribute: .top,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func alignBottom(toBottomOfView:UIView) -> NSLayoutConstraint {
        return alignBottom(toBottomOfView: toBottomOfView, offset: 0.0)
    }
    
    @discardableResult
    func alignBottom(toBottomOfView:UIView, offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: toBottomOfView,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func alignBottom(toBaselineOfView:UIView) -> NSLayoutConstraint {
        return alignBottom(toBaselineOfView: toBaselineOfView, offset: 0.0)
    }
    
    @discardableResult
    func alignBottom(toBaselineOfView:UIView, offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: toBaselineOfView,
                                        attribute: .lastBaseline,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func alignBaseline(toTopOfView:UIView) -> NSLayoutConstraint {
        return alignBaseline(toTopOfView: toTopOfView, offset: 0.0)
    }
    
    @discardableResult
    func alignBaseline(toTopOfView:UIView, offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .lastBaseline,
                                        relatedBy: .equal,
                                        toItem: toTopOfView,
                                        attribute: .top,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func alignBaseline(toBottomOfView:UIView) -> NSLayoutConstraint {
        return alignBaseline(toBottomOfView: toBottomOfView, offset: 0.0)
    }
    
    @discardableResult
    func alignBaseline(toBottomOfView:UIView, offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .lastBaseline,
                                        relatedBy: .equal,
                                        toItem: toBottomOfView,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func alignBaseline(toBaselineOfView:UIView) -> NSLayoutConstraint {
        return alignBaseline(toBaselineOfView: toBaselineOfView, offset: 0.0)
    }
    
    @discardableResult
    func alignBaseline(toBaselineOfView:UIView, offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .lastBaseline,
                                        relatedBy: .equal,
                                        toItem: toBaselineOfView,
                                        attribute: .lastBaseline,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func alignLeft(toLeftOfView:UIView) -> NSLayoutConstraint {
        return alignLeft(toLeftOfView: toLeftOfView, offset: 0.0)
    }
    
    @discardableResult
    func alignLeft(toLeftOfView:UIView, offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .left,
                                        relatedBy: .equal,
                                        toItem: toLeftOfView,
                                        attribute: .left,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }

    @discardableResult
    func alignLeft(toRightOfView:UIView) -> NSLayoutConstraint {
        return alignLeft(toRightOfView: toRightOfView, offset: 0.0)
    }
    
    @discardableResult
    func alignLeft(toRightOfView:UIView, offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .left,
                                        relatedBy: .equal,
                                        toItem: toRightOfView,
                                        attribute: .right,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }

    @discardableResult
    func alignRight(toRightOfView:UIView) -> NSLayoutConstraint {
        return alignRight(toRightOfView: toRightOfView, offset: 0.0)
    }
    
    @discardableResult
    func alignRight(toRightOfView:UIView, offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .right,
                                        relatedBy: .equal,
                                        toItem: toRightOfView,
                                        attribute: .right,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    func alignRight(toLeftOfView:UIView) -> NSLayoutConstraint {
        return alignRight(toLeftOfView: toLeftOfView, offset: 0.0)
    }
    
    @discardableResult
    func alignRight(toLeftOfView:UIView, offset:CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .right,
                                        relatedBy: .equal,
                                        toItem: toLeftOfView,
                                        attribute: .left,
                                        multiplier: 1.0,
                                        constant: offset)
        NSLayoutConstraint.activate([result])
        
        return result
    }
}
