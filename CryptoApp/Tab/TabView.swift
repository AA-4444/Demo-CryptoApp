//
//  TabView.swift
//  CryptoApp
//
//  Created by Алексей Зарицький on 13/04/2024.
//
import SwiftUI

struct MainPage: View {
    @State var currentTab: Tab = .home

    var body: some View {
        VStack(spacing: 0) {
            // Main Content View
            TabView(selection: $currentTab) {
               
                TransactionView() 
                   .tag(Tab.transactions)
                
                Text("Portfolio")
                    .tag(Tab.portfolio)
                
                MainFile()
                    .tag(Tab.home)
                
                Text("Market")
                    .tag(Tab.market)
                
                SettingsView()
                    .tag(Tab.settings)
            }
             
            
            // Custom Tab Bar
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Button(action: {
                        currentTab = tab
                    }) {
                        VStack {
                            Image(systemName: tab.iconName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 22, height: 22)
                                .foregroundColor(currentTab == tab ? .black : .gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 15)
            .padding(.bottom, 15)
            .background(Color.white) // Set the background color here
            .cornerRadius(15) // Apply corner radius to the background
            .shadow(color: .gray, radius: 5, x: 0, y: 5) // Apply shadow here
            .frame(maxWidth: 350) // Ensure the frame spans the full width
        }
        .padding(.bottom, -5)
    }
}

enum Tab: String, CaseIterable {
   
    case portfolio = "Portfolio"
    case transactions = "Transactions"
    case home = "Home"
    case market = "Market"
    case settings = "Settings"

    var iconName: String {
        switch self {
        case .home: return "house"
        case .portfolio: return "briefcase"
        case .transactions: return "arrow.swap"
        case .market: return "chart.bar"
        case .settings: return "gear"
        }
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
