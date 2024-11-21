//
//  MainFile.swift
//  CryptoApp
//
//  Created by Алексей Зарицький on 09/04/2024.
//



import SwiftUI

struct MainFile: View {
    let iconColor = Color(hex: "FF2CDF") // Assuming you have a Color initializer extension
    @State private var pressed = [false, false, false]
    @State private var isPressed = false
    @State private var coins: [CoinModel] = []
    @State private var bitcoin: CoinModel?
    @State private var binanceCoin: CoinModel?
    @State private var dogecoin: CoinModel?
    @State private var ethereum: CoinModel?
    @State private var showingCryptoList = false
    
    var body: some View {
        ZStack {

            Color.white
            .edgesIgnoringSafeArea(.all)

            NoiseView()
                .edgesIgnoringSafeArea(.all)
            
            HStack {
                // Info Button on the left side
                Button(action: {
                    // Action for info button
                }) {
                    Image(systemName: "info")
                        .foregroundColor(.black)  // Icon color
                        .font(.system(size: 22, weight: .regular))  // Icon size and weight
                        .frame(width: 55, height: 55)  // Frame for the circular area
                        .background(Color.white)  // Background color of the circle
                        .clipShape(Circle())  // Making the background a circle
                        .shadow(color: .gray, radius: 3, x: 0, y: 2)  // Shadow settings
                }
                .padding(.leading, 25)  // Padding from the left side of the screen

                Spacer()  // Pushes the buttons to the edges of the screen

                // Profile Button on the right side
                Button(action: {
                    // Action for profile button
                }) {
                    Image(systemName: "person.crop.circle")
                        .foregroundColor(.black)  // Icon color
                        .font(.system(size: 22, weight: .regular))  // Icon size and weight
                        .frame(width: 55, height: 55)  // Frame for the circular area
                        .background(Color.white)  // Background color of the circle
                        .clipShape(Circle())  // Making the background a circle
                        .shadow(color: .gray, radius: 3, x: 0, y: 2)  // Shadow settings
                }
                .padding(.trailing, 25)  // Padding from the right side of the screen
            }
            .padding(.bottom,600)

            
            VStack(alignment: .center) {
                        VStack {
                            Text("avaliable balance")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
            
                            Text("7200 $")
                                .font(.system(size: 55))
                                .fontWeight(.semibold)
                                .opacity(0.5)
                                .padding(.top,1)
                        }
                        .padding(.bottom,10)
            
                        Button(action: {
                                  
                               }) {
                                   Text("currency")
                                       .foregroundColor(.black)
                                       .background(
                                           RoundedRectangle(cornerRadius: 15)
                                               .fill(Color.white)
                                               .frame(width: 140, height: 35)
                                               .shadow(color: .gray, radius: 3, x: 0, y: 2)
                                       )
                               }
                               .scaleEffect(isPressed ? 0.96 : 1) // Slight scale down effect
                               .opacity(isPressed ? 0.6 : 1) // Fading effect when pressed
                               .offset(y: isPressed ? -5 : 0) // Move upwards when pressed
                               .animation(.easeOut(duration: 0.2), value: isPressed)
            
                               .padding(.top,2)
                               
            
                        //Font livic
                        HStack(spacing: 30) {
                                    // Send Button with Label
                                    VStack {
                                        Button(action: {
                                           
                                        }) {
                                            Image(systemName: "paperplane.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(.black)
                                                .frame(width: 55, height: 55)
                                                .background(Color.white) // Background color of the button
                                                .clipShape(Circle())
                                                .shadow(color: .gray, radius: 3, x: 0, y: 3)
                                                .scaleEffect(pressed[0] ? 1.1 : 1)
                                                .animation(.easeInOut(duration: 0.2), value: pressed[0])
                                        }
                                        Text("Send")
                                            .foregroundColor(.black)
                                    }
            
                                    // Receive Button with Label
                                    VStack {
                                        Button(action: {
                                            
                                        }) {
                                            Image(systemName: "tray.and.arrow.down.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(.black)
                                                .frame(width: 55, height: 55)
                                            .background(Color.white) // Background color of the button
                                            .clipShape(Circle())
                                            .shadow(color: .gray, radius: 3, x: 0, y: 3)
                                                .scaleEffect(pressed[1] ? 1.1 : 1)
                                                .animation(.easeInOut(duration: 0.2), value: pressed[1])
                                        }
                                        Text("Receive")
                                            .foregroundColor(.black)
                                    }
            
                                    // Buy Button with Label
                                    VStack {
                                        Button(action: {
                                           
                                        }) {
                                            Image(systemName: "cart.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(.black)
                                                .frame(width: 55, height: 55)
                                            .background(Color.white) // Background color of the button
                                            .clipShape(Circle())
                                            .shadow(color: .gray, radius: 3, x: 0, y: 3)
                                                .scaleEffect(pressed[2] ? 1.1 : 1)
                                                .animation(.easeInOut(duration: 0.2), value: pressed[2])
                                        }
                                        Text("Buy")
                                            .foregroundColor(.black)
                                    }
                                }
                        .padding(.top,30)
                            }
                    .padding(.bottom,220)
            VStack {
                Text("Crypto")
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                    .padding(.top,40)
                    .padding(.trailing,250)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center) {
                        
                        if let binanceCoin = binanceCoin {
                            cryptoView(coin: binanceCoin)
                        }
                        
                        if let bitcoin = bitcoin {
                            cryptoView(coin: bitcoin)
                        }
                        
                        if let dogecoin = dogecoin {
                            cryptoView(coin: dogecoin)
                        }
                        
                        if let ethereum = ethereum {
                            cryptoView(coin: ethereum)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(height: 150)
                    .padding(.horizontal,20)
                    
                }
               
                            Button(action: {
                                showingCryptoList = true
                                   }) {
                                       Text("all crypto")
                                           .font(.system(size: 21))
                                           .foregroundColor(.black)
                                           .background(
                                               RoundedRectangle(cornerRadius: 15)
                                                   .fill(Color.white)
                                                   .frame(width: 160, height: 50)
                                                   .shadow(color: .gray, radius: 3, x: 0, y: 2)
                                           )
                                   }
                                   .scaleEffect(isPressed ? 0.96 : 1) // Slight scale down effect
                                   .opacity(isPressed ? 0.6 : 1) // Fading effect when pressed
                                   .offset(y: isPressed ? -5 : 0) // Move upwards when pressed
                                   .animation(.easeOut(duration: 0.2), value: isPressed)
                                   .padding(.top,10)
                                   .padding(.trailing,200)
                
                                   .fullScreenCover(isPresented: $showingCryptoList) {
                                       CryptoListView()
                                                   }
            }
            .padding(.bottom,220)
            
          

       
            
           
            
            .background(
                Color(.white)
                           .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 50))
                           .shadow(color: .gray, radius: 10, x: 0, y: 0)
                           .frame(width: 400,height: 500)
                       )
                           .padding(.top,600)
        }
        .onAppear {
                    fetchCoins()
                }
    }

    // MARK: - Functions
    private func fetchCoins() {
            NetworkManager().fetchCoinData { fetchedCoins in
                self.coins = fetchedCoins
                // Separating coins after fetching
                self.bitcoin = coins.first(where: { $0.id == "bitcoin" })
                self.ethereum = coins.first(where: { $0.id == "ethereum" })
                           self.binanceCoin = coins.first(where: { $0.id == "binancecoin" })
                           self.dogecoin = coins.first(where: { $0.id == "dogecoin" })
                // Assign more coins similarly if needed
            }
        }
    
    @ViewBuilder
    func cryptoView(coin: CoinModel) -> some View {
        VStack {
            AsyncImage(url: URL(string: coin.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            } placeholder: {
                ProgressView()
            }
            
            Text("\(coin.name) (\(coin.symbol.uppercased()))")
                .font(.headline)
                .foregroundColor(.black)
            
            Text("$\(coin.currentPrice, specifier: "%.2f")")
                .font(.title)
                .foregroundColor(.black)
        }
        .padding()
        .background(Color.white) // Set background to white
        .cornerRadius(10)
        .shadow(color: .gray, radius: 3, x: 0, y: 3)
    }

}


     struct NoiseView: View {
         var body: some View {
             Canvas { context, size in
                 for _ in 0..<Int(size.width * size.height / 10) {
                     let point = CGPoint(
                         x: .random(in: 0..<size.width),
                         y: .random(in: 0..<size.height)
                     )
                     context.fill(
                         Path(CGRect(origin: point, size: CGSize(width: 1, height: 1))),
                         with: .color(Color.white.opacity(0.01)) // Reduced opacity for subtler noise
                     )
                 }
             }
         }
     }

     extension Color {
         init(hex: String) {
             let scanner = Scanner(string: hex)
             _ = scanner.scanString("#")

             var rgbValue: UInt64 = 0
             scanner.scanHexInt64(&rgbValue)

             let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
             let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
             let b = Double(rgbValue & 0x0000FF) / 255.0

             self.init(red: r, green: g, blue: b)
         }
     }

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}


#Preview {
    MainFile()
}
