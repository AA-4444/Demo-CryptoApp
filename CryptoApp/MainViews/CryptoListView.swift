//
//  CryptoListView.swift
//  CryptoApp
//
//  Created by Алексей Зарицький on 13/04/2024.
//

import SwiftUI
import Charts
import DGCharts


struct CryptoListView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var coins: [CoinModel] = []
    @State private var showingDetail = false
    @State private var selectedCoin: CoinModel?
    @State private var searchText = ""
    
    var filteredCoins: [CoinModel] {
          if searchText.isEmpty {
              return coins
          } else {
              return coins.filter {
                  $0.name.localizedCaseInsensitiveContains(searchText) ||
                  $0.symbol.localizedCaseInsensitiveContains(searchText)
              }
          }
      }

    var body: some View {
        ScrollView(showsIndicators:false) {
            
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
            }) {
                    Image(systemName: "chevron.backward")
                    .foregroundColor(.black)  // Icon color
                            .font(.system(size: 16, weight: .regular))  // Icon size and weight
                            .frame(width: 40, height: 40)  // Frame for the circular area
                            .background(Color.white)  // Background color of the circle
                            .clipShape(Circle())  // Making the background a circle
                            .shadow(color: .gray, radius: 3, x: 0, y: 2)  // S
                        
                }
            .padding(.leading)

               Spacer()  // Pushes content to center and edges
                
                Text("Crypto List")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                
                Spacer()  // Ensures the title stays centered

                // Invisible placeholder to balance the back button, making the title truly centered
                Image(systemName: "chevron.backward")
                    .foregroundColor(.clear)  // Invisible
                    .font(.system(size: 16, weight: .regular))
                    .frame(width: 40, height: 40)
                    .background(Color.white.opacity(0))  // No visible background
                    .clipShape(Circle())
                    .padding(.trailing)
                   
                // Search field
                              

                
            }
            
            TextField("Search...", text: $searchText)
                .padding(.vertical, 8) // Increase vertical padding for a taller text field
                   .padding(.horizontal) // Add some horizontal padding inside the text field
                   .background(Color.white) // Set the background color to white
                   .cornerRadius(8) // Set corner radius to 8
                   .shadow(color: .gray, radius: 4, x: 0, y: 2) // Apply shadow with a vertical offset
                   .padding(.horizontal, 20) // Padding around the text field to restrict its maximum width

            ForEach(filteredCoins, id: \.id) { coin in
                               Button(action: {
                                   selectedCoin = coin
                                   showingDetail = true
                               }) {
                                   CryptoRow(coin: coin)
                               }
                               .padding()
                               .background(Color.white)
                               .cornerRadius(10)
                               .shadow(color: .gray, radius: 3, x: 0, y: 3)
                               .padding(.horizontal)
                               .padding(.top, 5)
                           }
            
                        VStack {
                ForEach(coins, id: \.id) { coin in
                    Button(action: {
                        selectedCoin = coin
                           showingDetail = true
                    }) {
                        HStack {
                            // Display the coin image
                            if let imageUrl = URL(string: coin.image), let imageData = try? Data(contentsOf: imageUrl), let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .background(Color.gray)
                                    .clipShape(Circle())
                            }
                            
                            VStack(alignment: .leading) {
                                Text(coin.name + " (\(coin.symbol.uppercased()))")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text("$\(coin.currentPrice, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            
                            
                        }
                    }
                    
                    
                    
                    .padding()
                    .background(Color.white) // Set background to white
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 3, x: 0, y: 3)
                    .padding(.horizontal)
                    .padding(.top, 5)
                }
            }
            
        }
        .fullScreenCover(item: $selectedCoin) { coin in
                   CryptoDetailView(coin: coin)
               }
        .onAppear {
            fetchCoins()
        }
        .navigationBarHidden(true)
        .background(Color(.white)) // Light gray background for the entire ScrollView
      





    }

    private func fetchCoins() {
        NetworkManager().fetchCoinData { fetchedCoins in
            DispatchQueue.main.async {
                self.coins = fetchedCoins
                print("Coins fetched: \(self.coins.count)")  // Check how many coins are fetched
            }
        }
    }


}



