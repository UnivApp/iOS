//
//  MouDetailView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import SwiftUI

struct MouDetailView: View {
    var model: MouModel
    @Binding var isPopup: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        self.isPopup = false
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 20)
            
            Text(model.title)
                .font(.system(size: 16, weight: .bold))
            
            HStack {
                Text(model.category)
                    .font(.system(size: 12, weight: .semibold))
                Spacer()
                if let websiteLink = model.link {
                    Button {
                        if let url = URL(string: websiteLink){
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("👉🏻 웹사이트로 이동")
                            .foregroundColor(.blue.opacity(5.0))
                            .font(.system(size: 12, weight: .regular))
                            .overlay(alignment: .bottom) {
                                Color.blue.opacity(5.0)
                                    .frame(height: 1)
                            }
                    }
                }
            }
            Divider()
            ScrollView(.vertical, showsIndicators: true) {
                Text(model.content)
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.bottom, 30)
            }
        }
        .foregroundColor(.black)
        .multilineTextAlignment(.leading)
        .lineSpacing(5)
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 20)
        .background(.white)
        .cornerRadius(15)
        .padding(.horizontal, 20)
        .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height / 1.8)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct MouDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPopup: Bool = false
        MouDetailView(model: MouModel(expoId: 1, title: "2024학년도 지역대학 연계 진로체험", category: "전공체험", expoYear: "2025학년도", status: "접수 중", link: "https://www.ggoomgil.go.kr/front/index.do", location: "한남대학교, 해당 중·고등학교 및 온라인", content: "2024학년도 지역대학 연계 진로체험 프로그램을 아래와 같이 운영하오니 많은 신청 바랍니다.\n\n1. 일시: 2024. 04. ~ 12.\n\n2. 장소: 한남대학교, 해당 중·고교 및 온라인 운영 (신청 가능 지역)\n\n3. 대상: 대전지역 중·고등학생\n\n4. 운영방법: 대면(대학방문형, 중·고교방문형) 및 비대면(블렌디드 진로체험 등) 병행\n\n5. 신청방법: 중·고등학교 업무담당교사가 「꿈길」을 통해 진로체험 프로그램 신청 (https://www.ggoomgil.go.kr/front/index.do)\n\n6. 문의: 한남대학교 입학관리실 담당자 (☎042-629-7958)", date: "2024-04-01 ~ 2024-12-31"), isPopup: $isPopup)
    }
}
