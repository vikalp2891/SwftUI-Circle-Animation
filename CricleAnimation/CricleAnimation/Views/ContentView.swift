//
//  ContentView.swift
//  CricleAnimation
//
//  Created by Vikalp Mishra on 17/12/22.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct LikelihoodView: View {
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image(UIConstants.LikelihoodHolder)
                    .resizable()
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .clipped()
            }
            MeterView()
        }
    }
}

struct MeterView: View {
    
    @State var profitPercentage : CGFloat = 0
    @State var profitPAmount : CGFloat = 0
    var body: some View {
        
        HStack(spacing: 1){
            
            LeftTextView()
                    .frame(maxWidth: (UIScreen.main.bounds.height * UIScreen.main.scale) == 750 ? 120 : 150, alignment: .center)
            
            Spacer()
            Meter(profitPercentage: self.$profitPercentage, profitAmount: self.$profitPAmount)
                .onAppear(){
                    withAnimation(Animation.easeInOut.speed(0.3)){
                        if self.profitPercentage != 100 {
                            self.profitPercentage = 60
                            self.profitPAmount = 1000
                        } else {
                            self.profitPercentage = 0
                        }
                    }
                }
                .padding(.bottom, 20)
                .frame(maxWidth: 300, alignment: .center)
            Spacer()
            
            ButtonView()
                    .frame(maxWidth: (UIScreen.main.bounds.height * UIScreen.main.scale) == 750 ? 185 : 230, alignment: .top)
        }.padding()
        
    }
}

//MARK: Text View
struct LeftTextView: View {
    var body: some View {
        VStack(alignment: .leading) {
            TextLabel(text: "You can add text here", color: UIConstants.FadedBlue, font: Font(UIFont.systemFont(ofSize: 15)),alignment: .leading)
        }
    }
}

//MARK: Button View
struct ButtonView : View {
    var body: some View {
        VStack(alignment: .center) {
            Button(action: {
            }, label: {
                VStack(alignment: .center) {
                    TextLabel(text: "Keep the trade ON", color: .white, font: Font(UIFont.boldSystemFont(ofSize: 14)))
                        .shadow(color: UIConstants.LikelihoodButtonShadow, radius: 5, x: 0, y: 2)
                    
                    let labelText = "Lorem ipsum"
                    
                    TextLabel(text: labelText, color: .white, font: Font(UIFont.boldSystemFont(ofSize: 9.3)))
                        .shadow(color: UIConstants.LikelihoodButtonShadow, radius: 5, x: 0, y: 2)
                }
                .frame(maxWidth: 300, alignment: .top)
            })
            .frame(height: 65)
            .frame(maxWidth: (UIScreen.main.bounds.height * UIScreen.main.scale) == 750 ? 160 : 180)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(UIConstants.Tealishgreen)
                    .shadow(color: UIConstants.LikelihoodButtonShadow, radius: 5, x: 0, y: 2))
            
            Button(action: {
            }, label: {
                VStack(alignment: .center) {
                    TextLabel(text: "Button", color: UIConstants.Azul, font: Font(UIFont.boldSystemFont(ofSize: 14)))
                }
            })
            .frame(height: 50)
            .frame(maxWidth: (UIScreen.main.bounds.height * UIScreen.main.scale) == 750 ? 160 : 180)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.clear)
                    .shadow(color: .gray, radius: 5, x: 0, y: 2))
        }
    }
}

//MARK: Text View
struct TextLabel: View {
    var text : String
    var color : Color
    var font : Font
    var alignment : Alignment = .center
    var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(color)
            .frame(width: .infinity, height: .infinity, alignment: alignment)
    }
}

//MARK: Meter View
struct Meter : View {
    @Binding var profitPercentage : CGFloat
    @Binding var profitAmount : CGFloat
    
