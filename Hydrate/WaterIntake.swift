import SwiftUI

struct WaterIntakeView: View {
    @State private var currentIntake: Double = 0.0
    @Binding var dailyGoal: Double

    private var centerPhoto: String {
        let percentage = ((currentIntake / dailyGoal) * 100 ) // نسبة التقدم من الهدف

        switch percentage {
        case 0..<20:
            return "zzz"  // نوم - أقل من 20%
        case 20..<60:
            return "tortoise.fill"  // سلحفاة - بين 20% و 60%
        case 60..<90:
            return "hare.fill"  // أرنب - بين 60% و 90%
        case 90...100:
            return "hands.clap.fill"  // تصفيق - اكتمال الهدف
        default:
            return  "zzz"  // تجاوز الهدف
        }
    }
    
    
    
    

    var body: some View {
        VStack {
            // Title
            VStack(spacing: 10) {
                Text("Today's Water Intake")
                    .frame(width: 180, alignment: .leading)
                    .font(.footnote)
                    .foregroundColor(myColors.text1)
                    .padding(.trailing, 90)
                HStack{
                    Text("\(currentIntake, specifier: "%.1f") liter /")
                        .foregroundColor(currentIntake == dailyGoal ? Color.green : Color.black)
                    
                    Text("\(dailyGoal, specifier: "%.1f") liter")
                }
                .font(.title2)
                    .bold()                      .frame(width: 200)
                    .padding(.trailing, 90)


            }
            .frame(alignment: .leading)
            .padding(.trailing, 100)

            ZStack {
                // Gray Circle
                Circle()
                    .stroke(myColors.Circlegray, lineWidth: 30)
                    .frame(width: 310, height: 310)
                
                // Progress Circle
                Circle()
                    .trim(from: 0.0, to: min(currentIntake / dailyGoal, 1.0))
                    .stroke(myColors.appBlue, style: StrokeStyle(lineWidth: 30, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 310, height: 310)
                    .animation(.easeInOut(duration: 0.5), value: currentIntake)
                
                // Blue dot at the top
                Circle()
                    .fill(myColors.appBlue)
                    .frame(width: 30, height: 30)
                    .offset(y: -155)

                Image(systemName: centerPhoto)
                    .foregroundColor(.yellow)
                    .font(.system(size: 66))
            }
            .padding(80)
                
            // Control buttons
            HStack {
                Text("\(currentIntake, specifier: "%.1f") L")
                    .font(.title3)
                    .bold()
            }

            // Stepper for adjusting intake
            Stepper(value: $currentIntake, in: 0...dailyGoal, step: 0.2) {
                EmptyView()
            }
            .labelsHidden()
            .padding(.top, 20)
        
        }
    }
}

struct WaterIntakeView_Previews: PreviewProvider {
    static var previews: some View {
        WaterIntakeView(dailyGoal: .constant(2.7))
    }
}
