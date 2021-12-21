//
//  ToolPalette.swift
//  X-ray (iOS)
//
//  Created by Tim Yoon on 12/14/21.
//

import SwiftUI
enum ButtonSelection: Int, CaseIterable {
    case S1=0, L1, FH, Reset
    var text : String {
        switch self {
        
        case .S1:
            return "S1"
        case .L1:
            return "L1"
        case .FH:
            return "FH"
        case .Reset:
            return "⇐"
            

        }
    }
}
struct PaletteButton: View {
    @Binding var selection : ButtonSelection
    let thisButton : ButtonSelection
    var completion : ()->Void

    var thisButtonIsSelected : Bool{
        selection == thisButton
    }
    var body: some View {
        Button {
            selection = thisButton
            completion()
            print("Button Press: \(thisButton.text)")
        } label: {
            Text(thisButton.text)
                .font(.title)
                .fontWeight(thisButtonIsSelected ? .bold : .regular)
                .foregroundColor(thisButtonIsSelected ? .yellow : .white)
                .padding(8)
                .background(
                    Rectangle()
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .opacity(0.8)
                        .frame(width: thisButtonIsSelected ? 65 : 60, height: 50)
//                        .shadow(color: .gray, radius: 5, x: 5, y: 5)
                )
                
        }
    }
}
struct ToolPalette: View {
    @Binding var selection : ButtonSelection
    var resetCompletion : ()->Void
    
    var body: some View {
        HStack{
            Spacer()
            VStack{
                PaletteButton(selection: $selection, thisButton: .S1, completion: {
                    
                })
                PaletteButton(selection: $selection, thisButton: .L1, completion: {
                    
                })
                PaletteButton(selection: $selection, thisButton: .FH, completion: {
                    
                })
                PaletteButton(selection: $selection, thisButton: .Reset) {
                    resetCompletion()
                }
            }.padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .opacity(0.2)
                )
        }
    }
}

struct ToolPalette_Previews: PreviewProvider {
    static var previews: some View {
        ToolPalette(selection: .constant(ButtonSelection.L1)) {
            
        }
    }
}
