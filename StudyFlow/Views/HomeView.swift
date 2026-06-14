
import SwiftUI

struct HomeView: View {

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

                VStack(spacing: 24) {

                    VStack(alignment: .leading, spacing: 8) {

                        Text("2026년 6월")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("좋은 아침입니다")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("오늘도 계획적인 하루를 시작해보세요")
                            .foregroundColor(.gray)
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )

                    HStack(spacing: 16) {

                        StatCard(
                            number: "5",
                            title: "오늘 수업",
                            icon: "book.fill"
                        )

                        StatCard(
                            number: "3",
                            title: "남은 과제",
                            icon: "doc.fill"
                        )
                    }

                    SectionCard(title: "오늘의 일정") {

                        VStack(
                            alignment: .leading,
                            spacing: 14
                        ) {

                            ScheduleRow(
                                time: "09:00",
                                subject: "컴퓨터 과학"
                            )

                            ScheduleRow(
                                time: "11:00",
                                subject: "수학"
                            )

                            ScheduleRow(
                                time: "14:00",
                                subject: "물리 실험"
                            )
                        }
                    }

                    SectionCard(title: "다가오는 시험") {

                        VStack(
                            spacing: 12
                        ) {

                            ExamRow(
                                title: "자료구조",
                                dday: "D-4"
                            )

                            ExamRow(
                                title: "운영체제",
                                dday: "D-10"
                            )
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("StudyFlow")
    }
}


}

struct StatCard: View {


let number: String
let title: String
let icon: String

var body: some View {

    VStack(spacing: 12) {

        Image(systemName: icon)
            .font(.title2)
            .foregroundColor(.white)

        Text(number)
            .font(.system(size: 36))
            .fontWeight(.bold)
            .foregroundColor(.white)

        Text(title)
            .foregroundColor(.white)
            .fontWeight(.medium)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 150)

    .background(
        LinearGradient(
            colors: [
                Color(
                    red: 0.29,
                    green: 0.56,
                    blue: 0.89
                ),
                Color(
                    red: 0.20,
                    green: 0.45,
                    blue: 0.80
                )
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )

    .cornerRadius(24)

    .shadow(
        color: .black.opacity(0.12),
        radius: 10,
        x: 0,
        y: 5
    )
}


}

struct SectionCard<Content: View>: View {


let title: String
let content: Content

init(
    title: String,
    @ViewBuilder content: () -> Content
) {
    self.title = title
    self.content = content()
}

var body: some View {

    VStack(
        alignment: .leading,
        spacing: 16
    ) {

        Text(title)
            .font(.title3)
            .fontWeight(.bold)

        content
    }
    .frame(
        maxWidth: .infinity,
        alignment: .leading
    )

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

struct ScheduleRow: View {


let time: String
let subject: String

var body: some View {

    HStack {

        Text(time)
            .fontWeight(.bold)

        Divider()

        Text(subject)

        Spacer()
    }
}


}

struct ExamRow: View {


let title: String
let dday: String

var body: some View {

    HStack {

        VStack(
            alignment: .leading
        ) {

            Text(title)
                .fontWeight(.semibold)

            Text("시험 예정")
                .font(.caption)
                .foregroundColor(.gray)
        }

        Spacer()

        Text(dday)
            .fontWeight(.bold)
            .foregroundColor(.blue)
    }
    .padding()
    .background(
        Color.blue.opacity(0.08)
    )
    .cornerRadius(16)
}


}

#Preview {
HomeView()
}
