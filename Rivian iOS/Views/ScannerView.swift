import SwiftUI
import CoreBluetooth

struct ScannerView: View {
    
    @EnvironmentObject var central: CentralManager
    @Binding var selectedPeripheral: Peripheral?
    @Binding var selectedVehicle: Vehicle
    
    func scan() {
        self.central.scanForPeripherals(
            withServices: [.r1s_main_id, .r1t_main_id],
            options: [CBPeripheralManagerOptionShowPowerAlertKey: true]
        )
    }
    
    func connectPeripheral(_ scanPeriph:ScannedPeripheral){
        self.central.connect(scanPeriph.peripheral.peripheral, options: nil)
        self.selectedVehicle = scanPeriph.asVehicle()!
    }
    
    var body: some View {
        VStack(spacing:0) {
            Group {
                VStack {
                    HStack {
                        Text("Nearby Devices").fontWeight(.semibold).font(.system(size: 20))
                        Spacer()
                        Button(action:scan){ Text("Scan").padding() }
                    }
                    .frame(height: 52)
                    .padding(.horizontal)
                }
                .overlay(Divider(), alignment: .bottom)
                .animation(nil)
                    
                ScrollView {
                    VStack(spacing:0) {
                        ForEach(central.scannedPeripherals.sorted(by: { $0.rssi.intValue > $1.rssi.intValue })) { c in
                            Button(action: { self.connectPeripheral(c) }){
                                HStack {
                                    VStack(alignment: .leading, spacing: 0){
                                        Text((c.advertisment[CBAdvertisementDataLocalNameKey] as? String) ?? "")
                                            .font(.title).fontWeight(.bold)
                                        Text(c.peripheral.name).font(.footnote).opacity(0.6)
                                        
                                        if c.asVehicle() != nil {
                                            VehicleView(vehicle: c.asVehicle()!)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.vertical)
                                .foregroundColor(.primary)
                            }
                            Divider()
                        }.animation(nil)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.horizontal)
                }
            }
            
        }
        .onReceive(central.$state, perform: {
            if $0 == .poweredOn {
                self.scan()
            }
        })
        .onReceive(central.$connectedPeripherals, perform: {
            self.selectedPeripheral = $0.first
        })
    }
}
