import Foundation
import iArnaconSDK

class UserDefaultsDataSaveHelper: PDataSaveHelper {
    func setPreference<T: Codable>(key: String, value: T) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    func getPreference<T: Codable>(key: String, defaultValue: T) -> T {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
            return defaultValue
        }
        let decoder = JSONDecoder()
        if let value = try? decoder.decode(T.self, from: data) {
            return value
        }
        return defaultValue
    }
}
