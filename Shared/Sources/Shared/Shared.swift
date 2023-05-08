import Foundation

public enum SharedDataModel {
    public struct Donut: Codable, Hashable, Identifiable, Sendable {
        public let id: UUID
        public let name: String
        
        public init(id: UUID, name: String) {
            self.id = id
            self.name = name
        }
    }
}
