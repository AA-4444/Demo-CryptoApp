//
//  Transactions.swift
//  CryptoApp
//
//  Created by Алексей Зарицький on 20/04/2024.
//

import SwiftUI



struct TransactionView: View {
    @State private var coins: [CoinModel] = []
    @State private var isLoading = true

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)  // Ensure the background color fills all edges
                

            VStack {
                Text("Transactions")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    .padding(.top, 20)  // Adjust top padding

                if isLoading {
                    Spacer()
                    ProgressView("Loading...")
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 10) {
                            ForEach(coins, id: \.id) { coin in
                                TransactionCard(coin: coin, transactionType: "Received", transactionAmount: 1.5)
                                TransactionCard(coin: coin, transactionType: "Bought", transactionAmount: 2.0)
                                TransactionCard(coin: coin, transactionType: "Sold", transactionAmount: 3.0)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top,10)
                        .padding(.bottom,10)
                       
                    }
                    .frame(maxHeight: .infinity)
                    
                }
               
                Button(action: {
                            // Handle button action here
                        }) {
                            Text("Clear History")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .padding(.horizontal,100)
                        }
                
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.red)
                                .shadow(color: .gray, radius: 5, x: 0, y: 5)
                        )
              
                        
                        }
            
        
                   
                    }
        .onAppear {
            loadCoins()
        }
    }

    private func loadCoins() {
        NetworkManager().fetchCoinData { fetchedCoins in
            self.coins = fetchedCoins
            self.isLoading = false
        }
    }
}


struct TransactionCard: View {
    var coin: CoinModel
    var transactionType: String
    var transactionAmount: Double

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: coin.image)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 50)
            .cornerRadius(25)

            VStack(alignment: .leading) {
                Text(coin.name)
                    .font(.headline)
                Text(String(format: "%.2f USD", coin.currentPrice))
                    .font(.subheadline)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text(transactionType)
                    .foregroundColor(colorForType(transactionType))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                Text("\(transactionAmount) \(coin.symbol.uppercased())")
                    .font(.caption)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }

    private func colorForType(_ type: String) -> Color {
        switch type.lowercased() {
        case "buy", "bought":
            return .green
        case "sell", "sold":
            return .red
        case "receive", "received":
            return .blue
        default:
            return .gray
        }
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView()
    }
}
