//
//  ContentView.swift
//  ColorChangeView
//
//  Created by Михаил Иванов on 29.10.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var valueRed = Double.random(in: 0...255)
    @State private var valueBlue = Double.random(in: 0...255)
    @State private var valueGreen = Double.random(in: 0...255)

    var body: some View {
        ZStack {
            Color(.gray).ignoresSafeArea()
            VStack(spacing: 100) {
                Rectangle()
                    .paletView(red: valueRed,
                               greed: valueGreen,
                               blue: valueBlue,
                               height: 200)

                VStack(spacing: 10) {
                    SliderColor(value: $valueRed)
                    SliderColor(value: $valueBlue)
                    SliderColor(value: $valueGreen)
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - SliderColor

struct SliderColor: View {
    @Binding var value: Double

    var body: some View {
        HStack {
            Text("\(lround(value))")
                .frame(width: 50.0)
            Slider(value: $value, in: 0...255, step: 1)
            TextField("255", value: $value, formatter: NumberFormatter())
                .frame(width: 50.0)
                .textFieldStyle(.roundedBorder)
        }
    }
}

// MARK: - Custom Mode

struct PaletView: ViewModifier {
    let red: Double
    let greed: Double
    let blue: Double
    let height: CGFloat

    func body(content: Content) -> some View {
        content.frame(height: height)
            .foregroundColor(Color(red: red/255.0,
                                   green: greed/255.0,
                                   blue: blue/255.0))
            .overlay(Rectangle().stroke(Color.black, lineWidth: 6))
    }
}

extension Rectangle {
    func paletView(red: Double, greed: Double, blue: Double, height: CGFloat) -> some View {
        ModifiedContent(content: self,
                        modifier: PaletView(red: red, greed: greed, blue: blue, height: height))
    }
}
