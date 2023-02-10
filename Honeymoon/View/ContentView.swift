//
//  ContentView.swift
//  Honeymoon
//
//  Created by Ege Aydemir on 10.01.2023.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @State var showAlert: Bool = false
    @State var showGuide: Bool = false
    @State var showInfo: Bool = false
    
    // MARK: - CardViews
    var cardViews: [CardView] = {
        var views = [CardView]()
        for index in 0..<2 {
            views.append(CardView(honeymoon: honeymoonData[index]))
        }
        return views
    }()
    // MARK: - Top Card
    
    private func isTopCard(cardView: CardView) -> Bool {
        guard let index = cardViews.firstIndex(where: {$0.id == cardView.id}) else {
            return false
        }
        return index == 0
    }
    
    var body: some View {
        VStack {
            // MARK: - Header
            HeaderView(showGuideView: $showGuide, showInfoView: $showInfo)
            Spacer()
            // MARK: - Card
            ZStack{
                ForEach(cardViews) {cardView in
                    cardView
                        .zIndex(self.isTopCard(cardView: cardView) ? 1:0)
                    
                }
            }
            .padding(.horizontal)
            
            
            Spacer()
            // MARK: - Footer
            FooterView(showBookingAlert: $showAlert)
        }
        .alert(isPresented: $showAlert){
            Alert(title: Text("SUCCESS"),
            message: Text("Wishing a lovely and most precious of the times together for the amazing couple."),
            dismissButton: .default(Text("Happy Honeymoon!")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
