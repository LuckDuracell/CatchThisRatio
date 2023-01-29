//
//  UpdateMap.swift
//  CatchThisRatio
//
//  Created by Luke Drushell on 1/28/23.
//

import SwiftUI

struct UpdateMap: View {
    
    @Binding var map: Map
    @Binding var mapsModel: MapsModel
    @State private var wins: Int = 0
    @State private var losses: Int = 0
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            Image(map.image)
                .resizable()
                .scaledToFill()
                .overlay(Rectangle().background(.ultraThinMaterial).edgesIgnoringSafeArea(.all))
                .edgesIgnoringSafeArea(.all)
            VStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(map.title)
                        if map.subtitle != "" { Text(map.subtitle) }
                    }
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .frame(width: width * 0.95, alignment: .leading)
                }
                Text("Win Ratio: " + calculateWR(wins, losses))
                    .font(.largeTitle.bold())
                    .frame(width: width * 0.95, alignment: .leading)
                    .gradientOverlay(height: 40, colors: [.purple.opacity(0.7), .pink.opacity(0.6)], startPoint: .leading, endPoint: .trailing)
                Spacer()
                VStack(spacing: 50) {
                    Button {
                        wins += 1
                        map.wins += 1
                        mapsModel.save()
                    } label: {
                        Text("+1 Win")
                            .foregroundColor(.white)
                            .font(.largeTitle.bold())
                            .frame(width: width * 0.8, height: 150)
                            .background(LinearGradient(colors: [.green.opacity(0.5), .teal.opacity(0.7), .green.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20).stroke(.white, lineWidth: 5)
                            )
                    }
                    Button {
                        losses += 1
                        map.losses += 1
                        mapsModel.save()
                    } label: {
                        Text("+1 Loss")
                            .foregroundColor(.white)
                            .font(.largeTitle.bold())
                            .frame(width: width * 0.8, height: 150)
                            .background(LinearGradient(colors: [.red.opacity(0.5), .pink.opacity(0.8), .red.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20).stroke(.white, lineWidth: 5)
                            )
                    }
                } .onAppear(perform: {
                    wins = map.wins
                    losses = map.losses
                })
                .onDisappear(perform: {
                    mapsModel = MapsModel()
                })
                Spacer()
            }
        } .colorScheme(lightMap(map.subtitle) ? .dark : .light)
    }
}

struct UpdateMap_Previews: PreviewProvider {
    static var previews: some View {
        UpdateMap(map: .constant(Map(wins: 5, losses: 3, title: "Busan", subtitle: "Downtown", image: "busan downtown")), mapsModel: .constant(MapsModel()))
    }
}

func lightMap(_ map: String) -> Bool {
    if map == "Ruins" || map == "University" || map == "Sanctuary" {
        return true
    }
    return false
}
