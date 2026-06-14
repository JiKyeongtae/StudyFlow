//
//  ContentView.swift
//  StudyFlow
//
//  Created by 지경태 on 6/14/26.
//

import SwiftUI

struct ContentView: View {

    var body: some View {

        TabView {

            HomeView()
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }

            ScheduleView()
                .tabItem {
                    Label("일정", systemImage: "calendar")
                }

            AssignmentView()
                .tabItem {
                    Label("과제", systemImage: "doc.text")
                }

            ExamView()
                .tabItem {
                    Label("시험", systemImage: "graduationcap")
                }

            TimetableView()
                .tabItem {
                    Label("시간표", systemImage: "tablecells")
                }
        }
    }
}

#Preview {
    ContentView()
}
