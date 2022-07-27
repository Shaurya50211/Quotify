//
//  ContentView.swift
//  Quotify
//
//  Created by Shaurya Gupta on 2022-07-27.
//

import SwiftUI

struct QuoteModel: Decodable {
    let content: String
    let author: String
}

struct ContentView: View {
    @State private var quoteData: QuoteModel?
    @State private var animateGradient = false
    var body: some View {
        ZStack {
            // MARK: - Linear Gradient Animation
            LinearGradient(colors: [.purple, .yellow], startPoint: animateGradient ? .topLeading : .bottomLeading, endPoint: animateGradient ? .bottomTrailing : .topTrailing)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
            
            // MARK: - Actual swiftUI
            
            VStack {
                ZStack {
                    Color.cyan
                        .frame(height: 350, alignment: .center)
                        .cornerRadius(20)
                        .padding()
                        .shadow(color: .gray, radius: 20)
                    VStack (alignment: .leading){
                        HStack {
                        Text(quoteData?.content ?? "Press the button below")
                            .fontWeight(.light)
                            .font(.title2)
                            .padding()
                            Image(systemName: "arrow.down")
                                .font(.largeTitle)
                        }
                        Text(quoteData?.author ?? "")
                            .fontWeight(.semibold)
                            .padding()
                            .font(.subheadline)
                    }
                    .frame(height: 350, alignment: .leading)
                    .foregroundColor(.white)
                }
                
                
                
                Button(action: {
                    loadData()
                }) {
                    ZStack {
                        LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
                            .frame(height: 50)
                            .cornerRadius(5)
                            .padding()
                        Text("Quotify Me!")
                            .font(.title)
                            .foregroundColor(.white)
                            .bold()
                    }
                }
                .frame(height: 50)
                
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    private func loadData() {
        guard let url = URL(string: "https://api.quotable.io/random") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            if let decodedData = try? JSONDecoder().decode(QuoteModel.self, from: data) {
                DispatchQueue.main.async {
                    self.quoteData = decodedData
                }
            }
        }.resume()
    }
    
}
