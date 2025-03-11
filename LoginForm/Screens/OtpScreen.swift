import SwiftUI

struct OtpScreen: View {
    @StateObject var loginViewModel = LoginScreenViewModel()
    @FocusState private var focusedIndex: Int?

    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                
                Text("Enter OTP")
                    .font(.title2.bold())
                
                Text("Please enter the 5-digit code that was sent to your email address or phone number.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                HStack(spacing: 10) {
                    ForEach(0..<5, id: \..self) { index in
                        TextField("", text: $loginViewModel.otp[index])
                            .keyboardType(.numberPad)
                            .frame(width: 50, height: 50)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                            .multilineTextAlignment(.center)
                            .focused($focusedIndex, equals: index)
                            .onChange(of: loginViewModel.otp[index]) { newValue in
                                if newValue.count == 1 && index < 4 {
                                    focusedIndex = index + 1
                                } else if newValue.isEmpty && index > 0 {
                                    focusedIndex = index - 1
                                }
                            }
                    }
                }
                
                Spacer()
                Button("Done") {
                    Task{
                        if loginViewModel.otp.count < 5 {
                            loginViewModel.navigateToWelcomeScreen = false
                        }
                        else{
                            try await loginViewModel.fetchOtpItems(payload:OtpPayload(otp:loginViewModel.otp.joined(),user_id:"4"))
                            loginViewModel.navigateToWelcomeScreen = true
                        }
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.top, 20)
            }
            .padding()
            .onAppear { focusedIndex = 0 }
            
            NavigationLink(
                destination: WelcomeScreen(),
                isActive: $loginViewModel.navigateToWelcomeScreen
            ) { EmptyView() }
        }
    }
}

