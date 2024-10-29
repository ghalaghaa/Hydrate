import SwiftUI


struct IntakeProgressView: View {
    @State var waterIntake: Double = 0.0
    @State var targetIntake: Double

    var body: some View {
        VStack {
                  Spacer().frame(height: 80)
                  
                  Text("Today's Water Intake")
                      .font(.headline)
                      .foregroundColor(.gray)
                      .padding(.top, -120)
                      .padding(.leading, -180)
                  
                  Text("\(String(format: "%.1f", waterIntake)) liter / \(String(format: "%.1f", targetIntake)) liter")
                      .font(.title)
                      .fontWeight(.bold)
                      .padding(.top, -100)
                      .padding(.leading, -140)
                  
                  ZStack {
                      Circle()
                          .stroke(lineWidth: 35.0)
                          .opacity(0.1)
                          .foregroundColor(Color.gray)
                          .frame(width: 330, height:400 )
                      
                      // الدائرة الزرقاء الي تمثل نسبة الماء
                      Circle()
                          .trim(from: 0.0, to: CGFloat(min(self.waterIntake / self.targetIntake, 1.0)))
                          .stroke(style: StrokeStyle(lineWidth: 30.0, lineCap: .round, lineJoin: .round))
                          .foregroundColor(Color.cyan)
                          .rotationEffect(Angle(degrees: 270.0))
                          .animation(.linear, value: waterIntake)
                          .frame(width: 330, height: 400)  // ضبط الحجم إلى 347x347
                      
                      Image(systemName: getIconName())
                          .resizable()
                          .scaledToFit()
                          .frame(width: 100, height: 100)
                          .foregroundColor(.yellow)
                  }
                  
                  Spacer().frame(height: 60)
                  Text("\(String(format: "%.1f", waterIntake)) L")
                      .font(.system(size: 25))
                      .fontWeight(.bold)
                  
                  Stepper(value: $waterIntake, in: 0...targetIntake, step: 0.1) {
                      Text("")
                  }
                  .padding(.horizontal, 150)
              }
              .padding()
          }
          
          private  func getIconName() -> String {
              let waterIntake = ((waterIntake/targetIntake)*100)
                 
                  switch waterIntake {
                  case 0..<20:
                      return "zzz"
                  case 20..<60:
                      return "tortoise.fill"
                  case 60..<99:
                      return "hare.fill"
                  case 99...100:
                      return "hands.clap.fill"
                  default:
                      return"ZZZ"
                  }
              }
          
                            private func progressColor() -> Color {
                  return waterIntake >= targetIntake ? .green : .cyan
              }
          }


