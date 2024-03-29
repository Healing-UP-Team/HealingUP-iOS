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
        Picker("HRV", selection: $selectedDateIndex) {
          Text("Hari ini").tag(0)
          Text("Minggu").tag(1)
          Text("Bulan").tag(2)
        }
        .pickerStyle(.segmented)

        switch selectedDateIndex {
        case 0:
          if !heart.todayHRV.isEmpty {
            valueCard(progress: Double(heart.calculateAverage(datas: heart.todayHRV)), minimumHrv: self.minimumHrv)
              .padding(.top)
            Divider()
            recomendationCard(value: Double(heart.calculateAverage(datas: heart.todayHRV)))
            Divider()
            VStack(alignment: .leading) {
              Text("Data")
                .fontWeight(.bold)
                .font(.system(size: 18))
                .foregroundColor(Color(uiColor: .accentPurple))
                .padding(.horizontal)

              if let data = heart.dataToday {
                LineChart(chartData: data)
                  .xAxisLabels(chartData: data)
                  .yAxisLabels(chartData: data)
                  .frame(height: UIScreen.main.bounds.height/3)
                  .padding()
              }
            }
            .padding(.vertical)
          } else {
            emptyDataView()
          }

        case 1:
          if !heart.weekHRV.isEmpty {
            valueCard(progress: Double(heart.calculateAverage(datas: heart.weekHRV)), minimumHrv: self.minimumHrv)
              .padding(.top)
            Divider()
            recomendationCard(value: Double(heart.calculateAverage(datas: heart.weekHRV)))
            Divider()
            VStack(alignment: .leading) {
              Text("Data")
                .fontWeight(.bold)
                .font(.system(size: 18))
                .foregroundColor(Color(uiColor: .accentPurple))
                .padding(.horizontal)

              if let data = heart.dataWeek {
                LineChart(chartData: data)
                  .xAxisLabels(chartData: data)
                  .yAxisLabels(chartData: data)
                  .frame(height: UIScreen.main.bounds.height/3)
                  .padding(.horizontal)
              }
            }
            .padding(.vertical)
          } else {
            emptyDataView()
          }

        default:
          if !heart.monthHRV.isEmpty {
            valueCard(progress: Double(heart.calculateAverage(datas: heart.monthHRV)), minimumHrv: self.minimumHrv)
              .padding(.top)
            Divider()
            recomendationCard(value: Double(heart.calculateAverage(datas: heart.monthHRV)))
            Divider()
            VStack(alignment: .leading) {
              Text("Data")
                .fontWeight(.bold)
                .font(.system(size: 18))
                .foregroundColor(Color(uiColor: .accentPurple))
                .padding(.horizontal)

              if let data = heart.dataMonth {
                LineChart(chartData: data)
                  .xAxisLabels(chartData: data)
                  .yAxisLabels(chartData: data)
                  .frame(height: UIScreen.main.bounds.height/3)
                  .padding()
              }
            }
            .padding(.vertical)
          } else {
            emptyDataView()
          }
        }
        Divider()
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
      UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.softBlue
      UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.accentPurple], for: .selected)
      UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
    }
    .progressHUD(isShowing: $viewModel.userState.isLoading)
  }

  @ViewBuilder
  private func emptyDataView() -> some View {
    VStack {
      Text("Tidak ada Data")
        .fontWeight(.bold)
        .font(.system(size: 20))
        .foregroundColor(Color(uiColor: .accentPurple))
        .padding(.bottom, 2)

      Text("Tolong gunakan apple watch kamu, jika kamu baru saja menggunakan apple watch dan data belum ditampilkan, kamu bisa membuka aplikasi Breathe pada apple watch kamu dan mulai menggunakan fitur breathing. Aplikasi akan membutuhkan waktu beberapa saat untuk menerima data dari apple watch.")
        .fontWeight(.medium)
        .font(.system(size: 15))
        .foregroundColor(.gray)
        .multilineTextAlignment(.leading)

    }
    .padding(.vertical)
  }

  @ViewBuilder
  private func infoCard() -> some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Image(systemName: "info.circle")
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color(uiColor: .accentPurple))
        Text("Tentang Heart Rate Variability")
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color(uiColor: .accentPurple))
      }

      Text("Heart Rate Variability (HRV) adalah ukuran variasi dalam interval waktu antara detak jantung. Apple Watch menghitung HRV dengan menggunakan standar deviasi pengukuran detak ke detak yang ditangkap oleh sensor detak jantung.")
        .font(.system(size: 13))
        .multilineTextAlignment(.leading)
        .foregroundColor(.gray)
    }
    .padding(.vertical)
  }

  @ViewBuilder
  private func valueCard(progress: Double, minimumHrv: Double) -> some View {
    VStack(alignment: .center) {
      Text("Rata-Rata")
        .fontWeight(.medium)
        .font(.system(size: 15))
        .foregroundColor(.gray)

      Text("Heart Rate Variability")
        .fontWeight(.bold)
        .font(.system(size: 18))
        .foregroundColor(Color(uiColor: .accentPurple))
      HStack {
        Spacer()
        VStack(alignment: .leading) {
          ZStack {
            CircularProgressView(progress: progress/150, minimumValue: minimumHrv)
            Text("\((progress/150) * 100, specifier: "%.0f") ms")
              .font(.system(size: 18, weight: .bold))
              .foregroundColor(.gray)
              .bold()
          }
          .frame(width: 120, height: 120)
          .padding()
        }
        Spacer()
        VStack(alignment: .leading, spacing: 5) {
          HStack {
            Image(systemName: "chevron.forward.circle")
              .foregroundColor(Color(uiColor: .accentPurple))

            VStack(alignment: .leading) {
              Text((progress/150 * 100) < minimumHrv ? "Buruk" : "Baik")
                .fontWeight(.bold)
                .font(.system(size: 20))
                .foregroundColor((progress/150 * 100) < minimumHrv ? .pink : .blue)

              Text("Status")
                .fontWeight(.medium)
                .font(.system(size: 10))
                .foregroundColor(.gray)
            }
          }
          HStack {
            Image(systemName: "chevron.forward.circle")
              .foregroundColor(Color(uiColor: .accentPurple))

            VStack(alignment: .leading) {
              Text("\(Int(minimumHrv)) ms")
                .fontWeight(.bold)
                .font(.system(size: 17))
                .foregroundColor(.black)
                .padding(.top, 5)

              Text("HRV Minimal")
                .fontWeight(.medium)
                .font(.system(size: 10))
                .foregroundColor(.gray)
            }
          }
          HStack {
            Image(systemName: "chevron.forward.circle")
              .foregroundColor(Color(uiColor: .accentPurple))

            VStack(alignment: .leading) {
              Text("\(age)")
                .fontWeight(.bold)
                .font(.system(size: 17))
                .foregroundColor(.black)
                .padding(.top, 5)

              Text("Umur")
                .fontWeight(.medium)
                .font(.system(size: 10))
                .foregroundColor(.gray)
            }
          }
        }
        Spacer()
      }
    }
    .padding(.vertical)
  }

  @ViewBuilder
  private func recomendationCard(value: Double) -> some View {
    VStack(alignment: .center) {
      HStack {
        Text("Rekomendasi")
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color(uiColor: .accentPurple))
        Spacer()
      }
      HStack {
        Text((value/150 * 100) < minimumHrv ? "HRV kamu lebih rendah dari kisaran normal, HRV kamu dapat dipengaruhi oleh stres, kamu dapat memeriksa tingkat stres kamu dengan menjawab beberapa pertanyaan dan aplikasi akan memberikan rekomendasi." : "Kamu baik-baik saja, pertahankan dan tingkatkan HRV kamu")
          .fontWeight(.regular)
          .font(.system(size: 16))
          .foregroundColor(.black)
          .padding(.top, 5)
        Spacer()
      }
      if (value/150 * 100) < minimumHrv {
        ButtonDefaultView(title: "Mulai") {
          self.tabSelection = 2
        }
        .padding(.vertical)
      }
    }
    .padding()
  }
}

struct HeartRateCheck_Previews: PreviewProvider {
  static var previews: some View {
    HeartRateTabItem(navigator: AppAssembler.shared.resolve(), viewModel: AppAssembler.shared.resolve(), tabSelection: .constant(1))
  }
}
