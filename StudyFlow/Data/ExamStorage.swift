import Foundation

final class ExamStorage {


static let shared = ExamStorage()

private let key = "studyflow_exams"

func save(exams: [Exam]) {

    guard let data =
    try? JSONEncoder().encode(exams)
    else {
        return
    }

    UserDefaults.standard.set(
        data,
        forKey: key
    )
}

func load() -> [Exam] {

    guard let data =
    UserDefaults.standard.data(
        forKey: key
    )
    else {
        return []
    }

    return (
        try?
        JSONDecoder().decode(
            [Exam].self,
            from: data
        )
    ) ?? []
}


}

