import Foundation

final class TimetableStorage {

    static let shared =
    TimetableStorage()

    private let key =
    "studyflow_timetable"

    func save(
        timetables: [Timetable]
    ) {

        guard let data =
        try? JSONEncoder()
            .encode(timetables)
        else {
            return
        }

        UserDefaults.standard.set(
            data,
            forKey: key
        )
    }

    func load() -> [Timetable] {

        guard let data =
        UserDefaults.standard.data(
            forKey: key
        ),

        let timetables =
        try? JSONDecoder()
            .decode(
                [Timetable].self,
                from: data
            )

        else {
            return []
        }

        return timetables
    }
}
