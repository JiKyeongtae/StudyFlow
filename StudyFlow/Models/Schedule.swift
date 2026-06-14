import Foundation

struct Schedule: Identifiable, Codable {

    let id: UUID

    var title: String

    var date: Date

    init(
        id: UUID = UUID(),
        title: String,
        date: Date
    ) {
        self.id = id
        self.title = title
        self.date = date
    }
}