struct CryptoListView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoListView()
    }
}



    struct CryptoRow: View {
        let coin: CoinModel
        
        var body: some View {
            HStack {
                if let imageUrl = URL(string: coin.image), let imageData = try? Data(contentsOf: imageUrl), let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .background(Color.gray)
                        .clipShape(Circle())
                }

                VStack(alignment: .leading) {
                    Text(coin.name + " (\(coin.symbol.uppercased()))")
                        .font(.headline)
                        .foregroundColor(.black)
                    Text("$\(coin.currentPrice, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
    }






struct CryptoDetailView: View {
    var coin: CoinModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTimeInterval = "1D"
    @State private var historicalData: [PricePoint] = []
    @State private var showingFullDescription = false

    var body: some View {
        ScrollView(showsIndicators:false) {
            VStack {
                
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                }) {
                        Image(systemName: "chevron.backward")
                        .foregroundColor(.black)  // Icon color
                                .font(.system(size: 16, weight: .regular))  // Icon size and weight
                                .frame(width: 40, height: 40)  // Frame for the circular area
                                .background(Color.white)  // Background color of the circle
                                .clipShape(Circle())  // Making the background a circle
                                .shadow(color: .gray, radius: 3, x: 0, y: 2)  // S
                            
                    }
                .padding(.leading)

                   Spacer()  // Pushes content to center and edges
                    
                    Text(coin.name + " (\(coin.symbol.uppercased()))")
                        .font(.largeTitle)
                        .padding()
                    
                    Spacer()  // Ensures the title stays centered

                    // Invisible placeholder to balance the back button, making the title truly centered
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.clear)  // Invisible
                        .font(.system(size: 16, weight: .regular))
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0))  // No visible background
                        .clipShape(Circle())
                        .padding(.trailing)

                    
                }
                // Displaying the image
                AsyncImage(url: URL(string: coin.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                             .scaledToFit()
                             .frame(width: 100, height: 100)
                             .clipShape(Circle())
                    case .failure(_):
                        Image(systemName: "photo")
                             .resizable()
                             .scaledToFit()
                             .frame(width: 100, height: 100)
                             .background(Color.gray)
                             .clipShape(Circle())
                    default:
                        ProgressView()
                    }
                }

//                Text(coin.name + " (\(coin.symbol.uppercased()))")
//                    .font(.largeTitle)
//                    .padding()

                Text("$\(coin.currentPrice, specifier: "%.2f")")
                    .font(.title)
                    .foregroundColor(.secondary)
                    .padding()

                Picker("Select Interval", selection: $selectedTimeInterval) {
                    Text("1D").tag("1D")
                    Text("7D").tag("7D")
                    Text("1M").tag("1M")
                    Text("1Y").tag("1Y")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedTimeInterval) { newValue in
                    fetchHistoricalData(interval: newValue)
                }

                if !historicalData.isEmpty {
                    LineView(data: historicalData.map { $0.price }, title: "Price History")
                        .frame(height: 300)
                        .background(Color.white) // Set the background color to white
                                   .cornerRadius(15) // Apply corner radius
                                   .shadow(color: .gray, radius: 5, x: 0, y: 2) // Apply shadow
                                   .padding() // Add padding to ensure the shadow is visible
                                   .frame(width: 400, height: 300)
                                  
                                    
                } else {
                    Text("Loading data...")
                        .frame(height: 300)
                }
                VStack {
                    
                    Text("Overview")
                        .font(.system(size: 35))
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .padding(.trailing,190)
                        .padding(.top,20)
                    
                    
                    // Description view
                    VStack(alignment: .leading) {
                                   // Example description text handling
                                   let descriptionText =  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                            
                                   
                                  
                                   
                                   Text(showingFullDescription ? descriptionText : String(descriptionText.prefix(100)) + "...")
                                       .font(.subheadline)
                                       .lineLimit(showingFullDescription ? nil : 3)  // Limit lines if not showing full description
                                       .animation(.easeIn)  // Smooth transition for showing more or less of the text
                                       .padding(.horizontal,30)
                                       .padding(.top,2)
                                   
                                   Button(action: {
                                       withAnimation {
                                           showingFullDescription.toggle()
                                       }
                                   }) {
                                       Text(showingFullDescription ? "Show Less" : "Show More")
                                           .font(.subheadline)
                                           .foregroundColor(.blue)
                                   }
                                   .padding(.top, 5)
                                   .padding(.leading, 30)
                               }
                         
                    
                    HStack(spacing: 60) {
                        
                        
                        VStack(alignment: .leading) {
                            Text("Current Price")
                            Text("\(coin.currentPrice, specifier: "%.2f") $")
                                .fontWeight(.semibold)
                            if let priceChangePercentage24H = coin.priceChangePercentage24H {
                                Text("\(priceChangePercentage24H, specifier: "%.2f")%")
                                    .foregroundColor(priceChangePercentage24H >= 0 ? .green : .red)
                                    .fontWeight(.semibold)
                            }
                        }
                        VStack(alignment: .leading) {
                            if let marketCap = coin.marketCap {
                                Text("Market Cap: $")
                                Text("\(formatLargeNumber(marketCap)) $")
                                    .fontWeight(.semibold)
                            }
                            if let marketCapChangePercentage24H = coin.marketCapChangePercentage24H {
                                Text("\(marketCapChangePercentage24H, specifier: "%.2f")%")
                                    .foregroundColor(marketCapChangePercentage24H >= 0 ? .green : .red)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .padding()
                    .padding(.trailing,70)
                    
                    HStack(spacing: 20) {
                                           // Buy button
                                           Button(action: {
                                               // Define what happens when the button is tapped
                                               print("Buy action triggered")
                                           }) {
                                               Text("Buy")
                                                   .fontWeight(.semibold)
                                                   .frame(minWidth: 0, maxWidth: .infinity)
                                                   .padding()
                                                   .foregroundColor(.white)
                                                   .background(Color.green)
                                                   .cornerRadius(10)
                                           }

                                           // Sell button
                                           Button(action: {
                                               // Define what happens when the button is tapped
                                               print("Sell action triggered")
                                           }) {
                                               Text("Sell")
                                                   .fontWeight(.semibold)
                                                   .frame(minWidth: 0, maxWidth: .infinity)
                                                   .padding()
                                                   .foregroundColor(.white)
                                                   .background(Color.red)
                                                   .cornerRadius(10)
                                           }
                                       }
                                       .padding(.horizontal, 20)
                                       .padding(.top, 10)
                }


                

              
            }
        }
        .onAppear {
            fetchHistoricalData(interval: selectedTimeInterval)
        }
        
    }


    private func fetchHistoricalData(interval: String) {
            // Simulated delay for fetching data
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                // Simulate data
                self.historicalData = [
                    PricePoint(date: formatter.date(from: "2024/01/01")!, price: 34.56),
                    PricePoint(date: formatter.date(from: "2024/01/02")!, price: 36.78),
                    PricePoint(date: formatter.date(from: "2024/01/03")!, price: 37.89)
                ]
            }
        }
    func formatLargeNumber(_ number: Double) -> String {
        let thousand = 1000.0
        let million = 1000_000.0
        let billion = 1000_000_000.0
        let trillion = 1000_000_000_000.0

        switch number {
        case 1_000..<1_000_000:
            return String(format: "%.1fK", number / thousand)
        case 1_000_000..<1_000_000_000:
            return String(format: "%.1fM", number / million)
        case 1_000_000_000..<1_000_000_000_000:
            return String(format: "%.1fB", number / billion)
        case number where number >= 1_000_000_000_000:
            return String(format: "%.1fT", number / trillion)
        default:
            return String(format: "%.0f", number)  // For values less than 1000
        }
    }

}

