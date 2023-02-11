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
    @GestureState private var dragState = DragState.inactive
    
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
    // MARK: - Drag States
    enum DragState {
        case inactive
        case pressing
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        var isDragging: Bool {
            switch self {
            case .dragging:
                return true
            case .pressing, .inactive:
                return false
            }
        }
        var isPressing: Bool {
            switch self {
            case .pressing, .dragging:
                    return true
            case .inactive:
                return false
            }
        }
    }
    
    
    var body: some View {
        VStack {
            // MARK: - Header
            HeaderView(showGuideView: $showGuide, showInfoView: $showInfo)
                .opacity(dragState.isDragging ? 0.0 : 1.0)
                .animation(.default)
            Spacer()
            // MARK: - Cards
            ZStack{
                ForEach(cardViews) {cardView in
                    cardView
                        .zIndex(self.isTopCard(cardView: cardView) ? 1 : 0)
                        .overlay(
                            ZStack{
                                // MARK: - Xmark
                                Image(systemName: "x.circle")
                                    .foregroundColor(.white)
                                    .font(.system(size: 128))
                                    .shadow(color:Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)), radius: 12, x: 0, y: 0)
                            }
                        )
                        .offset(x: self.isTopCard(cardView: cardView) ?  self.dragState.translation.width : 0, y: self.isTopCard(cardView: cardView) ?  self.dragState.translation.height : 0)
                        .animation(.interpolatingSpring(stiffness: 120, damping: 120))
                        .scaleEffect(self.dragState.isDragging && self.isTopCard(cardView: cardView) ? 0.85 : 1)
                        .rotationEffect(Angle(degrees: self.isTopCard(cardView: cardView) ? Double(self.dragState.translation.width/12) : 0))
                        .gesture(LongPressGesture(minimumDuration: 0.01)
                            .sequenced(before: DragGesture())
                        .updating(self.$dragState, body: { (value, state, transaction) in
                          switch value {
                          case .first(true):
                            state = .pressing
                          case .second(true, let drag):
                            state = .dragging(translation: drag?.translation ?? .zero)
                          default:
                            break
                          }
                        }))
                }
            }
            .padding(.horizontal)
            
            
            Spacer()
            // MARK: - Footer
            FooterView(showBookingAlert: $showAlert)
                .opacity(dragState.isDragging ? 0.0 : 1.0)
                .animation(.default)
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
