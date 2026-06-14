import SwiftUI

struct TimetableView: View {

    let classes = [
        ("월", "컴퓨터 과학"),
        ("화", "수학"),
        ("수", "물리 실험"),
        ("목", "영문학"),
        ("금", "캡스톤")
    ]

    var body: some View {

        NavigationStack {

            List(classes, id: \.0) { day, subject in

                HStack {

                    Text(day)
                        .font(.title2)
                        .bold()
                        .frame(width: 40)

                    VStack(alignment: .leading) {

                        Text(subject)
                            .font(.headline)

                        Text("09:00 ~ 10:30")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 8)
            }

            .navigationTitle("시간표")
        }
    }
}
