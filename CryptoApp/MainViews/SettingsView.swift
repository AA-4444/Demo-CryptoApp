//
//  SettingsView.swift
//  CryptoApp
//
//  Created by Алексей Зарицький on 14/04/2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // User Profile Card
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "person.circle")
                            .font(.system(size: 50))
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("User Name") // Replace with actual data binding
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Wallet ID: abc123") // Replace with actual data binding
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading,10)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 3, x: 0, y: 3)
                }
                .padding(.horizontal)
                
                // Settings Structure
                VStack(alignment: .leading, spacing: 20) {
                    

                    VStack(alignment: .leading, spacing: 10) {
                        SettingOption(title: "Account", icon: "person.crop.circle")
                        SettingOption(title: "Notifications", icon: "bell")
                        SettingOption(title: "Security", icon: "lock.shield")
                        SettingOption(title: "Help", icon: "questionmark.circle")
                        SettingOption(title: "About", icon: "info.circle")
                    }
                   
                    
                }
                .padding(.horizontal)
            }
            .padding(.top,40)
        }
    }
}

struct SettingOption: View {
    var title: String
    var icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
                .frame(width: 30, height: 30)
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 16))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray, radius: 2, x: 0, y: 2)
       
        .padding(.vertical, 5)
        
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
