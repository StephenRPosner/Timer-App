//
// ContentView.swift
// Timer
//
// Created by Stephen Posner on 10/3/23.
//
import SwiftUI

struct ExerciseSet {
    var reps: Int
    var setReps: Int
    var originalSetReps: Int // Add this property
    var originalMinutes: Int
    var originalSeconds: Int
    var timerValues: TimerSet
    var distance: String
    var description: String
    var exerciseCount: Int
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
    @Published var currentExerciseIndex: Int
    @Published var currentSetIndex: Int
    @Published var sets: [ExerciseSet]
    @Published var timerIsRunning: Bool
    @Published var myReps: Int
    @Published var updateView = false
    @Published var exerciseInSet = 0
    @Published var setNum = 0
    
    private var currentSetReps: Int
    private var currentLineReps: Int

        init(sets: [ExerciseSet]) {
            self.sets = sets
            self.mySeconds = 0
            self.myMinutes = 0
            self.targetTimeInSeconds = 0
            self.currentExerciseIndex = 0
            self.currentSetIndex = 0
            self.timerIsRunning = false
            self.myReps = 0
            self.currentSetReps = 0 // Initialize currentSetReps
            self.currentLineReps = 0 // Initialize currentLineReps

            if !sets.isEmpty && sets.indices.contains(currentSetIndex) {
                let currentSet = sets[currentSetIndex]
                self.targetTimeInSeconds = currentSet.timerValues.minutes * 60 + currentSet.timerValues.seconds
                self.myMinutes = currentSet.timerValues.minutes
                self.mySeconds = currentSet.timerValues.seconds
                self.myReps = currentSet.reps
            }
            self.setNum = sets.count
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
                // Still more reps for the current exercise
                myReps -= 1
            } else {
                // Move to the next exercise in the set
                exerciseInSet -= 1
                currentExerciseIndex += 1

                if exerciseInSet > 0 && currentExerciseIndex < sets.count {
                    let currentExercise = sets[currentExerciseIndex]
                    self.targetTimeInSeconds = currentExercise.timerValues.minutes * 60 + currentExercise.timerValues.seconds
                    self.myMinutes = 0
                    self.mySeconds = 0
                    self.myReps = currentExercise.reps
                } else if exerciseInSet == 0 && currentSetReps > 1 {
                    // Repeat the current set
                    resetSet()
                    currentSetReps -= 1
                } else if exerciseInSet == 0 && currentSetReps == 1 && currentSetIndex < setNum - 1 {
                    // Move to the next set
                    currentSetIndex += 1
                    resetSet()
                } else {
                    // All sets and repetitions completed
                    stopTimer()
                }

                updateView.toggle() // Trigger view update
            }
        }
    }


    func resetSet() {
        let currentSet = sets[currentSetIndex]
        self.targetTimeInSeconds = currentSet.originalMinutes * 60 + currentSet.originalSeconds
        self.myMinutes = currentSet.originalMinutes
        self.mySeconds = currentSet.originalSeconds
        self.myReps = currentSet.reps
        self.exerciseInSet = currentSet.exerciseCount // Initialize exerciseInSet with the reps of the current set
        self.currentExerciseIndex = 0
    }



    func startSets() {
        if !sets.isEmpty && currentSetIndex < sets.count {
            let currentSet = sets[currentSetIndex]
            self.targetTimeInSeconds = currentSet.originalMinutes * 60 + currentSet.originalSeconds
            self.myMinutes = currentSet.originalMinutes
            self.mySeconds = currentSet.originalSeconds
            self.myReps = currentSet.reps
            self.exerciseInSet = currentSet.reps  // Set the exerciseInSet to the reps of the current set

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
       @State private var setInputs: [[(setReps: String, lineReps: String, distance: String, minutes: String, seconds: String, description: String)]]
       @State private var numberOfLines: [Int]

       @Environment(\.horizontalSizeClass) var horizontalSizeClass

       private var description = ""

    init() {
        let sets: [ExerciseSet] = []
        let yourClassInstance = YourClass(sets: sets)
        self._yourClassInstance = ObservedObject(wrappedValue: yourClassInstance)
        // Comment out the startSets() call here
        // yourClassInstance.startSets()
        self._setInputs = State(initialValue: [[(setReps: "", lineReps: "", distance: "", minutes: "", seconds: "", description: "")]])
        self._numberOfLines = State(initialValue: [1])
    }

    
    var body: some View {
            NavigationView {
                ZStack(alignment: .top) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            VStack {
                                ForEach(0..<setInputs.count, id: \.self) { setIndex in
                                    HStack {
                                        Text("Set \(setIndex + 1):")
                                        TextField("Set Reps", text: $setInputs[setIndex][0].setReps)
                                            .keyboardType(.numberPad)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                        
                                    }
                                    
                                    ForEach(0..<numberOfLines[setIndex], id: \.self) { lineIndex in
                                        if lineIndex < setInputs[setIndex].count {
                                            VStack {
                                                HStack {
                                                    TextField("Distance", text: $setInputs[setIndex][lineIndex].distance)
                                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    
                                                    
                                                    TextField("Reps", text: $setInputs[setIndex][lineIndex].lineReps)
                                                        .keyboardType(.numberPad)
                                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    
                                                    HStack {
                                                        TextField("0", text: $setInputs[setIndex][lineIndex].minutes)
                                                            .keyboardType(.numberPad)
                                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                                        
                                                        Text(":")
                                                    }
                                                    HStack {
                                                        TextField("00", text: $setInputs[setIndex][lineIndex].seconds)
                                                            .keyboardType(.numberPad)
                                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    }
                                                    Button(action: {
                                                        // Delete the Line
                                                        if lineIndex < setInputs[setIndex].count {
                                                            setInputs[setIndex].remove(at: lineIndex)
                                                        }
                                                    }) {
                                                        Text("X")
                                                            .font(.headline)
                                                            .foregroundColor(.white)
                                                            .padding()
                                                            .background(Color.red)
                                                            .cornerRadius(10)
                                                    }
                                                }
                                                TextField("Notes", text: $setInputs[setIndex][lineIndex].description)
                                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                            }
                                        }
                                    }
                                    
                                    Button(action: {
                                        // Add a new line to the set
                                        setInputs[setIndex].append(("", "", "", "", "", ""))
                                        numberOfLines[setIndex] += 1
                                    }) {
                                        Text("Add Line")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                    }
                                }
                                
                                Button(action: {
                                    // Add a new set
                                    setInputs.append([(setReps: "", lineReps: "", distance: "", minutes: "", seconds: "", description: "")])
                                    numberOfLines.append(1)
                                }) {
                                    Text("Add Set")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.green)
                                        .cornerRadius(10)
                                }
                            }


                        VStack {
                            HStack {
                                Button(action: {
                                    yourClassInstance.sets.removeAll()
                                    for setIndex in setInputs.indices {
                                        var setInputsForIndex: [(setReps: String, lineReps: String, distance: String, minutes: String, seconds: String, description: String)] = []

                                        for lineIndex in 0..<setInputs[setIndex].count {
                                            let input = setInputs[setIndex][lineIndex]
                                            if let minutes = Int(input.minutes),
                                               let seconds = Int(input.seconds),
                                               let lineReps = Int(input.lineReps) {
                                                let newSet = ExerciseSet(
                                                    reps: lineIndex < setInputs[setIndex].count ? Int(setInputs[setIndex][lineIndex].lineReps) ?? 0 : 0,
                                                    setReps: Int(setInputs[setIndex][0].setReps) ?? 1,
                                                    originalSetReps: Int(setInputs[setIndex][0].setReps) ?? 1,
                                                    originalMinutes: minutes,
                                                    originalSeconds: seconds,
                                                    timerValues: TimerSet(minutes: minutes, seconds: seconds),
                                                    distance: input.distance,
                                                    description: input.description,
                                                    exerciseCount: numberOfLines[setIndex] // Initialize exerciseCount with the number of lines in the set
                                                )

                                                yourClassInstance.sets.append(newSet)
                                            }

                                            setInputsForIndex.append((
                                                setReps: input.setReps,
                                                lineReps: input.lineReps,
                                                distance: input.distance,
                                                minutes: input.minutes,
                                                seconds: input.seconds,
                                                description: input.description
                                            ))
                                        }

                                        setInputs[setIndex] = setInputsForIndex
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
                                    if yourClassInstance.isTimerRunning {
                                        yourClassInstance.stopTimer()
                                    } else {
                                        yourClassInstance.startTimer()
                                    }
                                }) {
                                    Text(yourClassInstance.isTimerRunning ? "Pause" : "Start")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.green)
                                        .cornerRadius(10)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    // Reset button action
                                    yourClassInstance.resetTimer()
                                }) {
                                    Text("Reset Set")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.orange)
                                        .cornerRadius(10)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    for setIndex in setInputs.indices {
                                        for lineIndex in setInputs[setIndex].indices {
                                            // Clear all properties of the tuple
                                            setInputs[setIndex][lineIndex].setReps = ""
                                            setInputs[setIndex][lineIndex].lineReps = ""
                                            setInputs[setIndex][lineIndex].distance = ""
                                            setInputs[setIndex][lineIndex].minutes = ""
                                            setInputs[setIndex][lineIndex].seconds = ""
                                            setInputs[setIndex][lineIndex].description = ""
                                        }
                                    }
                                }) {
                                    Text("Clear All")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.red)
                                        .cornerRadius(10)
                                }

                            }
                            .padding(.top, 20)
                        }
                        .navigationBarTitle("") // Explicitly set an empty title
                        .navigationBarHidden(horizontalSizeClass == .compact) // Hide the navigation bar when in landscape mode
                        .navigationViewStyle(StackNavigationViewStyle())
                        .onAppear {
                            DispatchQueue.main.async {
                                // Hide the navigation bar when the view appears
                                UIApplication.shared.windows.first?.rootViewController?.navigationController?.setNavigationBarHidden(true, animated: false)
                            }
                        }
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
                        .font(.system(size: 90))
                        .foregroundColor(.primary)

                    Text("\(String(format: "%02d", yourClassInstance.myMinutes)):\(String(format: "%02d", yourClassInstance.mySeconds))")
                        .font(.system(size: 300))
                        .foregroundColor(.primary)
                    Text("\(yourClassInstance.sets.first?.description ?? "")")
                        .font(.system(size: 90))
                        .foregroundColor(.primary)
                }
                .padding(.bottom, 100)
                .padding(.top, 100)
            }
            .edgesIgnoringSafeArea(.all)
            .statusBar(hidden: true)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                    withAnimation {
                        self.yourClassInstance.updateView.toggle()
                    }
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
