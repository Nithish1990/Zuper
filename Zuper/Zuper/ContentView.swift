//
//  ContentView.swift
//  Zuper
//
//  Created by nithish-17632 on 25/11/23.
//

import SwiftUI

struct AddictionTrackerView: View {
    @State private var progress: CGFloat = 0.5 // This would be dynamic based on your app's state
    
    var body: some View {
        VStack {
            // Header
            Text("Addiction\nFREEDOM TRACKER")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
            // Progress ring
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(Color.blue)
                
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .foregroundColor(Color.blue)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear, value: progress)
                
                // Time inside the progress ring
                VStack {
                    Text("22.34")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                    Text("20.10, 48s")
                        .font(.caption)
                }
            }
            .frame(width: 300, height: 300)
            .padding()
            
            // Log new resistance button
            Button(action: {
                // Handle button tap
            }) {
                Text("LOG NEW RESISTANCE")
                    .fontWeight(.bold)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(40)
            }
            .padding()
            
            // Streak and Best Resistance
            VStack(alignment: .leading) {
                HStack {
                    Text("STREAK")
                        .font(.headline)
                    Spacer()
                    Text("BEST RESISTANCE")
                        .font(.headline)
                }
                
                HStack {
                    ProgressView(value: 0.6, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.green))
                    Spacer()
                    ProgressView(value: 0.8, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.orange))
                }
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
}

struct AddictionTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        AddictionTrackerView()
    }
}
