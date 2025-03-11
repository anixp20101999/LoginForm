
import Foundation

// MARK: - LoginScreenResponse
struct LoginScreenResponse: Codable {
    let success: Bool
    let status: Int
    let message: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let id: Int?
    let firstName, lastName, gender, dob: String?
    let email: String?
    let image: String?
    let phoneCode, phone, code: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case gender, dob, email, image
        case phoneCode = "phone_code"
        case phone, code
    }
}

struct OtpScreenResponse: Codable {
    let success: Bool
    let status: Int
    let message: String
}

