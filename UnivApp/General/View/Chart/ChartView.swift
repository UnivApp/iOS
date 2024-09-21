//
//  ChartView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/21/24.
//

import SwiftUI
import Charts

struct BarChartView: View {
    var title: String
    var description: String
    var dataPoints: [ChartData]
    var color: [Color] = [.red, .orange, .green, .yellow, .blue, .gray]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            
            HStack {
                Spacer()
                Text(description)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, -20)
            
            Chart {
                ForEach(dataPoints.indices, id: \.self) { index in
                    let point = dataPoints[index]
                    BarMark(
                        x: .value(point.xLabel, point.label),
                        y: .value(point.yLabel, point.value)
                    )
                    .opacity(0.9)
                    .foregroundStyle(color[index % color.count])
                    .annotation(position: .overlay) {
                        Text("\(Int(point.value))만원")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .chartYAxis{}
            .frame(height: 100)
            .aspectRatio(contentMode: .fit)
            .scaledToFit()
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .background(Color.homeColor)
        .cornerRadius(15)
    }
}

struct CircleChartView: View {
    var title: String
    var description: String
    var dataPoints: [ChartData]
    var color: [Color] = [.red, .orange, .green, .yellow, .blue, .gray]
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            
            HStack {
                Spacer()
                Text(description)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, -20)
            
            HStack {
                Chart {
                    ForEach(dataPoints.indices, id: \.self) { index in
                        let point = dataPoints[index]
                        SectorMark(
                            angle: .value(point.label, point.value),
                            angularInset: 1.5
                        )
                        .foregroundStyle(color[index % color.count])
                    }
                }
                .chartYAxis{}
                .frame(height: 100)
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
                
                Spacer()
                
                VStack(alignment: .leading) {
                    ForEach(dataPoints.indices, id: \.self) { index in
                        let point = dataPoints[index]
                        HStack {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(color[index % color.count])
                            Text(point.label)
                                .font(.system(size: 10, weight: .regular))
                        }
                    }
                }
            }
            .padding(.horizontal, 50)
            .padding(.vertical, 30)
        }
        .background(Color.homeColor)
        .cornerRadius(15)
    }
}

#Preview {
    CircleChartView(title: "계열별등록금", description: "출처: 대학어디가 - 2024년도", dataPoints: [
        ChartData(label: "인문사회계열", value: 673, xLabel: "과", yLabel: "만원"),
        ChartData(label: "자연과학계열", value: 796, xLabel: "과", yLabel: "만원"),
        ChartData(label: "공학계열", value: 898, xLabel: "과", yLabel: "만원"),
        ChartData(label: "의학", value: 1000, xLabel: "과", yLabel: "만원"),
        ChartData(label: "예체계열", value: 901, xLabel: "과", yLabel: "만원")
    ])
}
