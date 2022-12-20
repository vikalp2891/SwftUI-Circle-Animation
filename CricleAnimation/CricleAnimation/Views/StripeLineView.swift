//
//  StripeLineView.swift
//  CricleAnimation
//
//  Created by Vikalp Mishra on 17/12/22.
//

import SwiftUI
import UIKit
import CoreImage.CIFilterBuiltins

extension CGImage {

    static func generateStripePattern(
        colors: (UIColor, UIColor) = (.clear, .black),
        width: CGFloat = 6,
        ratio: CGFloat = 1) -> CGImage? {

    let context = CIContext()
    let stripes = CIFilter.stripesGenerator()
    stripes.color0 = CIColor(color: colors.0)
    stripes.color1 = CIColor(color: colors.1)
    stripes.width = Float(width)
    stripes.center = CGPoint(x: 1-width*ratio, y: 0)
    let size = CGSize(width: width, height: 1)

    guard
        let stripesImage = stripes.outputImage,
        let image = context.createCGImage(stripesImage, from: CGRect(origin: .zero, size: size))
    else { return nil }
    return image
  }
}

struct ViewStripes : ViewModifier {

    var stripeColor : Color
    var width : CGFloat
    var ratio : CGFloat
    var angle : Double
    var frameW : CGFloat
    var frameH : CGFloat
    
    func body(content: Self.Content) -> some View {
                        if let stripeCGImage = UIImage(named: "StripeBG")!.cgImage{
                        content
                                .foregroundColor(Color.clear)
                                .overlay(Rectangle().fill(ImagePaint(image: Image(decorative: stripeCGImage, scale:2.6)))
                                .frame(width: hypotenuse((frameW / 2), frameH / 2) * 2, height: hypotenuse(frameW / 2, frameH / 2) * 2)
                                     //.scaleEffect(1)
                                .rotationEffect(.degrees(angle))
                                .mask(content))
                    }
                
            }
}

extension View {

    func drawStripes(stripeColor: Color, width: CGFloat, ratio: CGFloat, angle : Double, frameW : CGFloat, frameH : CGFloat) -> some View {
        modifier(ViewStripes(stripeColor: stripeColor, width: width, ratio: ratio, angle: angle, frameW: frameW, frameH: frameH))
        
    }
}

func hypotenuse(_ a: Double, _ b: Double) -> Double {
    return (a * a + b * b).squareRoot()
}

