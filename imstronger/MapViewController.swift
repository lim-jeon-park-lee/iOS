import GoogleMaps
import SwiftUI
import UIKit
import SwiftyJSON
import Alamofire

class MapViewController: UIViewController,GMSMapViewDelegate {
    
    let map = GMSMapView(frame: .zero)
    var checkedChallenges: [String] = []
    
    override func loadView() {
        super.loadView()
        self.view = map
        map.delegate = self
        
        _ = Timer.scheduledTimer(timeInterval: 2.0,
                                 target: self,
                                 selector: #selector(execute),
                                 userInfo: nil,
                                 repeats: true)
    }
    
    @objc func execute() {
        
        AF.request("http://158.247.236.61:3000/status",headers: [.authorization(bearerToken: token)]).responseJSON(completionHandler: { json in
            let json = JSON(json.data)
            
            let currentPlayingGame = json["currentPlayingGame"]
            let isCurrentPlaying = !currentPlayingGame.isEmpty
            
            let receivedChallenges = json["receivedChallenges"].arrayValue
            let isReceived = receivedChallenges.count != 0
            let latestedId = receivedChallenges.first?["id"].stringValue ?? ""
            
            if !self.isBeingPresented && isCurrentPlaying { //게임 시작
                var swiftUIView = FightView(id: currentPlayingGame["id"].stringValue)
                swiftUIView.presentingVC = self
                let viewCtrl = UIHostingController(rootView: swiftUIView)
                viewCtrl.modalPresentationStyle = .fullScreen
                
                self.present(viewCtrl, animated: true)
            } else if !self.isBeingPresented && isReceived && !self.checkedChallenges.contains(latestedId) { //챌린지 받았을 경우
                self.checkedChallenges.append(latestedId)
                
                let alert = UIAlertController(title: "챌린지 요청이 왔습니다!", message: "'팔씨름 한판 뜨쉴?'", preferredStyle: .alert)
                alert.addAction(.init(title: "확인", style: .default,handler: { _ in

                    AF.request("http://158.247.236.61:3000/challenges/"+latestedId+"/accept",method: .post, headers:
                                [.authorization(bearerToken: token)]).responseJSON { json in
//                        let swiftUIView = FightView(id: latestedId) {
//                            self.dismiss(animated: true)
//                        }
//                        let viewCtrl = UIHostingController(rootView: swiftUIView)
//
//                        self.present(viewCtrl, animated: true)
                    }
                    
                }))
                alert.addAction(.init(title: "취소", style: .destructive))
                
                self.present(alert, animated: true)
                
            }
        })
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        AF.request("http://158.247.236.61:3000/challenges",method: .post,parameters: ["userId": 1], headers:
                    [.authorization(bearerToken: token)]).responseJSON { json in
            let json = (JSON(json.data))
            let alert = UIAlertController(title: "팔씨름 한판뜨자!", message: "상대방의 응답을 기다리세요..", preferredStyle: .alert)
            alert.addAction(.init(title: "확인", style: .default))
            alert.addAction(.init(title: "취소", style: .destructive))
            self.present(alert, animated: true)
        }
        
        return true
    }
}