    var body: some View{
       // let stripePattern = CGImage.generateStripePattern()
        ZStack{
            
            // Main Stroke path
            ZStack{
                Circle()
                    .trim(from: 0, to: 0.5)
                    .stroke(UIConstants.CircleBackgroundColor, lineWidth: 45)
                    .frame(width: 210, height: 210)
                
                CircleView(color: getTopColors(), size: 210, trimTo: self.setPercentage(), stroke:  StrokeStyle( lineWidth:  45, dash: [33,0]),strokeAngle: setProfitPercentageArrow())
                
            }
            .rotationEffect(.init(degrees: 180))
            
            ZStack{
                CircleView(color: [UIConstants.CircleBackgroundColor], size: 210, trimTo: 0.5, stroke: StrokeStyle( lineWidth:  45, dash: [33,0]))
                
                CircleView(color: getBottomColors(), size: 210, trimTo: self.setProfit(), stroke: StrokeStyle( lineWidth:  45, dash: [33,0]),strokeAngle: setProfitArrow())
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                   
                if self.setLeftProgressLimit() < self.setProfit() {
                    SlantCircleView(size: 210,trimFrom: self.setLeftProgressLimit(), trimTo: self.setProfit(), stroke: StrokeStyle( lineWidth:  45, dash: [33,0]))
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        .drawStripes(stripeColor: UIConstants.StripeColor, width: 2, ratio: 0, angle: -145, frameW: 210, frameH: 210)
                } else {
                    SlantCircleView(size: 210,trimFrom: self.setProfit(), trimTo: self.setLeftProgressLimit(), stroke: StrokeStyle( lineWidth:  45, dash: [33,0]))
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        .drawStripes(stripeColor: UIConstants.StripeColor, width: 2, ratio: 0, angle: -145, frameW: 210, frameH: 210)
                }
            }
            
            //Top Dashed Line
            ZStack{
                CircleView(color: [UIConstants.CircleBackgroundColor], size: 270, trimTo: 0.5, stroke: StrokeStyle( lineWidth:  3, dash: [40,3]))
                
                CircleView(color: getTopColors(), size: 270, trimTo: self.setPercentage(), stroke: StrokeStyle( lineWidth:  3, dash: [40,3]),strokeAngle: setProfitPercentageArrow())
            }.rotationEffect(.init(degrees: 180))
                .padding(.top,-2)
            
            //Bottom Dashed Line
            ZStack{
                CircleView(color: [UIConstants.CircleBackgroundColor], size: 270, trimTo: 0.5, stroke: StrokeStyle( lineWidth: 3, dash: [40,3]))
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                
                CircleView(color: getBottomColors(), size: 270, trimTo: self.setProfit(), stroke: StrokeStyle( lineWidth: 3, dash: [40,3]),strokeAngle: setProfitArrow())
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
            .padding(.top,2)
            
            //Inner Circle
            InnerCircle()
            
            // Needle
            ZStack(alignment: .top) {
                Image(UIConstants.LikelihoodPurpleBar)
                    .resizable()
                    .frame(width: 4, height: 62)
                    .rotationEffect(.init(degrees: 180))
            }
            .offset(y: -106)
            .rotationEffect(.init(degrees: -90))
            .rotationEffect(.init(degrees: self.setProfitPercentageArrow()))
            
            // Needle for progress movement
            ZStack {
                Image(uiImage: UIConstants.drawTextImage(text: "₹500", inflection: 0.18, size: CGSize(width: 270, height: 120)))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 65, alignment: .center)
                    .rotationEffect(.init(degrees: 180))
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .padding(.top, -83)
                
                Image(uiImage: UIConstants.drawTextImage(text: "    CURRENT PROFIT    ", inflection: 0.25, size: CGSize(width: 270, height: 180)))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 65, alignment: .center)
                    .rotationEffect(.init(degrees: 180))
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .padding(.top, -67)
                
                Image(UIConstants.LikelihoodOrangeBar)
                    .resizable()
                    .frame(width: 10, height: 71)
                    .rotationEffect(.init(degrees: 180))
            }
            .offset(y: -110)
            .rotationEffect(.init(degrees: 90))
            .rotationEffect(.init(degrees: self.setNeedle()))
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            
            // Needle
            ZStack(alignment: .top) {
                Image(UIConstants.LikelihoodGreenBar)
                    .resizable()
                    .frame(width: 4, height: 62)
                    .rotationEffect(.init(degrees: 180))
            }
            .offset(y: -106)
            .rotationEffect(.init(degrees: 90))
            .rotationEffect(.init(degrees: self.setProfitArrow()))
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            
            ZStack {
                GaugeView(coveredRadius: 170, maxValue: 100, steperSplit: 10, value: 30)
            }.rotationEffect(.init(degrees: 0.2))
        }
    }
    
    func setPercentage()->CGFloat{
        
        let temp = self.profitPercentage / 2
        return temp * 0.01
    }
    
    func setProfit()->CGFloat{
        
        let temp = self.profitAmount / (Double(2000)/50)
        return temp * 0.01
    }
    
    func setProfitPercentageArrow()->Double{
        
        let temp = self.profitPercentage / 100
        return Double(temp * 180)
    }
    
    func setProfitArrow()->Double{
        
        let temp = self.profitAmount / Double(2000)
        return Double(temp * 180)
    }
    
    func setNeedle()->Double{
        
        let temp = 500 / Double(2000)
        return Double(temp * 180)
    }
    
    func setLeftProgressLimit()->Double{
        let temp = 500 / Double(2000/50)
        return temp * 0.01
    }
}

