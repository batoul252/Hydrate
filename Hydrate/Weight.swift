import SwiftUI

struct Weight: View {
    @State var Weight: String = ""
    @State var WaterIntake: Double = 0.0 // كمية الماء المحسوبة
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer() // Pushes content to the center of the screen
                
                VStack(alignment: .leading, spacing: 25) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 56))
                        .foregroundColor(myColors.appBlue)

                    
                    Text("Hydrate")
                        .bold()
                        .font(.system(size: 25))
                    
                    Text("Start with Hydrate to record and track your water intake daily based on your needs and stay hydrated")
                        .font(.system(size: 20))
                        .foregroundColor(myColors.text1)
    
                    
                    
                    
                    HStack {
                        Text("Body weight")
                            .font(.body)

                        
                        ZStack {
                            TextField("value",
                                      text: $Weight)
                                .textFieldStyle(PlainTextFieldStyle())
                                .bold()
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.leading)
                                .onChange(of: Weight) { newValue in
                                    calculateWaterIntake()
                                }
                        }
                        
                        Button(action: {
                            Weight = "" // Clear input
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(10)
                    .background(Color(UIColor.systemGray6))
                }
//                .padding(.horizontal) // Side padding for inner content
                
                Spacer()
                Spacer()// Pushes content to the center of the screen

                // Next Button at the bottom
                VStack {
                    NavigationLink(destination: NotificationPreferencesView(dailyGoal: $WaterIntake).navigationBarBackButtonHidden(false)) {
                        Text("Next")

                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(myColors.appBlue))
                            .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
    }
    
    func calculateWaterIntake() {
        if let weightValue = Double(Weight) { // تحويل الوزن من نص إلى رقم
            WaterIntake = weightValue * 0.033 // المعادلة
        } else {
            WaterIntake = 0.0 // تعيين الكمية إلى صفر إذا كان الإدخال غير صالح
        }
    }
}

#Preview {
    Weight()
}
