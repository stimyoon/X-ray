//
//  MultipleLines.swift
//  X-ray
//
//  Created by Tim Yoon on 12/5/21.
//

import SwiftUI
struct Line: Identifiable {
    var id = UUID()
    var p1 : CGPoint?
    var p2 : CGPoint?
    var isValid : Bool {
        return p1 != nil && p2 != nil
    }
    mutating func invalidate(){
        p1 = nil
        p2 = nil
    }
}

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
extension View {
  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    )
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}
class LinesVM: ObservableObject {
    @Published var L1 = Line()
    @Published var S1 = Line()
    @Published var FemoralHeads = Line()
}

struct MultipleLines: View {
    @State var line = Line()
    @State var width : CGFloat = 500
    @State var height : CGFloat = 500
    
    var body: some View {
        GeometryReader{ geo in
            ZStack(alignment: .leading){
                Image("X-ray")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 500, height: 800)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({ value in
                                line.p1 = value.startLocation
                                line.p2 = value.location
                            })
                    )
                    .readSize { newSize in
                        
                          print("The new child size is: \(newSize)")
                        }
                    .overlay {
                        if(line.p1 != nil){
                            Rectangle()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.yellow)
                                .border(.blue)
                                .position(x: line.p1!.x, y: line.p1!.y)
                                .gesture(
                                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                        .onChanged({ value in
                                            line.p1 = value.location
                                        })
                                )
                        }
                        if(line.p2 != nil){
                            Rectangle()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.yellow)
                                .border(.blue)
                                .position(x: line.p2!.x, y: line.p2!.y)
                                .gesture(
                                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                        .onChanged({ value in
                                            line.p2 = value.location
                                        })
                                )
                        }
                        if let p1 = line.p1, let p2 = line.p2 {
                            Path{ path in
                                path.move(to: CGPoint(x: p1.x, y: p1.y))
                                path.addLine(to: CGPoint(x: p2.x, y: p2.y))
                            }.stroke(.blue, lineWidth: 5)
                        }
                    }
            }
        }
    }

}

struct MultipleLines_Previews: PreviewProvider {
    static var previews: some View {
        MultipleLines()
    }
}