struct LineView: UIViewRepresentable {
    var data: [Double]
    var title: String

    func makeUIView(context: Context) -> LineChartView {
        let chart = LineChartView()
        chart.noDataText = "No data available"
        chart.backgroundColor = .white
        chart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0) // Adds animation
        return chart
    }

    func updateUIView(_ uiView: LineChartView, context: Context) {
        var entries = [ChartDataEntry]()
        for (index, value) in data.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: value))
        }

        let dataSet = LineChartDataSet(entries: entries, label: title)
        dataSet.colors = [NSUIColor.systemTeal] // Neon-like color
        dataSet.setCircleColor(NSUIColor.systemTeal) // Neon-like color for points
        dataSet.lineWidth = 2.5
        dataSet.circleRadius = 5.0
        dataSet.valueColors = [NSUIColor.black]
        dataSet.mode = .cubicBezier // Smooth line
        dataSet.drawFilledEnabled = true // Optional: Add a fill
        dataSet.fillColor = NSUIColor.systemTeal
        dataSet.fillAlpha = 0.5

        let data = LineChartData(dataSet: dataSet)
        uiView.data = data
    }
}


struct LineChartWrapperView: View {
    var data: [Double]
    var title: String

    var body: some View {
        LineView(data: data, title: title)
            .background(Color.white) // Set the background color to white
                       .cornerRadius(15) // Apply corner radius
                       .shadow(color: .gray, radius: 5, x: 0, y: 2) // Apply shadow
                       .padding() // Add padding to ensure the shadow is visible
                       .frame(width: 300, height: 300)
    }
}


//struct LineView: UIViewRepresentable {
//    var data: [Double]
//    var title: String
//
//    func makeUIView(context: Context) -> LineChartView {
//        let chart = LineChartView()
//        chart.noDataText = "No data available"
//        return chart
//    }
//
//    func updateUIView(_ uiView: LineChartView, context: Context) {
//        var entries = [ChartDataEntry]()
//        for (index, value) in data.enumerated() {
//            entries.append(ChartDataEntry(x: Double(index), y: value))
//        }
//
//        let dataSet = LineChartDataSet(entries: entries, label: title)
//        dataSet.colors = [NSUIColor.blue]
//        dataSet.valueColors = [NSUIColor.black]
//        let data = LineChartData(dataSet: dataSet)
//        uiView.data = data
//    }
//}

struct PricePoint: Identifiable {
    var id = UUID()
    var date: Date
    var price: Double
}
