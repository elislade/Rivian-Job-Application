//
//  VehicleCard.swift
//  RivianClient
//
//  Created by Eli Slade on 2021-05-30.
//

import SwiftUI
import MapKit
import CoreLocation

struct VehicleCard: View {
    
    @EnvironmentObject private var locManager: Location
    
    var location: CLLocation?
    let perform: (Vehicle.Action) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            if location != nil {
                LocationView(location: location!)
                    .transition(.scale.combined(with: .opacity))
            } else {
                ActivityIndicator()
            }
            
            ActionsView(perform: perform)
        }
        .padding(20)
        .background(Color("riv_darkblue"))
        .colorScheme(.dark)
        .animation(.spring())
    }
}

struct VeCardPreview: PreviewProvider {
    static var previews: some View {
        VehicleCard(perform:{ _ in }).environmentObject(Location())
    }
}

struct ActionsView: View {
    
    let perform: (Vehicle.Action) -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(Vehicle.Action.allCases){ act in
                Button(action: { perform(act) }){
                    HStack {
                        Spacer(minLength: 0)
                        VStack(spacing: 10) {
                            act.image.font(Font.title.bold())
                            Text(act.description.uppercased())
                                .font(Font.caption.weight(.black))
                                .lineLimit(1)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(14)
                    .background(Color("riv_yellow"))
                    .cornerRadius(14)
                }
            }
        }.foregroundColor(Color("riv_blue"))
    }
}

struct LocationView: View {
    
    let location: CLLocation
    
    @State private var address: String?
    
    var body: some View {
        MapView(anno: location)
            .aspectRatio(1.6, contentMode: .fit)
            .overlay(HStack {
                Text(address ?? "Address").fontWeight(.bold)
                Spacer()
                Text(MKDistanceFormatter().string(fromDistance: location.altitude)).opacity(0.6)
            }.padding().background(Color.black.opacity(0.8)), alignment: .top)
            .cornerRadius(14)
            .onAppear{
                location.address(completion: {
                    self.address = $0
                })
            }
    }
}
