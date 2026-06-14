//
//  ScheduleView.swift
//  StudyFlow
//
//  Created by 지경태 on 6/14/26.
//

import SwiftUI

struct ScheduleView: View {

    @State private var schedules = [
        "컴퓨터 과학",
        "수학"
    ]

    @State private var newSchedule = ""

    var body: some View {

        NavigationStack {

            VStack {

                HStack {

                    TextField(
                        "일정 입력",
                        text: $newSchedule
                    )
                    .textFieldStyle(.roundedBorder)

                    Button("추가") {

                        if !newSchedule.isEmpty {
                            schedules.append(newSchedule)
                            newSchedule = ""
                        }
                    }
                }
                .padding()

                List {

                    ForEach(
                        schedules,
                        id: \.self
                    ) { item in

                        Text(item)
                    }
                    .onDelete { indexSet in
                        schedules.remove(
                            atOffsets: indexSet
                        )
                    }
                }
            }
            .navigationTitle("일정")
        }
    }
}

#Preview {
    ScheduleView()
}
