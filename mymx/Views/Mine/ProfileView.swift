//
//  ProfileView.swift
//  mymx
//
//  Created by ice on 2024/7/10.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var modelData: ModelData
    
    @State private var phone: String = ""
    @State private var authCode: String = ""
    @Binding var showProfile: Bool
    
    var body: some View {
        VStack{
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
            HStack{
                Text(modelData.user?.name ?? "")
                    .font(.title2)
            }
            .padding()
            HStack{
                Text(modelData.user?.mail ?? "")
                    .font(.headline)
            }
            .padding()
            Button(action: {
                self.logout()
            }, label: {
                Text("退出登录")
                    .font(.headline)
                    .padding(10)
                    .padding(.horizontal)
                    .background(.red)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
        }
    }
    
    
    func logout(){
        GlobalParams.logout()
        modelData.user = nil
        UserDefaults.standard.set(nil, forKey: DataKeys.LOGIN_RESULT)
        showProfile.toggle()
    }
}

#Preview {
    ProfileView(showProfile: .constant(true))
        .environmentObject(ModelData())
}
