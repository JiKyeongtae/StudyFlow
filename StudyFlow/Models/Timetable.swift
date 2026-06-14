import Foundation

struct Timetable: Identifiable, Codable {

    let id: UUID

    var day: String

    var subject: String

    var startTime: Date

    var endTime: Date

    init(
        id: UUID = UUID(),
        day: String,
        subject: String,
        startTime: Date,
        endTime: Date
    ) {
        self.id = id
        self.day = day
        self.subject = subject
        self.startTime = startTime
        self.endTime = endTime
    }
}
