//
//  FightView.swift
//  imstronger
//
//  Created by 이창현 on 2022/12/29.
//

import SwiftUI

struct FightView: View {
    @State private var counter: Int = 10
    @State private var done : Bool = false
    
    var body: some View {
        GeometryReader { view in
            Button(action: {
                done = true;
                counter += 1
            }, label: {
                Text(!done ? "Touch me faster than your opponent!" : "You won!!")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 32))
                    .frame(width: view.size.width,height: view.size.height,alignment: .center)
                    
            })
            .background(LinearGradient(colors: [Color.clear], startPoint: .top, endPoint: .bottom))
            //        Text("Touch screen faster than your opponent!")
            //            .bold()
            //            .font(.system(size: 32))
            .confettiCannon(counter: $counter, num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
          )
        
        
        
    }
}

struct FightView_Previews: PreviewProvider {
    static var previews: some View {
        FightView()
    }
}
