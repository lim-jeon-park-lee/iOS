//
//  FightView.swift
//  imstronger
//
//  Created by 이창현 on 2022/12/29.
//
import Alamofire
import SwiftUI
import SwiftyJSON

struct FightView: View {
    var id: String
    var presentingVC: UIViewController?

    @State private var counter: Int = 10
    @State private var done : Bool = false
    @State private var lose : Bool = false

    
    var body: some View {
        GeometryReader { view in
            Button(action: {
                print(id)
                if !done {
                    AF.request("http://158.247.236.61:3000/games/"+id+"/won", method: .post, headers: [.authorization(bearerToken: token)]).responseJSON { json in
                        done = true;
                    }
                }
                done = true;
                counter += 1
            }, label: {
                Text(!done ? "Touch me faster than your opponent!" : (lose ? "You lose.. 😭" : "You won!! 🤣"))
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
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                AF.request("http://158.247.236.61:3000/status",headers: [.authorization(bearerToken: token)]).responseJSON(completionHandler: { json in
                    let json = JSON(json.data)
                    
                    let currentPlayingGame = json["currentPlayingGame"]
                    let isCurrentPlaying = !currentPlayingGame.isEmpty
                    
                    let lastPlayedGame = json["lastPlayedGame"]
                    print(lastPlayedGame)

                    if !isCurrentPlaying { //게임 시작
                        if (!lastPlayedGame.isEmpty) {
                            done = true;
                        }
                        lose = !lastPlayedGame["win"].boolValue
//                        self.presentingVC?.presentedViewController?.dismiss(animated: true)
                    }
                })
            })
        }
    }
}

struct FightView_Previews: PreviewProvider {
    static var previews: some View {
        FightView(id: "0")
    }
}
