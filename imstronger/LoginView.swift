//
//  LoginView.swift
//  imstronger
//
//  Created by 이창현 on 2022/12/30.
//
import Alamofire
import SwiftyJSON
import SwiftUI

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var showViewController: Bool = false

    
    var body: some View {
        VStack {
            Text("💪")
                .font(.largeTitle)
                .padding(.bottom, 20)
            Text("i'm Stronger")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom,20)
            
            TextField("Username", text: $username)
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            SecureField("Password", text: $password)
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            Button("Login") {
                AF.request("http://158.247.236.61:3000/auth/login",method: .post,parameters:
                            ["username": username,
                             "password":password]).responseJSON { json in
                    let json = (JSON(json.data))
                    let accessToken = json["accessToken"].stringValue
                    
                    if !accessToken.isEmpty {
                        token = accessToken
                        showViewController.toggle()
                    }
                }
            }
        }.fullScreenCover(isPresented: $showViewController, content: {
            ContentView()
        })
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