//MARK: Inner Circle
struct InnerCircle: View {
    var body: some View {
        ZStack{
            CircleView(color: [getTopColors().last!], size: 150, trimTo: 0.5, stroke: StrokeStyle( lineWidth: 2, dash: [50,0]))
                .rotationEffect(.init(degrees: 180))
            VStack{
                VStack{
                    TextLabel(text: "80%", color: getTopColors().last!, font: Font(UIFont.boldSystemFont(ofSize: 31)))
                        .frame(width: 200, height: 20, alignment: .center)
                        .padding(.top,4)
                    
                    TextLabel(text: "LIKELIHOOD", color: getTopColors().last!, font: Font(UIFont.boldSystemFont(ofSize: 10)))
//                        .frame(width: 200, height: 5, alignment: .center)
                        .padding(.top,-4)
                }
                VStack{
                    TextLabel(text: "OF REACHING", color: UIConstants.FadedBlue, font: Font(UIFont.boldSystemFont(ofSize: 10)))
                        .frame(width: 200, height: 5, alignment: .center)
                        .padding(.top, -3)
                }
                VStack{
                    TextLabel(text: "₹200", color: getBottomColors().last!, font: Font(UIFont.boldSystemFont(ofSize: 31)))
                        .frame(width: 200, height: 20, alignment: .center)
                        .padding(.top,6)
                    
                    TextLabel(text: "PROFIT", color: getBottomColors().last!, font: Font(UIFont.boldSystemFont(ofSize: 10)))
//                    .frame(width: 200, height: 0, alignment: .center)
                        .padding(.top,-4)
                }
            }
        }
        
        ZStack {
            CircleView(color: [getBottomColors().last!], size: 150, trimTo: 0.5, stroke: StrokeStyle( lineWidth: 2, dash: [50,0]))
            
            Image(UIConstants.LossImageText)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 70, alignment: .center)
                .padding(.top, 115)
        }
    }
}

//MARK: Circle View
struct CircleView: View {
    var color : [Color]
    var size : CGFloat
    var trimFrom : CGFloat = 0.0
    var trimTo : CGFloat
    var stroke : StrokeStyle
    var strokeAngle : CGFloat = 180
    var body: some View {
        Circle()
            .trim(from: trimFrom, to: trimTo)
            .stroke(style: stroke)
            .fill(
                AngularGradient(gradient: Gradient(colors: color), center: .leading,startAngle: .degrees(0), endAngle: .degrees(strokeAngle))
            )
            .frame(width: size, height: size)
    }
}


struct SlantCircleView: View {
    var size : CGFloat
    var trimFrom : CGFloat = 0.0
    var trimTo : CGFloat
    var stroke : StrokeStyle
    var strokeAngle : CGFloat = 180
    var body: some View {
        Circle()
            .trim(from: trimFrom, to: trimTo)
            .stroke(style: stroke)
            .frame(width: size, height: size)
    }
}
