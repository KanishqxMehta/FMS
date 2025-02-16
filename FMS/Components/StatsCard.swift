//
//  StatsCard.swift
//  FMS
//
//  Created by Kanishq Mehta on 15/02/25.
//

import SwiftUI

struct StatsCard: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundStyle(.white.opacity(0.9), .white.opacity(0.7))
                    .padding(10)
                    .background(.black)
                    .cornerRadius(10)
                
                Spacer()
                
                Text(value)
                    .font(.title)
                    .bold()
            }
            
            Spacer()
            
            Text(label)
                .font(.callout)
                .bold()
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 120, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct StatsCardView_Previews: PreviewProvider {
    static var previews: some View {
        StatsCard(icon: "car", value: "10", label: "Total Vehices")
    }
}
