//
//  ColorModel.swift
//  CricleAnimation
//
//  Created by Vikalp Mishra on 17/12/22.
//

import SwiftUI
import Foundation

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

struct UIConstants {
    //LikelihoodImages
    static var LikelihoodHolder = "HolderLikelihood"
    static var LikelihoodGreenBar = "green_bar"
    static var LikelihoodPurpleBar = "purple_handle"
    static var LikelihoodOrangeBar = "orange_arrow"
    static var LossImageText = "Loss_Text"
    
    static var LikelihoodButtonShadow = Color("ButtonShadow")
    static var Azul = Color("Azul1")
    static var FadedBlue = Color("FadedBlue1")
    static var Tealishgreen = Color("Tealishgreen1")
    
    static var TopCircle1 = Color("TopCircle1")
    static var TopCircle2 = Color("TopCircle2")
    static var TopCircle3 = Color("TopCircle3")
    static var TopCircle4 = Color("TopCircle4")
    static var TopCircle5 = Color("TopCircle5")
    static var TopCircle6 = Color("TopCircle6")
    static var TopCircle7 = Color("TopCircle7")
    static var TopCircle8 = Color("TopCircle8")
    
    static var BottomCircle1 = Color("BottomCircle1")
    static var BottomCircle2 = Color("BottomCircle2")
    static var BottomCircle3 = Color("BottomCircle3")
    static var BottomCircle4 = Color("BottomCircle4")
    static var BottomCircle5 = Color("BottomCircle5")
    static var BottomCircle6 = Color("BottomCircle6")
    static var BottomCircle7 = Color("BottomCircle7")
    static var BottomCircle8 = Color("BottomCircle8")
    
    static var CircleBackgroundColor = Color("CircleBackgroundColor")
    static var StripeColor = Color("StripeColor")
    
    static func drawTextImage(text: String, inflection: CGFloat, size: CGSize,isForLoss: Bool = false) -> UIImage {
        // Create a format for the renderer to set the scale to 1
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        // Create the renderer
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        
        // Ask the renderer to create an image
        let image = renderer.image { rendererContext in
          let context = rendererContext.cgContext

          // Split the string in characters and convert them to NSString so
          // we can leverage .size and .draw method
          let chars = text.map { String($0) as NSString }
          let nsText = text as NSString
            
            let attributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.red
          ]
          
          // Compute the size of the text. We need the width to compute the radius of the circle
          let textSize = nsText.size(withAttributes: attributes)

          // Get the center of the space where we need to draw the text
          let center = CGPoint(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2
          )

          // Handle the edge case where we don't want a curved text. Just draw the nsText
          guard inflection != 0 else {
            nsText.draw(at: center, withAttributes: attributes)
            return
          }
          
          // Create a variable that works as accumulator to draw the single letters
          var startPoint = center
          
          // Compute the second side of the triangle. It depends on how curved we want the text.
          let c2 = abs(inflection * textSize.width / 2)
          
          // Compute the radius of the circumference
          let r = sqrt(pow(textSize.width / 2, 2) + pow(c2, 2))

          // Start drawinf the single characters
          for c in chars {
            // Save the current state of the context
            context.saveGState()

            // Compute the size of the letter to draw
            let cSize = c.size(withAttributes: attributes)
            
            // Compute the leftmost x-coordinate of the letter.
            // we need to subtract half of the text width to make sure that the center
            // is in the same x-coordinate of the center of the text we want to draw
            let x = (startPoint.x - center.x) - textSize.width/2
            // Compute the y-coordinate. It is multiplied by the inflection to ensure a smooth behavior
            let y = inflection * sqrt(pow(r, 2)-pow(x, 2))

            // Compute the mid point of the letter, we need this to position the context
            // correctly before drawing the letter
            let xm = (startPoint.x + cSize.width/2 - center.x) - textSize.width / 2
            let ym = inflection * sqrt(pow(r, 2)-pow(xm, 2))
            
            // Compute the rightmost point of the letter
            let x2 = ((startPoint.x + cSize.width) - center.x) - textSize.width / 2
            let y2 = inflection * sqrt(pow(r, 2)-pow(x2, 2))

            // Compute the slope and the rotation
            let m = (y2 - y) / (x2 - x)
            let theta: CGFloat = atan(m)

            // Compute the y position for the letter.
            // from the center of the screen, we need to move by the `ym` value of the letter
            // and we need to subtract how much we moved the center of the circumference.
            // If we do not add the `- inflection * c2`, we are basically keeping the
            // center of the circle in the center of our paper. Therefore, the text will move
            // up or down. Instead, we want to keep it in the middle of the view.
            startPoint.y = center.y + ym - inflection * c2

            // First, lets move the context so that it is centered in the letter.
            context.translateBy(
              x: startPoint.x + cSize.width/2,
              y: startPoint.y + cSize.height/2
            )
            
            // Rotate the paper around the center of the letter
            context.rotate(by: theta)

            // Draw the letter. We need to draw the letter at `(-cSize.width/2, -cSize.height/2)` because
            // CoreGraphics draws the letter from their top left corner.
            c.draw(
              at: .init(
                x: -cSize.width/2,
                y: -cSize.height/2
              ),
              withAttributes: attributes)
            
            // Update the accumulator so that we move on the x axis to render the next letter.
            startPoint.x = startPoint.x + cSize.width

            // Restore the context
            context.restoreGState()
          }
        }
        return image
      }
    
    // `c1` is the first side of the triangle
    // `c2` is the second side
    // The function returns the hypotenuse
    func radius(c1: CGFloat, c2: CGFloat) -> CGFloat {
      return sqrt(pow(c1, 2) + pow(c2, 2))
    }

    // `x` is the x-coordinate of the letter
    // `r` is the radius of the circle over which we want to draw the text
    // The function returns the y-coordinate
    func halfCircle(x: CGFloat, r: CGFloat) -> CGFloat {
      // r^2 = x^2 + y^2
      // r^2 - x^2 = y^2
      // y = sqrt(r^2 - x^2)
      return sqrt(pow(r, 2)-pow(x, 2))
    }
}

extension View {
    func getTopColors() -> [Color] {
        return [UIConstants.TopCircle1,UIConstants.TopCircle2,UIConstants.TopCircle3,UIConstants.TopCircle4,UIConstants.TopCircle5,UIConstants.TopCircle6,UIConstants.TopCircle7,UIConstants.TopCircle8]
    }
    
    func getBottomColors() -> [Color] {
        [UIConstants.BottomCircle1,UIConstants.BottomCircle2,UIConstants.BottomCircle3,UIConstants.BottomCircle4,UIConstants.BottomCircle5,UIConstants.BottomCircle6,UIConstants.BottomCircle7,UIConstants.BottomCircle8]
    }
    
    func colorMix(percent: Int) -> Color {
        let p = Double(percent)
        let tempG = (100.0-p)/100
        let g: Double = tempG < 0 ? 0 : tempG
        let tempR = 1+(p-100.0)/100.0
        let r: Double = tempR < 0 ? 0 : tempR
        return Color.init(red: r, green: g, blue: 0)
    }
}
