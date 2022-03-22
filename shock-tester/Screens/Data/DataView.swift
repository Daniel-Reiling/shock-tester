//
//  DataView.swift
//  shock-tester
//
//  Created by Daniel Reiling on 3/22/22.
//

import SwiftUI
import CoreMotion

class DataViewModel: ObservableObject {
    
    @Published var data: CMAccelerometerData? = nil
    
    let motionManager: CMMotionManager!
    var timer: Timer? = nil
    
    init() {
        motionManager = CMMotionManager()
        
    }
    
    func startUpdating() {
        motionManager.startAccelerometerUpdates()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            self?.readData()
        })
    }
    
    private func readData() {
        data = motionManager.accelerometerData
    }
}


struct DataView: View {
    
    @StateObject var viewModel = DataViewModel()
    
    var body: some View {
        NavigationView {
            List {
                
                if let data = viewModel.data {
                    
                    let x = data.acceleration.x
                    let y = data.acceleration.y
                    let z = data.acceleration.z
                    let mag = sqrt(x*x+y*y+z*z)
                    
                    Section(header: Text("Accelration")) {
                        DataRow(title: "X", value: String(format: "%.3f", data.acceleration.x))
                        DataRow(title: "Y", value: String(format: "%.3f", data.acceleration.y))
                        DataRow(title: "Z", value: String(format: "%.3f", data.acceleration.z))
                        DataRow(title: "Magnitude", value: String(format: "%.3f", mag))
                    }
                } else {
                    Text("\"No Data\"")
                }
                
            }
            .navigationTitle("Data")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                viewModel.startUpdating()
            }
        }
    }
}

struct DataRow: View {
    
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .font(.system(.title2, design: .monospaced))
        }
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView()
    }
}
