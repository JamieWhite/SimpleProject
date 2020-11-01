import Foundation

// swiftlint:disable:next identifier_name
func LocalizedString(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

extension String {
    func asCurrency() -> String? {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            // Ideally this would come from the API with the `list_price`
            formatter.locale = Locale(identifier: "en_gb")
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            return formatter.string(for: value)
        }
        return nil
    }
}
