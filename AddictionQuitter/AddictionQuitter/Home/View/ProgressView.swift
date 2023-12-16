//
//  ProgressView.swift
//  AddictionQuitter
//
//  Created by nithish on 26/11/23.
//

import SwiftUI

import Combine


protocol RelapseDelegate {
    func didRelapseTapped()
}

class ProgressData: ObservableObject {
    @Published var progress: CGFloat = 0.0
    
    
    @Published var days = 0
    @Published var hours = 0
    @Published var min = 0
    @Published var sec = 0
}

struct AQProgessView: View, RelapseDelegate {
    @ObservedObject var progress: ProgressData
    @State var progressTimer: Timer?
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(AQColors.mainThemeColor)
                
                Circle()
                    .trim(from: 0.0, to: progress.progress)
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .foregroundColor(AQColors.mainThemeColor)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: progress.progress)
                
                VStack(spacing: 10) {
                    Text("STREAK")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("\(progress.days)")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                    Text("Days")
                        .font(.caption)
                        .foregroundColor(AQColors.mainThemeColor)
                    Text("\(progress.hours) Hrs \(progress.min) Mins")
                        .foregroundColor(.primary)
                    Text("\(progress.sec) Secs")
                        .foregroundColor(.primary)
                    Text("OF SOBRIETY")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 250, height: 250)
            Spacer(minLength: 25)
            AQButtonsBar(relapseDelegate: self)
        }
    }
    
    public func didRelapseTapped() {
        withAnimation {
            self.progress.progress = -1
        }
        
        
        let recentStreak = DatabaseManager.getInstance().recentStreak()
        let streak = Streak(id: recentStreak.id + 1, timeDate: Date.getCurrentDate(), reason: "yet to know", category: "no yet decided")
        DatabaseManager.getInstance().insertStreak(streak: streak)
    }
    
    
    
    public func increaseProgressBy1Second(start: Bool) {
        // Invalidate the previous timer if it exists
        progressTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: start) { timer in
            DispatchQueue.main.async {
                
                let currentTime = Date()
                let previousDate: Date = DatabaseManager.getInstance().recentStreak().timeDate
                let elapsedTime = currentTime.timeIntervalSince(previousDate)
                let elapsedDate = Date.formatDuration(seconds: elapsedTime)
                self.progress.progress = elapsedTime * 0.001
                let epsilon: CGFloat = 0.0001
                if self.progress.progress > (1.0 - epsilon) {
                    self.progress.progress = 0
                }
                self.progress.days = elapsedDate.days
                self.progress.hours = elapsedDate.hours
                self.progress.min = elapsedDate.minutes
                self.progress.sec = elapsedDate.seconds
            }
        }
        guard let progressTimer = self.progressTimer else {
            return
        }
        RunLoop.current.add(progressTimer, forMode: .common)
        progressTimer.tolerance = 0.1
    }
    
    
}


extension Date {
    static func calculateTimeDifference(from startDate: Date, to endDate: Date) -> (years: Int, months: Int, days: Int, hours: Int, minutes: Int, seconds: Int) {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startDate, to: endDate)
        
        return (
            years: components.year ?? 0,
            months: components.month ?? 0,
            days: components.day ?? 0,
            hours: components.hour ?? 0,
            minutes: components.minute ?? 0,
            seconds: components.second ?? 0
        )
    }
    
    static func formatDuration(seconds: TimeInterval) -> (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let duration = Int(seconds)
        
        let days = duration / (24 * 3600)
        let hours = (duration % (24 * 3600)) / 3600
        let minutes = (duration % 3600) / 60
        let seconds = duration % 60
        
        return (days, hours, minutes, seconds)
    }
    
    static func getCurrentDateTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateTime = Date()
        let formattedDate = dateFormatter.string(from: currentDateTime)
        return formattedDate
    }
    
    static func convertStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            print("Invalid date string format")
            return nil
        }
    }
    
    static func getCurrentDate() -> Date {
        return convertStringToDate(getCurrentDateTimeString())!
    }
}
