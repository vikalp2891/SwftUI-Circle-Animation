//
//  GaugeView.swift
//  CricleAnimation
//
//  Created by Vikalp Mishra on 17/12/22.
//

import SwiftUI

struct GaugeView: View {
    
    func tickText(at tick: Int, text: String) -> some View {
        let startAngle = coveredRadius/2 * -1 + 90
        let stepper = coveredRadius/Double(tickCount)
        let rotation = startAngle + stepper * Double(tick)
        return VStack(alignment: .center, spacing: -5) {
            VStack {
                let val = (2000 * 10) / 100
                let arrPrices = ["₹\(2000)","₹\(val*9)","₹\(val*8)","₹\(val*7)","₹\(val*6)","₹\(val*5)","₹\(val*4)","₹\(val*3)","₹\(val*2)","₹\(val)","₹0"]
                if tick % 2 == 0 {
                    Text(arrPrices[tick])
                        .foregroundColor(Color.white)
                        .font(Font(UIFont.boldSystemFont(ofSize: 9.3)))
                        .rotationEffect(.init(degrees: -1 * rotation), anchor: .center)
                        .offset(x: 115, y: 0)
                        .rotationEffect(Angle.degrees(rotation))
                }
            }
            
            if tick % 2 == 0 {
                Text(["0%","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"][tick])
                    .foregroundColor(Color.white)
                    .font(Font(UIFont.boldSystemFont(ofSize: 9.3)))
                    .rotationEffect(.init(degrees: -1 * rotation), anchor: .center)
                    .offset(x: -115, y: 0)
                    .rotationEffect(Angle.degrees(rotation))
            }
        }
        
    }
    
    let coveredRadius: Double // 0 - 360°
    let maxValue: Int
    let steperSplit: Int
    
    private var tickCount: Int {
        return maxValue/steperSplit
    }
    
    var value: Double
    var body: some View {
        ZStack {
            
            ForEach(0..<(tickCount + 1), id: \.self) { tick in
                self.tickText(at: tick, text: getAmountArray()[tick])
            }
        }
    }
    
    func getAmountArray() -> [String] {
        let val = (2000 * 10) / 100
        return ["₹\(2000)","₹\(val*9)","₹\(val*8)","₹\(val*7)","₹\(val*6)","₹\(val*5)","₹\(val*4)","₹\(val*3)","₹\(val*2)","₹\(val)","₹0"]
    }
    
}
