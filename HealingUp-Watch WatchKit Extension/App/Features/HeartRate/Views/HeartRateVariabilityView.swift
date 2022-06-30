//
//  HeartRateVariabilityView.swift
//  HealingUp-Watch WatchKit Extension
//
//  Created by Dicky Buwono on 26/06/22.
//

import SwiftUI

struct HeartRateVariabilityView: View {
  @ObservedObject var heart = HeartRateViewModel()
  @State var minimumHrv = SessionManager.getHrvNormal()
  
    var body: some View {
      GeometryReader { proxy in
        TabView {
          configureTodayView(proxy: proxy, progress: Double(heart.calculateAverage(datas: heart.todayHRV)))
          configureWeekView(proxy: proxy, progress: Double(heart.calculateAverage(datas: heart.weekHRV)))
          configureMonthView(proxy: proxy, progress: Double(heart.calculateAverage(datas: heart.monthHRV)))
        }.tabViewStyle(.page)
      }
    }
  
  @ViewBuilder
  func configureTodayView(proxy: GeometryProxy, progress: Double) -> some View {
    VStack {
      Image(systemName: "heart.fill")
        .foregroundColor(Color.pink)
        .font(.system(size: 20))
      ZStack {
        CircularProgressView(progress: progress/150, minimumValue: minimumHrv, strokeWidth: 10)
          .frame(width: proxy.size.width/2.5, height: proxy.size.height/2.5, alignment: .center)
        Text("\((progress/150) * 100, specifier: "%.0f") ms")
          .font(.system(size: 13, weight: .medium))
      }
      .padding()
      
      Text("Today")
        .frame(width: proxy.size.width)
        .font(.system(size: 13, weight: .medium))
      
      Spacer()
      Text((progress/150 * 100) < minimumHrv ? "Bad" : "Good")
        .font(.system(size: 13, weight: .medium))
        .foregroundColor((progress/150 * 100) < minimumHrv ? .pink : .blue)
    }.padding(5)
  }
  
  @ViewBuilder
  func configureWeekView(proxy: GeometryProxy, progress: Double) -> some View {
    VStack {
      Image(systemName: "heart.fill")
        .foregroundColor(Color.pink)
        .font(.system(size: 20))
      ZStack {
        CircularProgressView(progress: progress/150, minimumValue: minimumHrv, strokeWidth: 10)
          .frame(width: proxy.size.width/2.5, height: proxy.size.height/2.5, alignment: .center)
        Text("\((progress/150) * 100, specifier: "%.0f") ms")
          .font(.system(size: 13, weight: .medium))
      }
      .padding()
      
      Text("Week")
        .frame(width: proxy.size.width)
        .font(.system(size: 13, weight: .medium))
      
      Spacer()
      Text((progress/150 * 100) < minimumHrv ? "Bad" : "Good")
        .font(.system(size: 13, weight: .medium))
        .foregroundColor((progress/150 * 100) < minimumHrv ? .pink : .blue)
    }.padding(5)
  }
  
  @ViewBuilder
  func configureMonthView(proxy: GeometryProxy, progress: Double) -> some View {
    VStack {
      Image(systemName: "heart.fill")
        .foregroundColor(Color.pink)
        .font(.system(size: 20))
      ZStack {
        CircularProgressView(progress: progress/150, minimumValue: SessionManager.getHrvNormal(), strokeWidth: 10)
          .frame(width: proxy.size.width/2.5, height: proxy.size.height/2.5, alignment: .center)
        Text("\((progress/150) * 100, specifier: "%.0f") ms")
          .font(.system(size: 13, weight: .medium))
      }
      .padding()
      
      Text("Month")
        .frame(width: proxy.size.width)
        .font(.system(size: 13, weight: .medium))
      
      Spacer()
      Text((progress/150 * 100) < minimumHrv ? "Bad" : "Good")
        .font(.system(size: 13, weight: .medium))
        .foregroundColor((progress/150 * 100) < minimumHrv ? .pink : .blue)
    }.padding(5)
  }
}

struct HeartRateVariabilityView_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateVariabilityView()
    }
}
