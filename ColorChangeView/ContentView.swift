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

    @State private var textRed = 0.0
    @State private var textGreen = 0.0
    @State private var textBlue = 0.0

    @FocusState private var focusColor: ColorSlide?

    var body: some View {
        DispatchQueue.main.async {
            textRed = valueRed
            textGreen = valueGreen
            textBlue = valueBlue
        }
        
        return ZStack {
            Color(.gray).ignoresSafeArea()
            VStack(spacing: 100) {
                Rectangle()
                    .paletView(red: valueRed,
                               greed: valueGreen,
                               blue: valueBlue,
                               height: 200)

                VStack(spacing: 10) {
                    SliderColor(value: $valueRed, valueText: $textRed)
                        .focused($focusColor, equals: .red)
                    SliderColor(value: $valueBlue, valueText: $textBlue)
                        .focused($focusColor, equals: .blue)
                    SliderColor(value: $valueGreen, valueText: $textGreen)
                        .focused($focusColor, equals: .green)
                }
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        Button("Done") {
                            switch focusColor {
                            case .red:
                                valueRed = textRed
                            case .blue:
                                valueBlue = textBlue
                            case .green:
                                valueGreen = textGreen
                            default:
                                print("Не верное поле!")
                            }
                            UIApplication.shared.endEditing()
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
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
    @Binding var valueText: Double

    var body: some View {
        HStack {
            Text("\(lround(value))")
                .frame(width: 50.0)
            Slider(value: $value, in: 0...255, step: 1)
            TextField("255", value: $valueText, formatter: NumberFormatter())
                .frame(width: 50.0)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
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
                        modifier: PaletView(red: red,
                                            greed: greed,
                                            blue: blue,
                                            height: height))
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

enum ColorSlide {
    case red
    case green
    case blue
}
