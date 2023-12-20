//
// ContentView.swift
// Timer
//
// Created by Stephen Posner on 10/3/23.
//
import SwiftUI

struct ExerciseSet {
    var reps: Int
    var originalMinutes: Int
    var originalSeconds: Int
    var timerValues: TimerSet
    var distance: String
}

struct TimerSet {
    var minutes: Int
    var seconds: Int
}

class YourClass: ObservableObject {
    private var timer: Timer?

    @Published var mySeconds: Int
    @Published var myMinutes: Int
    @Published var targetTimeInSeconds: Int
    @Published var currentSetIndex: Int
    @Published var sets: [ExerciseSet]
    @Published var timerIsRunning: Bool
    @Published var myReps: Int
    @Published var updateView = false

    init(sets: [ExerciseSet]) {
        self.sets = sets
        self.mySeconds = 0
        self.myMinutes = 0
        self.targetTimeInSeconds = 0
        self.currentSetIndex = 0
        self.timerIsRunning = false
        self.myReps = 0

        if sets.indices.contains(currentSetIndex) {
            let currentSet = sets[currentSetIndex]
            self.targetTimeInSeconds = currentSet.timerValues.minutes * 60 + currentSet.timerValues.seconds
            self.myMinutes = currentSet.timerValues.minutes
            self.mySeconds = currentSet.timerValues.seconds
            self.myReps = currentSet.reps
        }
    }

    var isTimerRunning: Bool {
        return timer != nil && timer!.isValid
    }

    func toggleTimer() {
        if isTimerRunning {
            resetTimer() // Reset the timer before starting a new set
        } else {
            startTimer()
        }
    }

