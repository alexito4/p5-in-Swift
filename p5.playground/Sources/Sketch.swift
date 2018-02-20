import Foundation

// MARK:

extension Float {
var f: CGFloat {
    return CGFloat(self)
}
}

extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
public enum AngleMode {
    case degrees
    case radians
}
// state
var ctx: CGContext {
    guard let c = NSGraphicsContext.current?.cgContext else {
        fatalError("No graphics context")
    }
    return c
}
var _rect: CGRect!
public var rect: CGRect {
    return _rect
}
var angleMode = AngleMode.radians

//

public func background(_ white: Float) {
    ctx.setFillColor(gray: white.f, alpha: 1)
    ctx.fill(rect)
}

public func hour() -> Int {
    return Calendar.current.component(.hour, from: Date())
}

public func minute() -> Int {
    return Calendar.current.component(.minute, from: Date())
}

public func second() -> Int {
    return Calendar.current.component(.second, from: Date())
}

public func strokeWeight(_ weight: Int) {
    ctx.setLineWidth(CGFloat(weight))
}

public func stroke(_ r: Float, _ g: Float, _ b: Float) {
    ctx.setStrokeColor(red: r.f/255, green: g.f/255, blue: b.f/255, alpha: 1)
}

public func stroke(_ white: Float) {
    ctx.setStrokeColor(gray: white.f, alpha: 1)
}

public func noFill() {
    
}

public func map(
    _ input: Float,
    _ inputLow: Float,
    _ inputHigh: Float,
    _ outputLow: Float,
    _ outputHigh: Float,
    withBounds: Bool = false
    ) -> Float {
    let res = (input - inputLow) * ( (outputHigh - outputLow) / (inputHigh - inputLow) ) + outputLow
    if withBounds {
        // clamp
    }
    return res
}

public func line(_ x1: Float, _ y1: Float, _ x2: Float, _ y2: Float) {
    ctx.move(to: CGPoint(x: x1.f, y: y1.f))
    ctx.addLine(to: CGPoint(x: x2.f, y: y2.f))
    ctx.strokePath()
}

public func point(_ x: Float, _ y: Float) {
    let size: CGFloat = 1
    let rect = CGRect(
        x: x.f - size/2,
        y: y.f - size/2,
        width: size,
        height: size
    )
    ctx.strokeEllipse(in: rect)
}

public func translate(_ x: Float, _ y: Float) {
    ctx.translateBy(x: x.f, y: y.f)
}

public func angleMode(_ mode: AngleMode) {
    angleMode = mode
}

// rotate
public func rota(_ angle: Float) {
    let radians: Float
    if angleMode == .degrees {
        radians = angle.degreesToRadians
    } else {
        radians = angle
    }
    ctx.rotate(by: radians.f)
}

public func push() {
    ctx.saveGState()
}

public func pop() {
    ctx.restoreGState()
}

// MARK: Sketch

import PlaygroundSupport

var displayLink: CVDisplayLink?

public final class Sketch {
    public static func create(setup: () -> (), draw: @escaping () -> ()) {
        setup()
        
        let view = MyView(
            frame: NSRect(x: 0, y: 0, width: 400, height: 400),
            draw: draw
        )
        
        PlaygroundPage.current.liveView = view
        PlaygroundPage.current.needsIndefiniteExecution = true
        
        let displayLinkOutputCallback: CVDisplayLinkOutputCallback = {(displayLink: CVDisplayLink, inNow: UnsafePointer<CVTimeStamp>, inOutputTime: UnsafePointer<CVTimeStamp>, flagsIn: CVOptionFlags, flagsOut: UnsafeMutablePointer<CVOptionFlags>, displayLinkContext: UnsafeMutableRawPointer?) -> CVReturn in
            DispatchQueue.main.sync {
                let view = unsafeBitCast(displayLinkContext, to: MyView.self)
                view.setNeedsDisplay(view.bounds)
                view.displayIfNeeded()
            }
            return kCVReturnSuccess
        }
        
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        CVDisplayLinkSetOutputCallback(displayLink!, displayLinkOutputCallback, UnsafeMutableRawPointer(Unmanaged.passUnretained(view).toOpaque()))
        CVDisplayLinkStart(displayLink!)
    }
}

// MARK: macOS
import Cocoa

class MyView: NSView {
    
    let draw: () -> ()
    
    init(frame frameRect: NSRect, draw: @escaping () -> ()) {
        self.draw = draw
        
        super.init(frame: frameRect)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError()
    }
    
    override var isFlipped: Bool {
        return true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        _rect = dirtyRect
        push()
        defer { pop() }
        
        draw()
    }
}
