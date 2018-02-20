//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport
import Foundation

PlaygroundPage.current.needsIndefiniteExecution = true

// https://github.com/CodingTrain/Rainbow-Code/blob/master/CodingChallenges/CC_74_Clock/sketch.js

Sketch.create(
setup: {
    angleMode(.degrees)
},
draw: {
    background(0.1)
    translate(200, 200)
    rota(-90)
    
    let sc = second()
    let secondAngle = map(Float(sc), 0, 60, 0, 360);
    push()
    rota(secondAngle)
    stroke(255, 100, 150)
    line(0, 0, 100, 0)
    pop()
    
    let min = minute()
    let minuteAngle = map(Float(min), 0, 60, 0, 360);
    push()
    rota(minuteAngle)
    stroke(150, 100, 255)
    line(0, 0, 75, 0)
    pop()
    
    let h = hour() % 12
    let hourAngle = map(Float(h), 0, 12, 0, 360);
    push()
    rota(hourAngle)
    stroke(150, 255, 100)
    line(0, 0, 50, 0)
    pop()
    
    stroke(255)
    point(0, 0)
})

print("Running \(Date().timeIntervalSince1970)")
