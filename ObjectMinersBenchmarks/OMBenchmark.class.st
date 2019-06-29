Class {
	#name : #OMBenchmark,
	#superclass : #Object,
	#category : #ObjectMinersBenchmarks
}

{ #category : #benchmarking }
OMBenchmark class >> bench [
	<script>
	^ self new benchAll
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> astForMiner [
	^ (OMBenchmark >> #minerInstrumentedMethod) ast statements last
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> bench: aBlock [
	^ aBlock benchFor: self timeToBench
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> benchAll [
	| results |
	results := Dictionary new.
	results
		at: 'Reference no instrumentation'
			put: self benchReferenceNoInstrumentation;
		at: 'Miner Simple' put: self benchMinersSimple;
		at: 'Miner Record Intermediate Objects'
			put: self benchMinersRecordIntermediate;
		at: 'Miner With Reifications' put: self benchMinersWithReifications;
		at: 'Miner Record Intermediate Objects, with reifications'
			put: self benchMinersIntermediateAndReifications.
	results inspect
]

{ #category : #benchmarks }
OMBenchmark >> benchMiner [
	^ self bench: [ self minerInstrumentedMethod ]
]

{ #category : #benchmarks }
OMBenchmark >> benchMinersIntermediateAndReifications [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner recordIntermediateObjects: true.
	miner captureContext: self reificationsForMiner.
	miner install.
	res := self benchMiner.
	miner uninstall.
	^ res
]

{ #category : #benchmarks }
OMBenchmark >> benchMinersRecordIntermediate [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner recordIntermediateObjects: true.
	miner install.
	res := self benchMiner.
	miner uninstall.
	^ res
]

{ #category : #benchmarks }
OMBenchmark >> benchMinersSimple [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner install.
	res := self benchMiner.
	miner uninstall.
	^ res
]

{ #category : #benchmarks }
OMBenchmark >> benchMinersWithReifications [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner captureContext: self reificationsForMiner.
	miner install.
	res := self benchMiner.
	miner uninstall.
	^ res
]

{ #category : #benchmarks }
OMBenchmark >> benchReferenceNoInstrumentation [ 
	 ^self bench: [self referenceNoInstrumentation ] 
]

{ #category : #'reference methods' }
OMBenchmark >> minerInstrumentedMethod [
	((Random new next: 10) squared + 1) asString
]

{ #category : #miners }
OMBenchmark >> minerSimple [
	((Random new next: 10) squared + 1) asString
]

{ #category : #'reference methods' }
OMBenchmark >> referenceNoInstrumentation [
	
	((Random new next: 10) squared + 1) asString
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> reificationsForMiner [
	^ #(#object #context #class #arguments #receiver #selector)
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> timeToBench [
	^ 2 seconds
]