    func startTimer() {
        guard timer == nil else {
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateTimer()
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func resetTimer() {
        timer?.invalidate()
        timer = nil
        mySeconds = 0
        myMinutes = 0
        timerIsRunning = false
    }

    func getTargetTime(y: String, x: String) {
        guard let minutes = Int(y), minutes >= 0,
              let seconds = Int(x), seconds >= 0 else {
            print("Invalid input for minutes or seconds.")
            return
        }
        let target = minutes * 60 + seconds
        targetTimeInSeconds = target
    }

    func updateTimer() {
        mySeconds += 1
        if mySeconds == 60 {
            mySeconds = 0
            myMinutes += 1
        }

        if myMinutes * 60 + mySeconds == targetTimeInSeconds + 1 {
            mySeconds = 0
            myMinutes = 0
            if myReps > 1 {
                myReps -= 1
            } else {
                // Reps reached 0, remove the first set and update the current set
                if !sets.isEmpty {
                    sets.remove(at: 0)
                    if !sets.isEmpty {
                        currentSetIndex = 0
                        let currentSet = sets[currentSetIndex]
                        self.targetTimeInSeconds = currentSet.timerValues.minutes * 60 + currentSet.timerValues.seconds
                        self.myMinutes = 0
                        self.mySeconds = 0
                        self.myReps = currentSet.reps
                    } else {
                        stopTimer()
                    }
                    updateView.toggle() // Trigger view update
                }
            }
        }
    }

    func startSets() {
        if !sets.isEmpty {
            let currentSet = sets[currentSetIndex]
            self.targetTimeInSeconds = currentSet.originalMinutes * 60 + currentSet.originalSeconds
            self.myMinutes = currentSet.originalMinutes
            self.mySeconds = currentSet.originalSeconds
            self.myReps = currentSet.reps
            resetTimer() // Reset the timer before starting a new set
            startTimer()
        }
    }

    func moveToNextSet() {
        if currentSetIndex < sets.count - 1 {
            currentSetIndex += 1
            let currentSet = sets[currentSetIndex]
            self.targetTimeInSeconds = currentSet.originalMinutes * 60 + currentSet.originalSeconds
            self.myMinutes = currentSet.originalMinutes
            self.mySeconds = currentSet.originalSeconds
            self.myReps = currentSet.reps
            startTimer()
        } else {
            // All sets are completed, stop the timer or handle completion logic
            stopTimer()
        }
    }

}

struct ContentView: View {
    @ObservedObject private var yourClassInstance: YourClass
    @State private var enteredReps1 = ""
    @State private var enteredDistance1 = ""
    @State private var enteredMinutes1 = ""
    @State private var enteredSeconds1 = ""

    @State private var enteredReps2 = ""
    @State private var enteredDistance2 = ""
    @State private var enteredMinutes2 = ""
    @State private var enteredSeconds2 = ""
    
    @State private var enteredReps3 = ""
    @State private var enteredDistance3 = ""
    @State private var enteredMinutes3 = ""
    @State private var enteredSeconds3 = ""

    @State private var enteredReps4 = ""
    @State private var enteredDistance4 = ""
    @State private var enteredMinutes4 = ""
    @State private var enteredSeconds4 = ""
    
    @State private var enteredReps5 = ""
    @State private var enteredDistance5 = ""
    @State private var enteredMinutes5 = ""
    @State private var enteredSeconds5 = ""
    
    @State private var enteredReps6 = ""
    @State private var enteredDistance6 = ""
    @State private var enteredMinutes6 = ""
    @State private var enteredSeconds6 = ""
    
    @State private var enteredReps7 = ""
    @State private var enteredDistance7 = ""
    @State private var enteredMinutes7 = ""
    @State private var enteredSeconds7 = ""
    
    @State private var enteredReps8 = ""
    @State private var enteredDistance8 = ""
    @State private var enteredMinutes8 = ""
    @State private var enteredSeconds8 = ""
    
    @State private var enteredReps9 = ""
    @State private var enteredDistance9 = ""
    @State private var enteredMinutes9 = ""
    @State private var enteredSeconds9 = ""
    
    @State private var enteredReps10 = ""
    @State private var enteredDistance10 = ""
    @State private var enteredMinutes10 = ""
    @State private var enteredSeconds10 = ""
    
    init() {
        let sets: [ExerciseSet] = []
        self._yourClassInstance = ObservedObject(wrappedValue: YourClass(sets: sets))
        self.yourClassInstance.startSets()
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                VStack{
                    Text("Set 1:")
                    HStack {
                        TextField("Distance", text: $enteredDistance1)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Reps", text: $enteredReps1)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            TextField("", text: $enteredMinutes1)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("min")
                        }
                        HStack {
                            TextField("", text: $enteredSeconds1)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("sec")
                        }
                    }
                    Text("Set 2:")
                    HStack {
                        TextField("Distance", text: $enteredDistance2)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Reps", text: $enteredReps2)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            TextField("", text: $enteredMinutes2)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("min")
                        }
                        HStack {
                            TextField("", text: $enteredSeconds2)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("sec")
                        }
                    }
                    Text("Set 3:")
                    HStack {
                        TextField("Distance", text: $enteredDistance3)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Reps", text: $enteredReps3)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            TextField("", text: $enteredMinutes3)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("min")
                        }
                        HStack {
                            TextField("", text: $enteredSeconds3)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("sec")
                        }
                    }
                    Text("Set 4:")
                    HStack {
                        TextField("Distance", text: $enteredDistance4)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Reps", text: $enteredReps4)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            TextField("", text: $enteredMinutes4)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("min")
                        }
                        HStack {
                            TextField("", text: $enteredSeconds4)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("sec")
                        }
                    }
                }
                VStack{
                    Text("Set 5:")
                    HStack {
                        TextField("Distance", text: $enteredDistance5)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Reps", text: $enteredReps5)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            TextField("", text: $enteredMinutes5)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("min")
                        }
                        HStack {
                            TextField("", text: $enteredSeconds5)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("sec")
                        }
                    }
                    Text("Set 6:")
                    HStack {
                        TextField("Distance", text: $enteredDistance6)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Reps", text: $enteredReps6)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            TextField("", text: $enteredMinutes6)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("min")
                        }
                        HStack {
                            TextField("", text: $enteredSeconds6)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("sec")
                        }
                    }
                    Text("Set 7:")
                    HStack {
                        TextField("Distance", text: $enteredDistance7)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Reps", text: $enteredReps7)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            TextField("", text: $enteredMinutes7)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("min")
                        }
                        HStack {
                            TextField("", text: $enteredSeconds7)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("sec")
                        }
                    }
                    Text("Set 8:")
                    HStack {
                        TextField("Distance", text: $enteredDistance8)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Reps", text: $enteredReps8)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            TextField("", text: $enteredMinutes8)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("min")
                        }
                        HStack {
                            TextField("", text: $enteredSeconds8)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("sec")
                        }
                    }
                    Text("Set 9:")
                    HStack {
                        TextField("Distance", text: $enteredDistance9)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Reps", text: $enteredReps9)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            TextField("", text: $enteredMinutes9)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("min")
                        }
                        HStack {
                            TextField("", text: $enteredSeconds9)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("sec")
                        }
                    }
                }
                VStack{
                    Text("Set 10:")
                    HStack {
                        TextField("Distance", text: $enteredDistance10)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Reps", text: $enteredReps10)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            TextField("", text: $enteredMinutes10)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("min")
                        }
                        HStack {
                            TextField("", text: $enteredSeconds10)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("sec")
                        }
                    }
                }
                VStack{
                    HStack {
                        Button(action: {
                            // Check if user input is valid for Set 1
                            if let minutes = Int(enteredMinutes1),
                               let seconds = Int(enteredSeconds1),
                               let reps = Int(enteredReps1) {
                                let newSet1 = ExerciseSet(reps: reps, originalMinutes: minutes, originalSeconds: seconds, timerValues: TimerSet(minutes: minutes, seconds: seconds), distance: enteredDistance1)
                                yourClassInstance.sets.append(newSet1)
                            }
                            
                            // Check if user input is valid for Set 2
                            if let minutes = Int(enteredMinutes2),
                               let seconds = Int(enteredSeconds2),
                               let reps = Int(enteredReps2) {
                                let newSet2 = ExerciseSet(reps: reps, originalMinutes: minutes, originalSeconds: seconds, timerValues: TimerSet(minutes: minutes, seconds: seconds), distance: enteredDistance2)
                                yourClassInstance.sets.append(newSet2)
                            }
                            
                            if let minutes = Int(enteredMinutes3),
                               let seconds = Int(enteredSeconds3),
                               let reps = Int(enteredReps3) {
                                let newSet3 = ExerciseSet(reps: reps, originalMinutes: minutes, originalSeconds: seconds, timerValues: TimerSet(minutes: minutes, seconds: seconds), distance: enteredDistance3)
                                yourClassInstance.sets.append(newSet3)
                            }
                            if let minutes = Int(enteredMinutes4),
                               let seconds = Int(enteredSeconds4),
                               let reps = Int(enteredReps4) {
                                let newSet4 = ExerciseSet(reps: reps, originalMinutes: minutes, originalSeconds: seconds, timerValues: TimerSet(minutes: minutes, seconds: seconds), distance: enteredDistance4)
                                yourClassInstance.sets.append(newSet4)
                            }
                            if let minutes = Int(enteredMinutes5),
                               let seconds = Int(enteredSeconds5),
                               let reps = Int(enteredReps5) {
                                let newSet5 = ExerciseSet(reps: reps, originalMinutes: minutes, originalSeconds: seconds, timerValues: TimerSet(minutes: minutes, seconds: seconds), distance: enteredDistance5)
                                yourClassInstance.sets.append(newSet5)
                            }
                            if let minutes = Int(enteredMinutes6),
                               let seconds = Int(enteredSeconds6),
                               let reps = Int(enteredReps6) {
                                let newSet6 = ExerciseSet(reps: reps, originalMinutes: minutes, originalSeconds: seconds, timerValues: TimerSet(minutes: minutes, seconds: seconds), distance: enteredDistance6)
                                yourClassInstance.sets.append(newSet6)
                            }
                            if let minutes = Int(enteredMinutes7),
                               let seconds = Int(enteredSeconds7),
                               let reps = Int(enteredReps7) {
                                let newSet7 = ExerciseSet(reps: reps, originalMinutes: minutes, originalSeconds: seconds, timerValues: TimerSet(minutes: minutes, seconds: seconds), distance: enteredDistance7)
                                yourClassInstance.sets.append(newSet7)
                            }
                            if let minutes = Int(enteredMinutes8),
                               let seconds = Int(enteredSeconds8),
                               let reps = Int(enteredReps8) {
                                let newSet8 = ExerciseSet(reps: reps, originalMinutes: minutes, originalSeconds: seconds, timerValues: TimerSet(minutes: minutes, seconds: seconds), distance: enteredDistance8)
                                yourClassInstance.sets.append(newSet8)
                            }
                            if let minutes = Int(enteredMinutes9),
                               let seconds = Int(enteredSeconds9),
                               let reps = Int(enteredReps9) {
                                let newSet9 = ExerciseSet(reps: reps, originalMinutes: minutes, originalSeconds: seconds, timerValues: TimerSet(minutes: minutes, seconds: seconds), distance: enteredDistance9)
                                yourClassInstance.sets.append(newSet9)
                            }
                            if let minutes = Int(enteredMinutes10),
                               let seconds = Int(enteredSeconds10),
                               let reps = Int(enteredReps10) {
                                let newSet10 = ExerciseSet(reps: reps, originalMinutes: minutes, originalSeconds: seconds, timerValues: TimerSet(minutes: minutes, seconds: seconds), distance: enteredDistance10)
                                yourClassInstance.sets.append(newSet10)
                            }
                            
                            // Start the timer if it's not already running and sets are available
                            if !yourClassInstance.isTimerRunning && !yourClassInstance.sets.isEmpty {
                                yourClassInstance.startSets()
                            }
                        }) {
                            Text("Go")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            yourClassInstance.toggleTimer()
                        }) {
                            Text(yourClassInstance.isTimerRunning ? "Pause Timer" : "Start Timer")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            yourClassInstance.resetTimer()
                        }) {
                            Text("Reset Timer")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.top, 20)
                }
                .padding()
                .navigationBarTitle("")
                .navigationBarHidden(true) // Hide the default navigation bar
            }
            .onReceive(yourClassInstance.$myReps) { newReps in
                if newReps <= 0 {
                    // Reps reached 0, move to the next set
                    yourClassInstance.moveToNextSet()
                }
            }
        }
        VStack {
            Spacer()
            VStack(alignment: .center, spacing: 10) {
                Text("\(yourClassInstance.sets.first?.distance ?? "") on \(String(format: "%02d", yourClassInstance.sets.first?.originalMinutes ?? 0)):\(String(format: "%02d", yourClassInstance.sets.first?.originalSeconds ?? 0))")
                    .font(.system(size: 90))
                    .foregroundColor(.primary)
                
                Text("Reps Left: \(yourClassInstance.myReps)")
                    .font(.system(size: 90)) // Increase font size to 28 points
                    .foregroundColor(.primary)
                
                Text("\(String(format: "%02d", yourClassInstance.myMinutes)):\(String(format: "%02d", yourClassInstance.mySeconds))")
                    .font(.system(size: 300)) // Increase font size to 28 points
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 100)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
