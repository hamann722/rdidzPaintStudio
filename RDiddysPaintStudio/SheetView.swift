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
        // we need to get the current graphisc context. Nil by default, thats why we use the guard.
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        lines.forEach { (line) in
            context.setStrokeColor(line.color)
            context.setLineWidth(CGFloat(line.strokeWidth))
            context.setLineCap(.round)
            
            //we need to enumerate through our points
            for (i, p) in line.points.enumerated() {
                /*
                 enumerated(), a swift function, returns a sequence of pairs. Ex :
                 for (i, p) in "Rohit".enumerated() {
                 print("\(n): '\(c)'")
                 // Prints "0: 'R'"
                 // Prints "1: 'o'"
                 // Prints "2: 'h'"
                 // Prints "3: 'i'"
                 // Prints "4: 't'"
                 }
                 */
                if i == 0 {
                    context.move(to: p)
                } else {
                    //sets line dash with given lengths [i , i2] being line length and line spacing respectively
                    dashMode ? (context.setLineDash(phase: 3, lengths: [50, 20])) : ()
                    context.addLine(to: p)
                }
            }
            //strokePath paints the line
            context.strokePath()
        }
        
    }
    
    //tell our array to add a new Line object
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.lines.append(Line.init(strokeWidth: Float(self.penWidth), color: self.currentColor ?? UIColor.white.cgColor, points: []))
    }
    
    //track the finger
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.toggleTools(hide: true)
        guard let point = touches.first?.location(in: nil) else { return }
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(point)
        lines.append(lastLine)
        setNeedsDisplay()
    }
    
    //tell our delegate to update the UI
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.toggleTools(hide: false)
    }
    
    
}

//our protocol for handling our finger
protocol SheetDelegate {
    func toggleTools(hide : Bool)
}
