//
//  CurveView.swift
//  Trip details fleet manager
//
//  Created by Vanshika on 21/02/25.
//

import SwiftUI
// Curve View
struct CurveView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height

                path.move(to: CGPoint(x: 0, y: height))
                path.addQuadCurve(to: CGPoint(x: width, y: height), control: CGPoint(x: width / 2, y: 0))
            }
            .stroke(Color.gray, lineWidth: 2)
        }
    }
}
