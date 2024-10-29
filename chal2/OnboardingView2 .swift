
import SwiftUI
import UserNotifications



struct OnboardingView2: View {
  
    @State var dailyWaterIntake: Double
    @State private var startHour = Date()
    @State private var endHour = Date()
    @State private var isStartAM = true
    @State private var isEndAM = true
    @State private var selectedInterval: String? = nil
    @State private var isNavigationActive = false  // حالة التنقل

    let intervals = ["15 Mins", "30 Mins", "60 Mins", "90 Mins", "2 Hours", "3 Hours", "4 Hours", "5 Hours"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Notification Preferences")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                Text("The start and End hour")
                    .bold()
                    .padding(.leading, -180)


                VStack(alignment: .leading, spacing: 6) {
                    Text("Specify the start and end date to receive the notifications")
                    
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .opacity(0.8)
                        .padding(.leading, 10)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    ZStack {
                           Color(UIColor.systemGray6)  // Unified background
                               .cornerRadius(8)

                           VStack(spacing: 0) {
                               timePicker(label: "Start hour", selection: $startHour, isAM: $isStartAM)
                               Divider()
                               timePicker(label: "End hour", selection: $endHour, isAM: $isEndAM)
                               
                           }
                       }
                       .padding(.horizontal)
                       .frame(maxWidth: .infinity)
                }
                
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Notification interval")
                        .font(.callout)
                        .bold()
                        .padding(.leading, 15)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("How often would you like to receive notifications within the specified time interval")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .opacity(0.8)
                            .padding(.leading, 10)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
                        ForEach(intervals, id: \.self) { interval in
                            VStack(spacing: 2) {
                                let components = interval.split(separator: " ")
                                if components.count == 2 {
                                    Text(components[0])
                                        .foregroundColor(selectedInterval == interval ? Color.white : Color.cyan)
                                        .font(.title3)

                                    Text(components[1])
                                        .foregroundColor(selectedInterval == interval ? Color.white : Color.black)
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .padding()
                            .background(selectedInterval == interval ? Color.cyan : Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .onTapGesture {
                                selectedInterval = interval
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // زر البدء وتنشيط التنقل إلى IntakeProgressView
                NavigationLink(destination: IntakeProgressView(targetIntake: dailyWaterIntake), isActive: $isNavigationActive) {
                    EmptyView()
                }


                Button(action: {
                    scheduleNotifications()
                    isNavigationActive = true  // تفعيل التنقل
                }) {
                    Text("Start")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cyan)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 50)
            .navigationBarHidden(true)
            .onAppear {
                requestNotificationPermission()
            }
        }
        .navigationBarBackButtonHidden(true)

    }

    // طلب إذن الإشعارات
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }

    // جدولة الإشعارات بناءً على المدخلات
    func scheduleNotifications() {
        guard let interval = selectedInterval else { return }

        let components = interval.split(separator: " ")
        let intervalInMinutes = Int(components[0]) ?? 15
        let intervalInSeconds = intervalInMinutes * 60

        let startHourComponents = Calendar.current.dateComponents([.hour, .minute], from: startHour)
        let endHourComponents = Calendar.current.dateComponents([.hour, .minute], from: endHour)

        var notificationTime = startHour

        while notificationTime <= endHour {
            let content = UNMutableNotificationContent()
            content.title = "Time to Drink Water"
            content.body = "Stay hydrated! It's time to drink some water."
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents([.hour, .minute], from: notificationTime),
                repeats: false
            )

            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                }
            }

            notificationTime = Calendar.current.date(byAdding: .second, value: intervalInSeconds, to: notificationTime) ?? notificationTime
        }
    }

    // مكون مخصص لاختيار الوقت
    @ViewBuilder
    func timePicker(label: String, selection: Binding<Date>, isAM: Binding<Bool>) -> some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(.black)
            
            Spacer()

            HStack(spacing: 1) {
                DatePicker("", selection: selection, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .frame(width: 80)
                    .environment(\.locale, Locale(identifier: "us"))

                Picker("", selection: isAM) {
                    Text("AM").tag(true)
                    Text("PM").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 80)
            }
        }
        .padding()
//    }
}
    }

// Preview لتجربة العرض
#Preview {
    OnboardingView2(dailyWaterIntake: 1.8)
}
