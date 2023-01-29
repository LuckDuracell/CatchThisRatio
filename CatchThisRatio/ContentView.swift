//
//  ContentView.swift
//  CatchThisRatio
//
//  Created by Luke Drushell on 1/28/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var mapsModel = MapsModel()
    
    @State var winRatio = ""
    
    @State var showReset = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.indigo, .purple], startPoint: .leading, endPoint: .trailing)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(Rectangle().edgesIgnoringSafeArea(.all).background(.ultraThinMaterial).foregroundColor(.clear))
                ScrollView {
                    HStack {
                        Text("W/R: \(winRatio)")
                        Spacer()
                        Text("MODE: CTF")
                    } .font(.title.bold())
                        .padding(.horizontal, 25)
                        .gradientOverlay(height: 40, colors: [Color("vibrantWhite"), Color("vibrantPink")], startPoint: .leading, endPoint: .trailing)
                        .padding(.top)
                    Divider()
                        .opacity(0)
                        .frame(height: 4)
                        .background(
                            LinearGradient(colors: [Color("vibrantWhite"), Color("vibrantPink")], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .cornerRadius(15)
                        .padding()
                    ForEach($mapsModel.maps, id: \.self, content: { $map in
                        NavigationLink(destination: {
                            UpdateMap(map: $map, mapsModel: $mapsModel)
                        }, label: {
                            Image(map.image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 130)
                                .clipped()
                                .overlay(content: {
                                    Rectangle()
                                        .background(.ultraThinMaterial.opacity(0.6))
                                        .foregroundColor(.clear)
                                })
                                .overlay(alignment: .bottom, content: {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(map.title)
                                            if map.subtitle != "" { Text(map.subtitle) }
                                        }
                                        .font(.title.bold())
                                        .padding(5)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        Spacer()
                                        Text("W/R: " + calculateWR(map.wins, map.losses))
                                            .font(.largeTitle.bold())
                                            .padding()
                                    } .gradientOverlay(height: 80, colors: [Color("vibrantWhite"), Color.indigo.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                                })
                                .overlay(alignment: .topTrailing, content: {
                                    Image(systemName: "chevron.right")
                                        .font(.headline.bold())
                                        .padding()
                                        .foregroundColor(.white)
                                })
                                .padding(.vertical, -4)
                        })
                    })
                    
                    Button {
                        showReset.toggle()
                    } label: {
                        Text("Reset Counts")
                            .font(.subheadline.bold())
                            .gradientOverlay(height: 30, colors: [.purple.opacity(0.7), .pink.opacity(0.6)], startPoint: .leading, endPoint: .trailing)
                    } .padding()
                    
                }
            } .colorScheme(.dark)
        } .onAppear(perform: {
            var wins = 0
            var losses = 0
            for map in mapsModel.maps {
                wins += map.wins
                losses += map.losses
            }
            winRatio = calculateWR(wins, losses)
        })
        .alert(isPresented: $showReset) {
            Alert(title: Text("Clear All Data"), primaryButton: .destructive(Text("Clear All"), action: {
                mapsModel.maps = [Map(wins: 0, losses: 0, title: "Busan", subtitle: "Downtown", image: "busan downtown"), Map(wins: 0, losses: 0, title: "Illios", subtitle: "Ruins", image: "illios ruins"), Map(wins: 0, losses: 0, title: "Busan", subtitle: "Sanctuary", image: "busan sanctuary"), Map(wins: 0, losses: 0, title: "Ayutthaya", subtitle: "", image: "ayutthaya"), Map(wins: 0, losses: 0, title: "Oasis", subtitle: "University", image: "oasis university"), Map(wins: 0, losses: 0, title: "Lijiang", subtitle: "Garden", image: "lijiang garden")]
                mapsModel.save()
                winRatio = "N/A"
            }), secondaryButton: .cancel())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func calculateWR(_ wins: Int, _ losses: Int) -> String {
    if losses == 0 && wins == 0 {
        return "N/A"
    } else {
        let wr: Double = Double(wins) / (Double(losses) + Double(wins))
        return wr.doubleDigits()
    }
}

extension Double {
    func doubleDigits() -> String {
        let multiplied = 100 * self
        let simplified = multiplied.rounded()
        return (simplified / 100).formatted()
    }
}

struct GradientText: ViewModifier {
    
    let setHeight: CGFloat
    let colors: [Color]
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    
    func body(content: Content) -> some View {
        LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
                .mask(content)
                .frame(width: UIScreen.main.bounds.width, height: setHeight)
                .shadow(color: .black, radius: 15)
    }
}

extension View {
    func gradientOverlay(height: CGFloat, colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) -> some View {
        modifier(GradientText(setHeight: height, colors: colors, startPoint: startPoint, endPoint: endPoint))
    }
}

extension UnitPoint {
    func opposite() -> UnitPoint {
        switch self {
        case .leading:
            return .trailing
        case .trailing:
            return .leading
        case .top:
            return .bottom
        case .bottom:
            return .top
        case .bottomTrailing:
            return .topLeading
        case .bottomLeading:
            return .topTrailing
        case .topLeading:
            return .bottomTrailing
        case .topTrailing:
            return .bottomLeading
        case .center:
            return .zero
        default:
            return .center
        }
    }
}
