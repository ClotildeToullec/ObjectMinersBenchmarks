Class {
	#name : #OMBenchmark,
	#superclass : #Object,
	#instVars : [
		'bool',
		'classesForMemoryEvaluation',
		'speedMode',
		'results',
		'x'
	],
	#category : #ObjectMinersBenchmarks
}

{ #category : #benchmarking }
OMBenchmark class >> bench [
	<script>
	Smalltalk garbageCollect.
	^ self new
		speedMode: #x1;
		benchAll
]

{ #category : #benchmarking }
OMBenchmark class >> bench2 [
	<script>
	Smalltalk garbageCollect.
	^ self new
		speedMode: #x1;
		benchAll
]

{ #category : #benchmarking }
OMBenchmark class >> bench2X0 [
	<script>
	Smalltalk garbageCollect.
	^ self new
		speedMode: #x0;
		benchAll
]

{ #category : #benchmarking }
OMBenchmark class >> bench2X10 [
	<script>
	Smalltalk garbageCollect.
	^ self new
		speedMode: #x10;
		benchAll
]

{ #category : #benchmarking }
OMBenchmark class >> bench2X100 [
	<script>
	Smalltalk garbageCollect.
	^ self new
		speedMode: #x100;
		benchAll
]

{ #category : #benchmarking }
OMBenchmark class >> benchFullMinerMemory [
	<script>
	Smalltalk garbageCollect.
	^ self new
		speedMode: #x100;
		benchFullMinerMemory
]

{ #category : #benchmarking }
OMBenchmark class >> benchReference [
	<script>
	Smalltalk garbageCollect.
	^ self new
		speedMode: #x1;
		benchReference
]

{ #category : #benchmarking }
OMBenchmark class >> benchReference2 [
	<script>
	Smalltalk garbageCollect.
	^ self new
		speedMode: #x1;
		benchReference2
]

{ #category : #benchmarking }
OMBenchmark class >> benchReference2X0 [
	<script>
	Smalltalk garbageCollect.
	^ self new
		speedMode: #x0;
		benchReference2
]

{ #category : #benchmarking }
OMBenchmark class >> benchReference2X10 [
	<script>
	Smalltalk garbageCollect.
	^ self new
		speedMode: #x10;
		benchReference2
]

{ #category : #benchmarking }
OMBenchmark class >> benchReference2X100 [
	<script>
	Smalltalk garbageCollect.
	^ self new
		speedMode: #x100;
		benchReference2
]

{ #category : #benchmarking }
OMBenchmark class >> benchReferenceMemory [
	<script>
	Smalltalk garbageCollect.
	^ self new
		speedMode: #x100;
		benchReferenceMemory
]

{ #category : #benchmarking }
OMBenchmark class >> benchReferenceX10 [
	<script>
	Smalltalk garbageCollect.
	^ self new
		speedMode: #x10;
		benchReference
]

{ #category : #benchmarking }
OMBenchmark class >> benchReferenceX100 [
	<script>
	Smalltalk garbageCollect.
	^ self new
		speedMode: #x100;
		benchReference
]

{ #category : #benchmarking }
OMBenchmark class >> benchSimpleMinerMemory [
	<script>
	Smalltalk garbageCollect.
	^ self new
		speedMode: #x100;
		benchSimpleMinerMemory
]

{ #category : #benchmarking }
OMBenchmark class >> benchX10 [
	<script>
	Smalltalk garbageCollect.
	^ self new
		speedMode: #x10;
		benchAll
]

{ #category : #benchmarking }
OMBenchmark class >> benchX100 [
	<script>
	Smalltalk garbageCollect.
	^ self new
		speedMode: #x100;
		benchAll
]

{ #category : #helpers }
OMBenchmark class >> sampleMethodSource [
	^'helloWorld ^#helloworld'
]

{ #category : #'miners - setup' }
OMBenchmark >> actionMethod [
]

{ #category : #'miners - setup' }
OMBenchmark >> astForMiner [
	^ (OMBenchmark >> self methodSelectorForSpeedMode) ast statements
		last
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> bench: aBlock [
	| result |
	Smalltalk garbageCollect.
	Smalltalk garbageCollect.
	result := aBlock benchFor: self timeToBench.
	^ OrderedCollection with: result
]

{ #category : #'benchmarks - 2' }
OMBenchmark >> bench: aBlock in: collection [
	aBlock value. "this to generate and compile the reflective method before evaluating"
	30 timesRepeat: [ collection add: aBlock timeToRun asMilliSeconds ]
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> benchAll [
	results := Dictionary new.
	results
		"at: '(a) Simple Instrumentation' put: self benchMinersSimple;
		at: '(d) Record Intermediate Objects'
			put: self benchMinersRecordIntermediate;
		at: '(b) Record Reifications' put: self benchMinersWithReifications;
		at: '(e) = (d)+ Reifications'
			put: self benchMinersIntermediateAndReifications;
		at: '(f) Action' put: self benchMinersAction;
		at: '(g) = (f) + Reifications'
			put: self benchMinersActionWithReifications;
		at: '(h) False Condition' put: self benchMinersFalseCondition;
		at: '(i) = (h) + Reifications'
			put: self benchMinersFalseConditionWithReifications;"
		at: '(l) Full Instrumentation' put: self benchMinersFullNoStack";
		at: '(m) Replay' put: self benchMinersReplay;
		at: '(c) Record Context' put: self benchMinersSimpleWithContext;
		at: '(j) True Condition' put: self benchMinersTrueCondition;
		at: '(k) = (j) + Reifications'
			put: self benchMinersTrueConditionWithReifications".
	self serializeBenchmark: results
	"('results-miners-', speedMode asString) asFileReference writeStream nextPutAll: (STON toString: results); close"

]

{ #category : #'benchmark - memory' }
OMBenchmark >> benchFullMinerMemory [
	| miner before after |
	before := self numberOfInstances.	
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner captureContext: self reificationsForMiner.
	miner
		setCondition:
			(CollectEvaluation new
				source: 'object bool';
				yourself).
	miner
		setAction:
			(CollectEvaluation new
				source: 'object actionMethod';
				yourself).
	miner recordIntermediateObjects: true.
	miner install.	
	self benchMiner: true.
	after := self numberOfInstances.
	miner uninstall.
	('memory' asFileReference / ('memory-full-' , speedMode)) writeStream
		nextPutAll:	(STON toString: {before.	after});
		close
]

{ #category : #'benchmarks - 2' }
OMBenchmark >> benchMiner2: anObject [
	|inst res|
	inst := OMBenchmark new.
	inst bool: anObject.
	res := OrderedCollection new.
	speedMode = #x10 ifTrue:[self bench: [ inst referenceNoInstrumentationX10 ] in: res].
	speedMode = #x100 ifTrue:[self bench: [ inst referenceNoInstrumentationX100 ] in: res].
	speedMode = #x1 ifTrue:[ self bench: [ inst referenceNoInstrumentationX1 ] in: res].
	speedMode = #x0 ifTrue:[ self bench:  [1000000 timesRepeat: [inst referenceNoInstrumentation ] ] in: res].
	^res
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> benchMiner: anObject [
	|inst|
	inst := OMBenchmark new.
	inst bool: anObject.
	speedMode = #x10 ifTrue:[^self bench: [ inst referenceNoInstrumentationX10 ]].
	speedMode = #x100 ifTrue:[^self bench: [ inst referenceNoInstrumentationX100 ]].
	^self bench: [ inst referenceNoInstrumentationX1 ]
]

{ #category : #benchmarks }
OMBenchmark >> benchMinersAction [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner captureContext: #(object).
	miner
		setAction:
			(CollectEvaluation new
				source: 'object actionMethod.';
				yourself).
	miner install.
	res := self benchMiner: false.
	miner uninstall.
	^ res
]

{ #category : #benchmarks }
OMBenchmark >> benchMinersActionWithReifications [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner captureContext: self reificationsForMiner.
	miner
		setAction:
			(CollectEvaluation new
				source: 'object actionMethod.';
				yourself).
	miner install.
	res := self benchMiner: false.
	miner uninstall.
	^ res
]

{ #category : #benchmarks }
OMBenchmark >> benchMinersFalseCondition [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner captureContext: #(object).
	miner
		setCondition:
			(CollectEvaluation new
				source: 'object bool';
				yourself).
	miner install.
	res := self benchMiner: false.
	miner uninstall.
	^ res
]

{ #category : #benchmarks }
OMBenchmark >> benchMinersFalseConditionWithReifications [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner captureContext: self reificationsForMiner.
	miner
		setCondition:
			(CollectEvaluation new
				source: 'object bool';
				yourself).
	miner install.
	res := self benchMiner: false.
	miner uninstall.
	^ res
]

{ #category : #benchmarks }
OMBenchmark >> benchMinersFullNoStack [
	| miner spaceBefore spaceAfter instancesBefore instancesAfter res |
	"spaceBefore := self spaceForInstances.
	instancesBefore := self numberOfInstances."
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner captureContext: self reificationsForMiner.
	miner
		setCondition:
			(CollectEvaluation new
				source: 'object bool';
				yourself).
	miner
		setAction:
			(CollectEvaluation new
				source: 'object actionMethod';
				yourself).
	miner recordIntermediateObjects: true.
	miner install.	
	res := self benchMiner: true.		
	"spaceAfter := self spaceForInstances.
	instancesAfter := self numberOfInstances.
	res add: spaceBefore.
	res add: spaceAfter.
	res add: instancesBefore.
	res add: instancesAfter."
	miner uninstall.
	^ res
]

{ #category : #'becnhmarks-experimental' }
OMBenchmark >> benchMinersFullNoStack2 [
	| miner spaceBefore spaceAfter instancesBefore instancesAfter res |
	spaceBefore := self spaceForInstances.
	instancesBefore := self numberOfInstances.
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner captureContext: self reificationsForMiner.
	miner
		setCondition:
			(CollectEvaluation new
				source: 'object bool';
				yourself).
	miner
		setAction:
			(CollectEvaluation new
				source: 'object actionMethod';
				yourself).
	miner recordIntermediateObjects: true.
	miner install.	
	res := self benchMiner2: true.		
	spaceAfter := self spaceForInstances.
	instancesAfter := self numberOfInstances.
	miner uninstall.
	^ res
]

{ #category : #benchmarks }
OMBenchmark >> benchMinersIntermediateAndReifications [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner recordIntermediateObjects: true.
	miner captureContext: self reificationsForMiner.
	miner install.
	res := self benchMiner: false.
	miner uninstall.
	^ res
]

{ #category : #benchmarks }
OMBenchmark >> benchMinersRecordIntermediate [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner recordIntermediateObjects: true.
	miner install.
	res := self benchMiner: false.
	miner uninstall.
	^ res
]

{ #category : #benchmarks }
OMBenchmark >> benchMinersReplay [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner install.
	self setReplayForMiner: miner.
	res := self benchMiner: false.
	miner uninstall.
	^ res
]

{ #category : #benchmarks }
OMBenchmark >> benchMinersSimple [
	| miner spaceBefore spaceAfter instancesBefore instancesAfter res |
	"spaceBefore := self spaceForInstances.
	instancesBefore := self numberOfInstances."
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner install.
	res := self benchMiner: false.
"	spaceAfter := self spaceForInstances.
	instancesAfter := self numberOfInstances."
"	res add: spaceBefore.
	res add: spaceAfter.
	res add: instancesBefore.
	res add: instancesAfter."
	miner uninstall.
	^ res
]

{ #category : #benchmarks }
OMBenchmark >> benchMinersSimpleWithContext [
	| miner res |
	self reinstallCollectorsContextBehavior.
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner captureContext: #(context).
	miner install.
	res := self benchMiner: false.
	miner uninstall.
	self uninstallCollectorsContextBehavior.
	^ res
]

{ #category : #benchmarks }
OMBenchmark >> benchMinersTrueCondition [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner captureContext: #(object).
	miner
		setCondition:
			(CollectEvaluation new
				source: 'object bool';
				yourself).
	miner install.
	res := self benchMiner: true.
	miner uninstall.
	^ res
]

{ #category : #benchmarks }
OMBenchmark >> benchMinersTrueConditionWithReifications [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner captureContext: self reificationsForMiner.
	miner
		setCondition:
			(CollectEvaluation new
				source: 'object bool';
				yourself).
	miner install.
	res := self benchMiner: true.
	miner uninstall.
	^ res
]

{ #category : #benchmarks }
OMBenchmark >> benchMinersWithReifications [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner captureContext: self reificationsForMiner.
	miner install.
	res := self benchMiner: false.
	miner uninstall.
	^ res
]

{ #category : #'benchmark - references' }
OMBenchmark >> benchReference [
	|inst spaceBefore instancesBefore instancesAfter spaceAfter res|
	inst := OMBenchmark new.
	Smalltalk garbageCollect.
	"spaceBefore := self spaceForInstances.
	instancesBefore := self numberOfInstances."
	speedMode = #x1 ifTrue:[res := self benchReferenceX1: inst].
	speedMode = #x10 ifTrue:[res := self benchReferenceX10: inst].
	speedMode = #x100 ifTrue:[res := self benchReferenceX100: inst].
	"spaceAfter := self spaceForInstances.
	instancesAfter := self numberOfInstances."
	self serializeBenchmark: {res". spaceBefore. spaceAfter. instancesBefore. instancesAfter"} asOrderedCollection.

]

{ #category : #'benchmark - references 2' }
OMBenchmark >> benchReference2 [
	|inst res|
	inst := OMBenchmark new.
	Smalltalk garbageCollect.	
	speedMode = #x0 ifTrue:[res := self benchReference2X0: inst].
	speedMode = #x1 ifTrue:[res := self benchReference2X1: inst].
	speedMode = #x10 ifTrue:[res := self benchReference2X10: inst].
	speedMode = #x100 ifTrue:[res := self benchReference2X100: inst].	
	"self serializeBenchmark: res"
	('results-reference-', speedMode asString) asFileReference writeStream nextPutAll: (STON toString: res); close

]

{ #category : #'benchmark - references 2' }
OMBenchmark >> benchReference2X0: inst [
	| col |
	col := OrderedCollection new.
	30
		timesRepeat: [ col
				add:  [1000000 timesRepeat: [inst referenceNoInstrumentation ] ] timeToRun asMilliSeconds ].
	^ col
]

{ #category : #'benchmark - references 2' }
OMBenchmark >> benchReference2X100: inst [
	| col |
	col := OrderedCollection new.
	30
		timesRepeat: [ col
				add: [ inst referenceNoInstrumentationX100 ] timeToRun asMilliSeconds ].
	^ col
]

{ #category : #'benchmark - references 2' }
OMBenchmark >> benchReference2X10: inst [
	| col |
	col := OrderedCollection new.
	30
		timesRepeat: [ col
				add: [ inst referenceNoInstrumentationX10 ] timeToRun asMilliSeconds ].
	^ col
]

{ #category : #'benchmark - references 2' }
OMBenchmark >> benchReference2X1: inst [
	| col |
	col := OrderedCollection new.
	30
		timesRepeat: [ col
				add: [ inst referenceNoInstrumentationX1 ] timeToRun asMilliSeconds ].
	^ col
]

{ #category : #'benchmark - memory' }
OMBenchmark >> benchReferenceMemory [
	| before after |
	before := self numberOfInstances.
	speedMode = #x1 ifTrue: [ self benchReferenceX1: self class new ].
	speedMode = #x10 ifTrue: [ self benchReferenceX10: self class new ].
	speedMode = #x100 ifTrue: [ self benchReferenceX100: self class new ].
	after := self numberOfInstances.
	('memory' asFileReference / ('memory-ref-' , speedMode)) writeStream
		nextPutAll:	(STON toString: {before.	after});
		close
]

{ #category : #'benchmark - references' }
OMBenchmark >> benchReferenceX100: inst [
	^ self bench: [ inst referenceNoInstrumentationX100 ]
]

{ #category : #'benchmark - references' }
OMBenchmark >> benchReferenceX10: inst [
	^ self bench: [ inst referenceNoInstrumentationX10 ]
]

{ #category : #'benchmark - references' }
OMBenchmark >> benchReferenceX1: inst [
	^ self bench: [ inst referenceNoInstrumentationX1 ]
]

{ #category : #'benchmark - memory' }
OMBenchmark >> benchSimpleMinerMemory [
	| miner before after |
	before := self numberOfInstances.	
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner install.
	self benchMiner: false.	
	after := self numberOfInstances.
	miner uninstall.
	('memory' asFileReference / ('memory-simple-' , speedMode)) writeStream
		nextPutAll:	(STON toString: {before.	after});
		close
]

{ #category : #'files - utilities' }
OMBenchmark >> benchmarkDir [
	| dir |
	dir := ('ombc-' , speedMode) asFileReference.
	dir ensureCreateDirectory.
	^ dir
]

{ #category : #benchmarks }
OMBenchmark >> benchmarkReferenceMethods [
	|delay x1 x10 x100 xavg|
	delay := 2 seconds.
	x1 := OrderedCollection new.
	100 timesRepeat: [ x1 add: ([self referenceNoInstrumentationX1] benchFor: delay) iterations].
"	x10 := OrderedCollection new.
	100 timesRepeat: [ x10 add: ([self referenceNoInstrumentationX10] benchFor: delay) iterations].
	x100 := OrderedCollection new.
	100 timesRepeat: [ x100 add: ([self referenceNoInstrumentationX100] benchFor: delay) iterations]."
	xavg := OrderedCollection new.
	xavg add: {x1 average. x1 stdev. x1 }.
"	xavg add: {x10 average. x10 stdev. x10 }.
	xavg add: {x100 average. x100 stdev. x100 }."
	^xavg
]

{ #category : #accessing }
OMBenchmark >> bool [
	^ bool
]

{ #category : #accessing }
OMBenchmark >> bool: anObject [
	bool := anObject
]

{ #category : #'benchmarks - analyze' }
OMBenchmark >> buildResultsAnalyze [
	|analyzer rezs|
	analyzer := OMBenchmarkResultsAnalyzer new.
	rezs := OrderedCollection new.
	rezs add: (analyzer compare: (results at: #x1) withReference: (results at: #x1ref)).
	rezs add: (analyzer compare: (results at: #x10) withReference: (results at: #x10ref)).
	rezs add: (analyzer compare: (results at: #x100) withReference: (results at: #x100ref)).
	(rezs collect: [:r|r mean] )inspect
	
]

{ #category : #deprecated }
OMBenchmark >> computeSlowdown: results [
	| dict |
	dict := Dictionary new.
	"Simple"
	dict
		at: 'Simple instrumentation'
		put:
			(self
				computeSlowdownBetween: (results at: 'Reference No Instrumentation') frequency
				instrumented: (results at: 'Reference Simple Instrumentation') frequency
				miners: (results at: 'Miner Simple') frequency).
	"Intermediate"
	dict
		at: 'Record Intermediate'
		put:
			(self
				computeSlowdownBetween: (results at: 'Reference No Instrumentation') frequency
				instrumented: (results at: 'Reference Record Intermediate Objects') frequency
				miners: (results at: 'Miner Record Intermediate Objects') frequency).
	"Reifications"
	dict
		at: 'Reifications'
		put:
			(self
				computeSlowdownBetween: (results at: 'Reference No Instrumentation') frequency
				instrumented: (results at: 'Reference With Reifications') frequency
				miners: (results at: 'Miner With Reifications') frequency).
	"Intermediate + refifications"
	dict
		at: 'Record intermediate + reifications'
		put:
			(self
				computeSlowdownBetween: (results at: 'Reference No Instrumentation') frequency
				instrumented: (results at: 'Reference Record Intermediate Objects With reifications') frequency
				miners: (results at: 'Miner Record Intermediate Objects With reifications') frequency).
	"Action"
	dict
		at: 'Action'
		put:
			(self
				computeSlowdownBetween: (results at: 'Reference No Instrumentation') frequency
				instrumented: (results at: 'Reference Action') frequency
				miners: (results at: 'Miner Action') frequency).
	"Action + reifications"
	dict
		at: 'Action With Reifications'
		put:
			(self
				computeSlowdownBetween: (results at: 'Reference No Instrumentation') frequency
				instrumented: (results at: 'Reference Action With Reifications') frequency
				miners: (results at: 'Miner Action With Reifications') frequency).
	"False Condition"
	dict
		at: 'False Condition'
		put:
			(self
				computeSlowdownBetween: (results at: 'Reference No Instrumentation') frequency
				instrumented: (results at: 'Reference False Condition') frequency
				miners: (results at: 'Miner False Condition') frequency).
	"False Condition + Reifications"
	dict
		at: 'False Condition With Reifications'
		put:
			(self
				computeSlowdownBetween: (results at: 'Reference No Instrumentation') frequency
				instrumented: (results at: 'Reference False Condition With Reifications') frequency
				miners: (results at: 'Miner False Condition With Reifications') frequency).
	"Full Instrumentation No Stack"
	dict
		at: 'Full Instrumentation No Stack'
		put:
			(self
				computeSlowdownBetween: (results at: 'Reference No Instrumentation') frequency
				instrumented: (results at: 'Reference Full Instrumentation No Stack') frequency
				miners: (results at: 'Miner Full No Stack') frequency).
	"Replay"
	dict
		at: 'Replay'
		put:
			(self
				computeSlowdownBetween: (results at: 'Reference No Instrumentation') frequency
				instrumented: (results at: 'Reference Replay') frequency
				miners: (results at: 'Miner Replay') frequency).
	"Simple With Context"
	dict
		at: 'Simple With Context'
		put:
			(self
				computeSlowdownBetween: (results at: 'Reference No Instrumentation') frequency
				instrumented: (results at: 'Reference Simple With Context') frequency
				miners: (results at: 'Miner Simple With Context') frequency).
	"True Condition"
	dict
		at: 'True Condition'
		put:
			(self
				computeSlowdownBetween: (results at: 'Reference No Instrumentation') frequency
				instrumented: (results at: 'Reference True Condition') frequency
				miners: (results at: 'Miner True Condition') frequency).
	"True Condition + Reifications"
	dict
		at: 'True Condition With Reifications'
		put:
			(self
				computeSlowdownBetween: (results at: 'Reference No Instrumentation') frequency
				instrumented: (results at: 'Reference True Condition With Reifications') frequency
				miners: (results at: 'Miner True Condition With Reifications') frequency).
	^ dict
]

{ #category : #deprecated }
OMBenchmark >> computeSlowdownBetween: reference instrumented: instrumented miners: miners [
	| computingBlock col |
	computingBlock := [ :ref :res | (ref / res round: 2) asFloat "- 1" ].
	col := OrderedCollection new.
	col add: ('Instrumented/Reference slowdown' -> (computingBlock value: reference value: instrumented)).
	col add: ('Miners/Reference slowdown' -> (computingBlock value: reference value: miners)).
	col add: ('Miners/Instrumented' -> (computingBlock value: instrumented value: miners)).
	^col
]

{ #category : #initialize }
OMBenchmark >> initialize [
	self setMemoryEvaluationClasses.
	speedMode := #x1
]

{ #category : #'files - utilities' }
OMBenchmark >> materializeBenchmark: bcFileReference [
	^STON fromString: bcFileReference contents
]

{ #category : #'benchmarks - analyze' }
OMBenchmark >> materializeResults [
	results := Dictionary new.
	results at: #x1 put: (self materializeResults: 'x1').
	results at: #x10 put: (self materializeResults: 'x10').
	results at: #x100 put: (self materializeResults: 'x100').
	results at: #x1ref put: (self materializeResults: 'x1ref').
	results at: #x10ref put: (self materializeResults: 'x10ref').
	results at: #x100ref put: (self materializeResults: 'x100ref').
	
]

{ #category : #'benchmarks - analyze' }
OMBenchmark >> materializeResults2 [
	results := Dictionary new.
	results at: #x0 put: (self materializeResults2: 'x0').
	results at: #x1 put: (self materializeResults2: 'x1').
	results at: #x10 put: (self materializeResults2: 'x10').
	results at: #x100 put: (self materializeResults2: 'x100').
	results at: #x0ref put: (self materializeResults2: 'x0ref').
	results at: #x1ref put: (self materializeResults2: 'x1ref').
	results at: #x10ref put: (self materializeResults2: 'x10ref').
	results at: #x100ref put: (self materializeResults2: 'x100ref').
	
]

{ #category : #'benchmarks - analyze' }
OMBenchmark >> materializeResults2: dirName [
	| result fileReference |
	result := OMBenchmarkResult2 new.
	fileReference := ('results-' , dirName) asFileReference.	
	result sample: (self materializeBenchmark: fileReference).
	result computeResults.
	^ result
]

{ #category : #'benchmarks - analyze' }
OMBenchmark >> materializeResults: dirName [
	| result bcResults directory |
	result := OMBenchmarkResult new.
	bcResults := OrderedCollection new.
	directory := 'results' asFileReference / ('ombc-' , dirName).
	directory allFiles
		do:
			[ :fileReference | bcResults add: (self materializeBenchmark: fileReference) ].
	result sample: bcResults.
	result computeResults.
	^ result
]

{ #category : #'miners - setup' }
OMBenchmark >> methodSelectorForSpeedMode [
	speedMode = #x0
		ifTrue: [ ^ #referenceNoInstrumentation ].
	speedMode = #x10
		ifTrue: [ ^ #referenceNoInstrumentationX10 ].
	speedMode = #x100
		ifTrue: [ ^ #referenceNoInstrumentationX100 ].
	^ #referenceNoInstrumentationX1
]

{ #category : #'files - utilities' }
OMBenchmark >> newBenchmarkResultFile [
	^ self benchmarkDir / Time now asNanoSeconds printString
]

{ #category : #'benchmark - memory' }
OMBenchmark >> numberOfInstances [
	^ classesForMemoryEvaluation
		inject: 0
		into: [ :t :c | t + c allInstances size ]
]

{ #category : #'benchmarks - analyze' }
OMBenchmark >> printLineIn: str forScenario: scenario [		
	str << scenario.
	"str << '&'.
	str << (self printMean: #x0 forScenario: scenario).
	str << '$\pm$'.
	str << (self printMargin: #x0 forScenario: scenario)."
	str << '&'.
	str << (self printMean: #x1 forScenario: scenario).
	str << '$\pm$'.
	str << (self printMargin: #x1 forScenario: scenario).
	str << '&'.
	str << (self printMean: #x10 forScenario: scenario).
	str << '$\pm$'.	
	str << (self printMargin: #x10 forScenario: scenario).
	str << '&'.
	str << (self printMean: #x100 forScenario: scenario).
	str << '$\pm$'.
	str << (self printMargin: #x100 forScenario: scenario).
	str << '\\'.
	str cr.
]

{ #category : #'benchmarks - analyze' }
OMBenchmark >> printMargin: xref forScenario: scenario [
	^ (((((results at: xref) margin at: scenario)) roundTo: 0.01)) printString
]

{ #category : #'benchmarks - analyze' }
OMBenchmark >> printMean: xref forScenario: scenario [
	^ (((results at: xref) mean at: scenario) rounded) printString
]

{ #category : #'benchmarks - analyze' }
OMBenchmark >> printRefMargin: xref [
	^ (((results at: xref) margin roundTo: 0.01)) printString
]

{ #category : #'benchmarks - analyze' }
OMBenchmark >> printRefMean: xref [
	^ ((results at: xref) mean rounded )printString
]

{ #category : #'benchmarks - analyze' }
OMBenchmark >> printResults [

	|str|
	str := WriteStream on: String new.	
	str << ('References (no instrumentation)&', (self printRefMean: #x1ref), '$\pm$', (self printRefMargin:#x1ref)).
	str << ('&', (self printRefMean: #x10ref), '$\pm$', (self printRefMargin:#x10ref)).
	str << ('&', (self printRefMean: #x100ref), '$\pm$', (self printRefMargin:#x100ref)).
	str <<  '\\'.
	str cr.
	(results at: #x1) mean keysDo:[:scenario|	
		self printLineIn: str forScenario: scenario	].
	^str contents
]

{ #category : #'benchmarks - analyze' }
OMBenchmark >> printResults2 [

	|str|
	str := WriteStream on: String new.
	str << ('References (no instrumentation)&', (self printRefMean: #x0ref), '$\pm$', (self printRefMargin:#x0ref)).
	str << ('&', (self printRefMean: #x1ref), '$\pm$', (self printRefMargin:#x1ref)).
	str << ('&', (self printRefMean: #x10ref), '$\pm$', (self printRefMargin:#x10ref)).
	str << ('&', (self printRefMean: #x100ref), '$\pm$', (self printRefMargin:#x100ref)).
	str <<  '\\'.
	str cr.
	(results at: #x1) mean keysDo:[:scenario|	
		self printLineIn: str forScenario: scenario	].
	^str contents
]

{ #category : #'benchmarks - analyze' }
OMBenchmark >> printResults3 [

	|str|
	str := WriteStream on: String new.
	str << ('References (no instrumentation)&', (self printRefMean: #x0ref), '$\pm$', (self printRefMargin:#x0ref)).
	str << ('&', (self printRefMean: #x1ref), '$\pm$', (self printRefMargin:#x1ref)).
	str << ('&', (self printRefMean: #x10ref), '$\pm$', (self printRefMargin:#x10ref)).
	str << ('&', (self printRefMean: #x100ref), '$\pm$', (self printRefMargin:#x100ref)).
	str <<  '\\'.
	str cr.
	(results at: #x1) mean keysDo:[:scenario|	
		self printLineIn: str forScenario: scenario	].
	^str contents
]

{ #category : #'becnhmarks-experimental' }
OMBenchmark >> rebenchX1V2 [
	|resRef resMiners|
	speedMode := #x100.
	resRef := OrderedCollection new.
	resMiners := OrderedCollection new.
	
	30 timesRepeat: [ resRef add: (self benchReference2X10: self class new) ].
	30 timesRepeat: [ resMiners add: (self benchMinersFullNoStack2) ].
	
	self assert: ((resRef stdev) squared) / ((resMiners stdev) squared) <= 2.
	self assert: ((resRef stdev) squared) / ((resMiners stdev) squared) >= 0.5.
]

{ #category : #'reference methods' }
OMBenchmark >> referenceNoInstrumentation [
	(10 squared + 1) asString
]

{ #category : #'reference methods' }
OMBenchmark >> referenceNoInstrumentationX1 [
	x := 1
]

{ #category : #'reference methods' }
OMBenchmark >> referenceNoInstrumentationX10 [
	10 squared + 1
]

{ #category : #'reference methods' }
OMBenchmark >> referenceNoInstrumentationX100 [
	self class compile: self class sampleMethodSource 
]

{ #category : #'reference methods' }
OMBenchmark >> referenceNoInstrumentationX1000 [
	|i res|
	res := OrderedCollection new.
	100 timesRepeat: [ i := Random new next + 1.
		res add: (i > 1.5 ifTrue:[i squared] ifFalse:[i]) ].
	res shuffled
]

{ #category : #'miners - setup' }
OMBenchmark >> reificationsForMiner [
	speedMode = #x1
		ifTrue: [ ^ #(#object #class #operation #name) ].
	^ #(#object #class #receiver #selector)
]

{ #category : #'miners - setup' }
OMBenchmark >> reinstallCollectorsContextBehavior [

	CollectBehavior compile: 
	'omniscientCollect: anObject in: aCollector withReifications: anArrayOfReifications
	| item |
	item := self omniscientItemClass new.
	item rawData: anArrayOfReifications.
	item reificationSpec: aCollector reifications.
	((aCollector reifications includes: #context)
		and: [ aCollector metaController stackSize > 0 ])
		ifTrue: [ item copyContext: item context ].
	aCollector applyTransformationsTo: item from: anArrayOfReifications.
	aCollector omniscientCollectItem: item
	'
]

{ #category : #'files - utilities' }
OMBenchmark >> serializeBenchmark: bc [
	| str |
	str := self newBenchmarkResultFile writeStream.
	str nextPutAll: (STON toString: bc).
	str close
]

{ #category : #'benchmark - memory' }
OMBenchmark >> setMemoryEvaluationClasses [
	classesForMemoryEvaluation := (OrderedCollection new
		addAll: (RPackage organizer packageOf: ObjectMiner) classes;
		addAll: (RPackage organizer packageOf: Collector) classes;
		addAll: (RPackage organizer packageOf: MetaLink) classes;
		addAll:
			{Array.
			OrderedCollection.
			SmallInteger.
			Set.
			ByteString.
			Symbol};
		asSet) asOrderedCollection reject: [ :c | c isMeta ]
]

{ #category : #'miners - setup' }
OMBenchmark >> setReplayForMiner: miner [
	|node rawData record|
	node := self astForMiner allChildren last.
	rawData := {nil. 1. node. nil.}.
	record := OmniscientItem new.
	record rawData: rawData.
	miner collector replayCollectedItem: record 
	
]

{ #category : #deprecated }
OMBenchmark >> showSlowdown: results [
	| computingBlock dict |
	computingBlock := [ :ref :res | (ref / res round: 2) asFloat - 1 ].
	dict := Dictionary
		newFromKeys: results keys
		andValues:
			(results values
				collect: [ :v | 
					computingBlock
						value: (results at: 'Reference simple instrumentation') frequency
						value: v frequency ]).
	dict at: 'Reference no instrumentation' put: 1.
	dict
		at: 'Reference simple instrumentation'
		put:
			(computingBlock
				value: (results at: 'Reference no instrumentation') frequency
				value: (results at: 'Reference simple instrumentation') frequency).
		dict
		at: 'Reference record intermediate'
		put:
			(computingBlock
				value: (results at: 'Reference no instrumentation') frequency
				value: (results at: 'Reference record intermediate') frequency).
	dict
		at: 'Miner Record Intermediate Objects'
		put:
			(computingBlock
				value: (results at: 'Reference record intermediate') frequency
				value: (results at: 'Miner Record Intermediate Objects') frequency).
	^ dict
]

{ #category : #'benchmark - memory' }
OMBenchmark >> spaceForInstances [
	^ (SpaceTally new spaceTally: classesForMemoryEvaluation)
		inject: 0
		into: [ :t :s | t + s spaceForInstances ]
]

{ #category : #accessing }
OMBenchmark >> speedMode: anObject [
	speedMode := anObject
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> timeToBench [
	^ 10 seconds
]

{ #category : #'miners - setup' }
OMBenchmark >> uninstallCollectorsContextBehavior [

	CollectBehavior compile: 
	'omniscientCollect: anObject in: aCollector withReifications: anArrayOfReifications
	| item |
	item := self omniscientItemClass new.
	item rawData: anArrayOfReifications.
	item reificationSpec: aCollector reifications.
	
	aCollector applyTransformationsTo: item from: anArrayOfReifications.
	aCollector omniscientCollectItem: item
	'
]
