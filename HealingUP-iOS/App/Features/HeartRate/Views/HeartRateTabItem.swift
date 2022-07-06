//
//  HeartRateCheck.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 24/05/22.
//

import SwiftUI
import SwiftUICharts
import Introspect

struct HeartRateTabItem: View {
  let navigator: HeartRateNavigator
  @ObservedObject var heart = HeartRateViewModel()
  @ObservedObject var viewModel: MembershipViewModel
  @ObservedObject var session = SessionManager.shared
  @State private var value = 0
  @State private var selectedDateIndex = 0
  @State private var minimumHrv: Double = 0
  @State private var age = 0
  @State private var isKessler = false
  @Binding var tabSelection: Int
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .center) {
        
        Picker("What is your favorite color?", selection: $selectedDateIndex) {
          Text("Today").tag(0)
          Text("Week").tag(1)
          Text("Month").tag(2)
        }
        .pickerStyle(.segmented)
        
        switch selectedDateIndex {
        case 0:
          if !heart.todayHRV.isEmpty {
            valueCard(progress: Double(heart.calculateAverage(datas: heart.todayHRV)), minimumHrv: self.minimumHrv)
              .padding(.top)
            recomendationCard(value: Double(heart.calculateAverage(datas: heart.todayHRV)))
            
            VStack(alignment: .leading) {
              Text("Chart")
                .fontWeight(.bold)
                .font(.system(size: 18))
                .foregroundColor(.gray)
              
              if let data = heart.dataToday {
                LineChart(chartData: data)
                  .xAxisLabels(chartData: data)
                  .yAxisLabels(chartData: data)
                  .frame(height: UIScreen.main.bounds.height/3)
                  .padding()
              }
              
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 0)
          } else {
            emptyDataView()
          }
          
        case 1:
          if !heart.weekHRV.isEmpty {
            valueCard(progress: Double(heart.calculateAverage(datas: heart.weekHRV)), minimumHrv: self.minimumHrv)
              .padding(.top)
            recomendationCard(value: Double(heart.calculateAverage(datas: heart.weekHRV)))
            VStack(alignment: .leading) {
              Text("Chart")
                .fontWeight(.bold)
                .font(.system(size: 18))
                .foregroundColor(.gray)
              
              if let data = heart.dataWeek {
                LineChart(chartData: data)
                  .xAxisLabels(chartData: data)
                  .yAxisLabels(chartData: data)
                  .frame(height: UIScreen.main.bounds.height/3)
                  .padding(.horizontal)
              }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 0)
          } else {
            emptyDataView()
          }
          
        default:
          if !heart.monthHRV.isEmpty {
            valueCard(progress: Double(heart.calculateAverage(datas: heart.monthHRV)), minimumHrv: self.minimumHrv)
              .padding(.top)
            recomendationCard(value: Double(heart.calculateAverage(datas: heart.monthHRV)))
            VStack(alignment: .leading) {
              Text("Chart")
                .fontWeight(.bold)
                .font(.system(size: 18))
                .foregroundColor(.gray)
              
              if let data = heart.dataMonth {
                LineChart(chartData: data)
                  .xAxisLabels(chartData: data)
                  .yAxisLabels(chartData: data)
                  .frame(height: UIScreen.main.bounds.height/3)
                  .padding()
              }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 0)
          } else {
            emptyDataView()
          }
        }
        infoCard()
          .padding(.top)
      }.padding()
    }
    .onViewStatable(
      viewModel.$userState,
      onSuccess: { data in
        minimumHrv = data.minimumHrv
        age = data.age
        SessionManager.setUserAge(age: data.age)
        SessionManager.setHrvNormal(hrv: data.minimumHrv)
      })
    .onAppear {
      viewModel.fetchUser()
    }
    .progressHUD(isShowing: $viewModel.userState.isLoading)
  }
  
  @ViewBuilder
  private func emptyDataView() -> some View {
    VStack {
      Text("No Data")
        .fontWeight(.bold)
        .font(.system(size: 20))
        .foregroundColor(.gray)
        .padding(.bottom, 2)
      
      Text("Please use your apple watch, data will appear when apple watch measure and save your data")
        .fontWeight(.medium)
        .font(.system(size: 15))
        .foregroundColor(.gray)
        .multilineTextAlignment(.center)
      
    }.padding()
  }
  
  @ViewBuilder
  private func infoCard() -> some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Image(systemName: "info.circle")
          .font(.system(size: 17, weight: .medium))
          .foregroundColor(.blue)
        Text("About Heart Rate Variability")
          .font(.system(size: 17, weight: .medium))
          .foregroundColor(.blue)
      }
      
      Text("Heart Rate Variability (HRV) is a measure of the variation in the time interval between heart beats. Apple Watch calculates HRV by using the standard  deviation of beat-to-beat measurements which are captured by the heart rate sensor. HRV is validated for users over the age of 18. Third party apps and devices can also add HRV to Health.")
        .font(.caption2)
        .multilineTextAlignment(.leading)
    }
  }
  
  @ViewBuilder
  private func valueCard(progress: Double, minimumHrv: Double) -> some View {
    VStack(alignment: .leading) {
      Text("Average")
        .fontWeight(.bold)
        .font(.system(size: 18))
        .foregroundColor(.gray)
      HStack(alignment: .center, spacing: 20) {
        VStack(alignment: .leading) {
          ZStack {
            CircularProgressView(progress: progress/150, minimumValue: minimumHrv)
            Text("\((progress/150) * 100, specifier: "%.0f") ms")
              .font(.system(size: 18, weight: .bold))
              .foregroundColor(.gray)
              .bold()
          }
          .frame(width: 100, height: 100)
          .padding()
        }
        Spacer()
        VStack(alignment: .leading, spacing: 5) {
          Text("Status")
            .fontWeight(.bold)
            .font(.system(size: 17))
            .foregroundColor(.gray)
          
          Text("Age")
            .fontWeight(.bold)
            .font(.system(size: 17))
            .foregroundColor(.gray)
        }
        
        VStack(alignment: .leading, spacing: 5) {
          Text((progress/150 * 100) < minimumHrv ? "Bad" : "Good")
            .fontWeight(.bold)
            .font(.system(size: 17))
            .foregroundColor((progress/150 * 100) < minimumHrv ? .pink : .blue)
          
          Text("\(age)")
            .fontWeight(.bold)
            .font(.system(size: 17))
            .foregroundColor(.black)
        }
        Spacer()
      }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(10)
    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 0)
  }
  
  @ViewBuilder
  private func recomendationCard(value: Double) -> some View {
    VStack(alignment: .leading) {
      Text("Recomendation")
        .fontWeight(.bold)
        .font(.system(size: 18))
        .foregroundColor(.gray)
      
      HStack {
        Spacer()
        Text((value/150 * 100) < minimumHrv ? "Your HRV is lower than the normal range, your HRV can be affected by stress, you can check your stress level by answering these questions." : "You are doing well, keep it up and HRV levels")
          .fontWeight(.regular)
          .font(.system(size: 16))
          .foregroundColor((value/150 * 100) < minimumHrv ? .pink : .blue)
          .padding(.top, 5)
        Spacer()
      }
      NavigationLink(destination: navigator.navigateToKesslerTabItem(), isActive: $isKessler) {
        EmptyView()
      }
      if (value/150 * 100) < minimumHrv {
        HStack {
          Spacer()
          Button {
            self.tabSelection = 2
          }label: {
            Text("Get Started")
              .fontWeight(.medium)
              .padding(10)
              .background(Color.blue)
              .foregroundColor(.white)
              .cornerRadius(5)
          }
        }.padding(.top, 10)
      }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(10)
    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 0)
  }
}


struct HeartRateCheck_Previews: PreviewProvider {
  static var previews: some View {
    HeartRateTabItem(navigator: AppAssembler.shared.resolve(), viewModel: AppAssembler.shared.resolve(), tabSelection: .constant(1))
  }
}
