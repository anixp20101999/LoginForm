import SwiftUI

struct LoginScreen: View {
    @StateObject var loginViewModel = LoginScreenViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                
                Text("Sign Up")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                Text("Please enter your information")
                    .font(.body)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                // First Name & Last Name Fields
                HStack {
                    TextField("First Name*", text: $loginViewModel.firstName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                    
                    TextField("Last Name*", text: $loginViewModel.lastName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                
                // Phone or Email Field
                TextField("Phone Number or Email Id", text: $loginViewModel.phoneOrEmail)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                Spacer()
                // OTP Button
                Button(action: {
                    if validateAndSubmit().1 == true {
                        loginViewModel.alert = true
                    }
                    else{
                        Task{
                            
                            loginViewModel.loginPayload.email = loginViewModel.phoneOrEmail.contains("@") ? loginViewModel.phoneOrEmail : ""
                            loginViewModel.loginPayload.first_name = loginViewModel.firstName
                            loginViewModel.loginPayload.last_name = loginViewModel.lastName
                            loginViewModel.loginPayload.phone = loginViewModel.phoneOrEmail.contains("@") ? "" : loginViewModel.phoneOrEmail
                            
                            try await loginViewModel.fetchLoginItems(payload:loginViewModel.loginPayload)
                            loginViewModel.navigateToOtp = true
                        }
                    }
                }) {
                    Text("GET OTP")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                NavigationLink(
                    destination: OtpScreen(),
                    isActive: $loginViewModel.navigateToOtp
                ) { EmptyView() }
                
               
            }
        }
        .alert(loginViewModel.errorMessage, isPresented: $loginViewModel.alert) {
            Button("OK", role: .cancel) {
                loginViewModel.alert = false
            }
        }
    }
    
    private func validateAndSubmit() -> (String,Bool) {
        if loginViewModel.firstName.trimmingCharacters(in: .whitespaces).isEmpty {
            loginViewModel.errorMessage = "Please enter your first name."
            loginViewModel.showError = true
            return (loginViewModel.errorMessage,loginViewModel.showError)
        }
        
        if loginViewModel.lastName.trimmingCharacters(in: .whitespaces).isEmpty {
            loginViewModel.errorMessage = "Please enter your last name."
            loginViewModel.showError = true
            return (loginViewModel.errorMessage,loginViewModel.showError)
        }
        
        if loginViewModel.phoneOrEmail.trimmingCharacters(in: .whitespaces).isEmpty {
            loginViewModel.errorMessage = "Please enter your phone number or email."
            loginViewModel.showError = true
            return (loginViewModel.errorMessage,loginViewModel.showError)
        }
        
        if !isValidEmail(loginViewModel.phoneOrEmail) && !isValidPhone(loginViewModel.phoneOrEmail) {
            loginViewModel.errorMessage = "Please enter a valid email or phone number."
            loginViewModel.showError = true
            return (loginViewModel.errorMessage,loginViewModel.showError)
        }
        return ("",false)
    }
}

private func isValidEmail(_ email: String) -> Bool {
    let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
}

private func isValidPhone(_ phone: String) -> Bool {
    let phoneRegex = #"^\d{10}$"#
    return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
}
