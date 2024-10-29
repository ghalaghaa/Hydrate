import SwiftUI

struct OnboardingView1: View {
    @State private var bodyWeight: String = ""
    @State private var dailyWaterIntake: Double = 0.0
    @State private var navigateToNext = false // State to control navigation

    var body: some View {
        NavigationView {
            VStack (alignment: .center){
                VStack{
                    Spacer()
                        .padding()
                    Image(systemName: "drop.fill")
                        .resizable()
                        .foregroundColor(.cyan)
                        .frame(width: 40, height: 55)
                    
                        .padding(.leading, -160)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Hydrate")
                            .font(.title)
                            .foregroundColor(Color.black)
                        //                        .padding(.top, -110)
                        //                        .padding(.leading, -35)
                        
                        Text("Start with Hydrate to record and track your water intake daily based on your needs and stay hydrated.")
                            .font(.body)
                            .fontWeight(.light)
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.leading)
                            .padding(.trailing, 10)
                            .frame(width: 355, height: 80)
                        
                    }
                    
                    Spacer().frame(height: 10)
                    
                    HStack {
                        Text("Body weight")
                            .foregroundColor(.black)
                        
                        TextField(" Value", text: $bodyWeight)
                            .keyboardType(.decimalPad).ignoresSafeArea()
                            .foregroundColor(.blue)
                        
                        if !bodyWeight.isEmpty {
                            Button(action: {
                                bodyWeight = ""
                                dailyWaterIntake = 0.0
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                    }
                    
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .padding(.horizontal, 10)
                }
                .padding(.bottom, -100)
                Button(action: {
                    if let weight = Double(bodyWeight) {
                        dailyWaterIntake = weight * 0.03
                        navigateToNext = true // Trigger navigation on calculation
                    } else {
                        dailyWaterIntake = 0.0
                    }
                }) {
                    Text("Next")
                        .foregroundColor(.white)
                        .frame(maxWidth: 355)
                        .frame(height: 50)
                        .font(.headline)
                        .background(.cyan)
                        .cornerRadius(10)
                }.padding(.top, 350)
                

                // Show the daily water intake when it's calculated
                if dailyWaterIntake > 0 {
                    Text("Daily Water Intake: \(String(format: "%.2f", dailyWaterIntake)) liters")
                        .font(.headline)
                        .foregroundColor(.cyan)
                        .padding()
                }

                Spacer()

                // NavigationLink to OnboardingView2, passing `dailyWaterIntake`
                NavigationLink(
                    destination: OnboardingView2(dailyWaterIntake: dailyWaterIntake),
                    isActive: $navigateToNext
                ) { EmptyView() }
//                    .navigationBarBackButtonHidden(true)
            }
            .navigationTitle("")
        }
    }
}

// Preview for ContentView
#Preview {
    OnboardingView1()
}
