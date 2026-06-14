import Foundation

struct Assignment: Identifiable, Codable {

    let id: UUID

    var title: String

    var dueDate: Date

    var completed: Bool

    init(
        id: UUID = UUID(),
        title: String,
        dueDate: Date,
        completed: Bool = false
    ) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.completed = completed
    }
}
