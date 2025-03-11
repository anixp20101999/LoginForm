//
//  LoginScreenViewModel.swift
//  LoginForm
//
//  Created by Animesh Rout on 11/03/25.
//

import Foundation

struct Payload : Codable {
    var email: String = ""
    var first_name: String = ""
    var last_name: String = ""
    var phone: String = ""
    var phone_code = "91"
}

struct OtpPayload : Codable {
    var otp : String = ""
    var user_id : String = ""
}


@MainActor
class LoginScreenViewModel: ObservableObject {
    @Published var loginItems : LoginScreenResponse?
    @Published var state = State.ui
    @Published var loginPayload = Payload()
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phoneOrEmail = ""
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var alert = false
    @Published var navigateToOtp = false
    
    @Published var otpItems : OtpScreenResponse?
    @Published var otp: [String] = Array(repeating: "", count: 5)
    @Published var navigateToWelcomeScreen = false
    
    enum State {
        case loading
        case ui
        case error
    }
    func fetchLoginItems(payload:Payload) async throws {
        print("payload \(payload)")
        state = .loading
        guard let url = URL(string: "https://admin-cp.rimashaar.com/api/v1/register-new?lang=en") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

            let payloadData = try JSONEncoder().encode(payload)
           
            request.httpBody = payloadData
        let jsonString = String(data: payloadData, encoding: .utf8)
            print("string \(jsonString)")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print("res \(response)")
            let decoder = JSONDecoder()
            
            if let httpResponse = response as? HTTPURLResponse {
                print("resp \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    let items = try decoder.decode(LoginScreenResponse.self, from: data)
                    self.state = .ui
                    self.loginItems = items
                    print("create \(items)")
                }
            }
            
            
        } catch let error {
            print("error \(error)")
            self.state = .error
            throw error
        }
    }
    
    func fetchOtpItems(payload:OtpPayload) async throws {
        print("payload \(payload)")
        state = .loading
        guard let url = URL(string: "https://admin-cp.rimashaar.com/api/v1/verify-code?lang=en") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

            let payloadData = try JSONEncoder().encode(payload)
           
            request.httpBody = payloadData
        let jsonString = String(data: payloadData, encoding: .utf8)
            print("string \(jsonString)")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print("res \(response)")
            let decoder = JSONDecoder()
            
            if let httpResponse = response as? HTTPURLResponse {
                print("resp \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    let items = try decoder.decode(OtpScreenResponse.self, from: data)
                    self.state = .ui
                    self.otpItems = items
                    print("create \(items)")
                }
            }
            
            
        } catch let error {
            print("error \(error)")
            self.state = .error
            throw error
        }
    }
    
}
