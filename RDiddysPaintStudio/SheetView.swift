//
//  SheetView.swift
//  RDiddysPaintStudio
//
//  Created by Rohit Didwania on 2/16/19.
//  Copyright © 2019 Rohit Didwania. All rights reserved.
//

import Foundation
import UIKit

struct Line {
    let strokeWidth: Float
    let color: CGColor
    var points: [CGPoint]
}

class SheetView : UIView {
    
    var currentColor : CGColor? = nil
    var penWidth : CGFloat = 1.0
    var lines = [Line]()
    var delegate : SheetDelegate?
    var dashMode : Bool = false
    
    
    override func draw(_ rect: CGRect) {
      
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }

        lines.forEach { (line) in
            context.setStrokeColor(line.color)
            context.setLineWidth(CGFloat(line.strokeWidth))
            context.setLineCap(.round)
            
            for (i, p) in line.points.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    dashMode ? (context.setLineDash(phase: 3, lengths: [50, 20])) : ()
                    context.addLine(to: p)
                }
            }

            context.strokePath()
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.lines.append(Line.init(strokeWidth: Float(self.penWidth), color: self.currentColor ?? UIColor.white.cgColor, points: []))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.toggleTools(hide: true)
        guard let point = touches.first?.location(in: nil) else { return }
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(point)
        lines.append(lastLine)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.toggleTools(hide: false)
    }
    
    
}

protocol SheetDelegate {
    func toggleTools(hide : Bool)
}
