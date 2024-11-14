//
//  VersionView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/10/24.
//

import SwiftUI

struct VersionView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        loadedView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("blackback")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }

                }
            }
    }
    var loadedView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("📱 WEDLE 위들 버전 정보")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 5)
                
                Text("현재 버전: 1.0.0")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Divider()
                
                Text("이번 1.0.0 버전에서는 대학 생활에 필요한 다양한 정보와 기능을 제공합니다:")
                    .font(.body)
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 20) {
                    versionFeature(icon: "🎉", title: "대학교 축제 정보", description: "캠퍼스별로 최신 축제 일정과 정보를 제공합니다")
                    versionFeature(icon: "🍜", title: "맛집 추천", description: "대학교 주변의 인기 맛집을 소개합니다")
                    versionFeature(icon: "🔍", title: "학과 매칭", description: "나와 어울리는 학과를 찾아주는 학과 매칭 서비스를 제공합니다")
                    versionFeature(icon: "📰", title: "대입 관련 기사", description: "최신 대입 관련 뉴스를 확인할 수 있습니다")
                    versionFeature(icon: "📊", title: "대학 랭킹", description: "다양한 기준으로 평가한 대학 순위를 제공합니다")
                    versionFeature(icon: "🏠", title: "월세 정보", description: "캠퍼스 주변의 월세 시세를 알아볼 수 있습니다")
                    versionFeature(icon: "🤝", title: "대학 연계 활동", description: "대학에서 참여할 수 있는 다양한 활동을 추천합니다")
                    versionFeature(icon: "📍", title: "주변 핫플레이스", description: "캠퍼스 근처의 인기 명소를 소개합니다")
                    versionFeature(icon: "💼", title: "취업률 정보", description: "졸업 후 취업률을 통해 대학의 강점을 확인할 수 있습니다")
                    versionFeature(icon: "📈", title: "경쟁률 (수시/정시)", description: "지원 경쟁률을 확인하고 준비에 참고할 수 있습니다")
                    versionFeature(icon: "💸", title: "등록금 정보", description: "대학교의 등록금 정보를 제공합니다")
                    versionFeature(icon: "🏫", title: "학과 정보", description: "각 학과의 소개와 정보를 확인할 수 있습니다")
                    versionFeature(icon: "📅", title: "대입 캘린더 및 알림", description: "대입 일정과 알림을 받아볼 수 있습니다")
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
    
    private func versionFeature(icon: String, title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("• \(icon) \(title)")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    VersionView()
}
