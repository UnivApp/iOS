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
    var color: [Color] = [.red.opacity(0.7), .orange.opacity(0.7), .green.opacity(0.7), .yellow.opacity(0.7), .blue.opacity(0.7), .gray.opacity(0.7)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            
            HStack {
                Text((dataPoints.compactMap { $0.year }).first ?? "")
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.gray)
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
                        if title == "계열별등록금" {
                            Text(String(format: "%.0f만원", point.value))
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        } else {
                            Text(String(format: "%.1f", point.value))
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .chartYAxis{}
            .frame(height: 100)
            .aspectRatio(contentMode: .fit)
            .scaledToFill()
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
    var color: [Color] = [.red.opacity(0.7), .orange.opacity(0.7), .green.opacity(0.7), .yellow.opacity(0.7), .blue.opacity(0.7), .gray.opacity(0.7)]
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
                        .annotation(position: .overlay) {
                            Text(String(format: "%.1f", point.value))
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        }
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
