import SwiftUI
import UserNotifications

struct NotificationPreferencesView: View {
    @State private var startHour: String = "3:00"          // وقت بدء الإشعارات (ساعات ودقائق)
    @State private var startPeriod: String = "AM"          // الفترة (صباحًا أو مساءً)
    @State private var endHour: String = "3:00"            // وقت انتهاء الإشعارات
    @State private var endPeriod: String = "AM"
    @State private var selectedInterval: String = ""       // فاصل الإشعارات المختار (مدة تكرار الإشعارات)
    @Binding var dailyGoal: Double                         // هدف المستخدم اليومي من شرب الماء
    
    // الفواصل الزمنية المتاحة لتكرار الإشعارات
    let intervals = ["15 Mins", "30 Mins", "60 Mins", "90 Mins", "2 Hours", "3 Hours", "4 Hours", "5 Hours"]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 30) {
                
                Text("Notification Preferences")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top)
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("The start and End hours")
                        .font(.headline)
                        .padding(.trailing, 100)
                    Text("Specify the start and end time to receive the notifications")
                        .font(.subheadline)
                        .foregroundColor(myColors.text1)
                }
                
                VStack {
                    TimePickerRow(label: "Start hour", time: $startHour, period: $startPeriod)
                    Divider()
                    TimePickerRow(label: "End hour", time: $endHour, period: $endPeriod)
                }
                .padding(10)
                .background(myColors.gray)
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Notification Interval")
                        .font(.headline)
                    Text("How often would you like to receive notifications within the specified time interval?")
                        .font(.subheadline)
                        .foregroundColor(myColors.text1)
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                    ForEach(intervals,id: \.self)
                    {interval in
                            Button(action: {
                                selectedInterval = interval
                                scheduleNotification() // استدعاء جدولة الإشعار عند اختيار فاصل زمني جديد
                            }) {
                                VStack{
                                let parts = interval.split(separator: " ")
                                Text(parts[0])
                                    .font(.system(size: 17))
                                    .foregroundColor(selectedInterval == interval ? Color.white : myColors.appBlue)
                                Text(parts[1])
                                    .font(.system(size: 14))
                                    .foregroundColor(selectedInterval == interval ? Color.white : Color.black)
                            }
                            .frame(maxWidth: .infinity, minHeight: 70)
                            .background(selectedInterval == interval ?
                                        Color(myColors.appBlue) : myColors.gray)
                            .cornerRadius(10)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer()
                                             
                
                NavigationLink(destination: WaterIntakeView(dailyGoal: $dailyGoal).navigationBarBackButtonHidden(true)) {
                    Text("Start")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(myColors.appBlue))
                        .cornerRadius(12)
                }
                .frame(height: 50)
            }
            .padding(22)
            .background(Color.white)
            .onAppear {
                requestNotificationPermission() // طلب الإذن عند عرض الشاشة لأول مرة
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notifications permission: \(error)")
            }
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Don't forget to drink water!"
        content.body = "Come back to the app to drink water"
        content.sound = UNNotificationSound.default
        
        // إعداد الموعد للإشعار
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    struct TimePickerRow: View {
        let label: String
        @Binding var time: String
        @Binding var period: String
        
        var body: some View {
            HStack {
                Text(label)
                    .font(.system(size: 17))
                Spacer()
                TextField("", text: $time)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 80)
                Picker(selection: $period, label: Text("")) {
                    Text("AM").tag("AM")
                    Text("PM").tag("PM")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 100)
            }
        }
    }
}
#Preview {
    
    NotificationPreferencesView(dailyGoal: .constant(2.7))}
