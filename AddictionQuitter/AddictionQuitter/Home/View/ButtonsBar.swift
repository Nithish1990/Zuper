//
//  ButtonsBar.swift
//  AddictionQuitter
//
//  Created by nithish-17632 on 09/12/23.
//

import SwiftUI

struct AQButtonsBar: View {
    var relapseDelegate: RelapseDelegate
    var bestCount = 0
    var attemptCount = DatabaseManager.getInstance().getStreakCount()
    var body: some View {
        HStack {
            // Best Section
            VStack {
                Text("BEST")
                    .font(.caption)
                    .foregroundColor(AQColors.mainButtonColor)
                Text("\(bestCount)days")
                    .font(.title3)
                    .foregroundColor(AQColors.textColor)
            }
            
            Spacer()
            VStack {
                Image(systemName: "figure.walk")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                Button(action: {
                    // Handle click here
                    relapseDelegate.didRelapseTapped()
                }) {
                    Text("(Click here for Relapse)")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            // Attempt Section
            VStack {
                Text("ATTEMPT")
                    .font(.caption)
                    .foregroundColor(AQColors.mainButtonColor)
                Text("\(attemptCount)th")
                    .font(.title3)
                    .foregroundColor(AQColors.textColor)
            }
        }
        .padding()
        .background(AQColors.backgroundThemeColor)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AQColors.mainThemeColor, lineWidth: 1)
        )
        .padding(.horizontal)
    }
}
