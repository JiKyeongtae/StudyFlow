import SwiftUI

struct Exam: Identifiable {


let id = UUID()

var subject: String
var date: Date


}

struct ExamView: View {


@State private var exams: [Exam] = []

@State private var subject = ""

@State private var selectedDate = Date()

var body: some View {

    NavigationStack {

        ZStack {

            Color(
                red: 0.96,
                green: 0.97,
                blue: 0.99
            )
            .ignoresSafeArea()

            ScrollView {

                VStack(spacing: 20) {

                    VStack(spacing: 12) {

                        TextField(
                            "과목명을 입력하세요",
                            text: $subject
                        )
                        .textFieldStyle(.roundedBorder)

                        DatePicker(
                            "시험 날짜",
                            selection: $selectedDate,
                            displayedComponents: .date
                        )

                        Button {

                            if !subject.isEmpty {

                                exams.append(
                                    Exam(
                                        subject: subject,
                                        date: selectedDate
                                    )
                                )

                                subject = ""
                            }

                        } label: {

                            Text("시험 추가")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    ForEach(exams) { exam in

                        ExamCard(
                            subject: exam.subject,
                            dday: daysUntil(exam.date)
                        )
                    }
                }
                .padding()
            }
        }
        .navigationTitle("시험")
    }
}

func daysUntil(_ date: Date) -> Int {

    let calendar = Calendar.current

    let start =
    calendar.startOfDay(for: Date())

    let end =
    calendar.startOfDay(for: date)

    return calendar
        .dateComponents(
            [.day],
            from: start,
            to: end
        )
        .day ?? 0
}


}

struct ExamCard: View {


let subject: String
let dday: Int

var body: some View {

    HStack {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            Text(subject)
                .font(.title3)
                .fontWeight(.bold)

            Text("시험 예정")
                .foregroundColor(.gray)
        }

        Spacer()

        VStack {

            Text("D-DAY")
                .font(.caption)

            Text("\(dday)")
                .font(.system(size: 32))
                .fontWeight(.bold)
        }
        .foregroundColor(.blue)
    }
    .padding()

    .background(
        RoundedRectangle(
            cornerRadius: 24
        )
        .fill(Color.white)
    )

    .shadow(
        color: .black.opacity(0.08),
        radius: 10,
        x: 0,
        y: 4
    )
}


}

#Preview {
ExamView()
}

