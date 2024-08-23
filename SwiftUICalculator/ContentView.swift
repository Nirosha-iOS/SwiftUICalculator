//
//  ContentView.swift
//  SwiftUICalculator
//
//  Created by KISHANI on 23/08/24.
//

import SwiftUI

struct ContentView: View {
    @State private var value = "0"
    @State private var runningNumber = 0
    @State private var currentOperation: Operation = .none
    @State private var highlightedButton: btnCalculate?

    let arrButtons: [[btnCalculate]] = [
        [.clear, .negative, .percent, .div],
        [.seven, .eight, .nine, .mul],
        [.four, .five, .six, .sub],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                Spacer()

                // Display value
                HStack {
                    Spacer()
                    Text(value == "0" ? value:""+value)
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .padding()
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }

                // Arrange Calculator Buttons
                ForEach(arrButtons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonHeight()
                                    )
                                    .background(self.backgroundColor(for: item))
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(item: item)/2)
                            })
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }

    func didTap(button: btnCalculate) {
        switch button {
        case .add, .sub, .mul, .div:
            highlightedButton = button
            setOperation(for: button)

        case .equal:
            calculateResult()
            highlightedButton = nil

        case .clear:
            clearCalculator()

        case .decimal, .negative, .percent:
            // Handle special cases like decimals, negation, or percentages
            break

        default:
            handleNumberInput(button.rawValue)
        }
    }

    func setOperation(for button: btnCalculate) {
        if button == .add {
            self.currentOperation = .add
        } else if button == .sub {
            self.currentOperation = .sub
        } else if button == .mul {
            self.currentOperation = .mul
        } else if button == .div {
            self.currentOperation = .div
        }

        self.runningNumber = Int(self.value) ?? 0
        self.value = "0"
    }

    func calculateResult() {
        let runningValue = self.runningNumber
        let currentValue = Int(self.value) ?? 0
        switch self.currentOperation {
        case .add: self.value = "\(runningValue + currentValue)"
        case .sub: self.value = "\(runningValue - currentValue)"
        case .mul: self.value = "\(runningValue * currentValue)"
        case .div: self.value = "\(runningValue / currentValue)"
        case .none: break
        }
        self.currentOperation = .none
    }

    func clearCalculator() {
        self.value = "0"
        self.runningNumber = 0
        self.currentOperation = .none
        highlightedButton = nil
    }

    func handleNumberInput(_ number: String) {
        if self.value == "0" {
            self.value = number
        } else {
            self.value += number
        }
    }

    func backgroundColor(for button: btnCalculate) -> Color {
        if button == highlightedButton {
            return button.buttonColor.opacity(0.5)
        }
        return button.buttonColor
    }

    func buttonWidth(item: btnCalculate) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (5 * 12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }

    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
}

#Preview {
    ContentView()
}


enum btnCalculate: String {
    
    case add = "+"
    case sub = "-"
    case div = "÷"
    case mul = "x"
    case equal = "="
    
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
   
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "-/+"

    var buttonColor: Color {
        switch self {
        case .add, .sub, .mul, .div:
            return .orange
        case .equal:
            return .orange
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(.darkGray)
        }
    }
}

enum Operation {
    case add, sub, mul, div, none
}
