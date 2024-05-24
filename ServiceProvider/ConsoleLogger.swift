import Foundation
import iArnaconSDK

class ConsoleLogger: PLogger {
    func debug(value: String) {
        print("DEBUG: \(value)")
    }

    func error(_ error: String, exception: Error) {
        print("ERROR: \(error): \(exception.localizedDescription)")
    }
}
