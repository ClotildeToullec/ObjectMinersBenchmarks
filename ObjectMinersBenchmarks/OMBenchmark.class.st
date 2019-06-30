Class {
	#name : #OMBenchmark,
	#superclass : #Object,
	#instVars : [
		'simpleItems'
	],
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
	Smalltalk garbageCollect.
	^ aBlock benchFor: self timeToBench
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> benchAll [
	| results |
	results := Dictionary new.
	results
		at: 'Reference no instrumentation'
			put: self benchReferenceNoInstrumentation;
		at: 'Reference simple instrumentation'
			put: self benchReferenceSimpleInstrumentation;
		at: 'Miner Simple' put: self benchMinersSimple;
		at: 'Miner Record Intermediate Objects'
			put: self benchMinersRecordIntermediate;
		at: 'Miner With Reifications' put: self benchMinersWithReifications;
		at: 'Miner Record Intermediate Objects, with reifications'
			put: self benchMinersIntermediateAndReifications.
	(self showSlowdown: results) inspect
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> benchMiner [
	|inst|
	inst := OMBenchmark new.
	^ self bench: [ inst minerInstrumentedMethod ]
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
	|inst|
	inst := OMBenchmark new.
	 ^self bench: [inst referenceNoInstrumentation  ] 
]

{ #category : #benchmarks }
OMBenchmark >> benchReferenceSimpleInstrumentation [ 
	|inst|
	inst := OMBenchmark new.
	 ^self bench: [inst referenceWithSimpleInstrumentation  ] 
]

{ #category : #initialize }
OMBenchmark >> initialize [
	simpleItems := OrderedCollection new
]

{ #category : #'reference methods' }
OMBenchmark >> minerInstrumentedMethod [
	(10 squared + 1) asString
]

{ #category : #profiling }
OMBenchmark >> profileMiner [
	|inst|
	inst := OMBenchmark new.
	^ TimeProfiler spyOn: [ 10000000 timesRepeat: [inst minerInstrumentedMethod] ]
]

{ #category : #profiling }
OMBenchmark >> profileMinersIntermediateAndReifications [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner recordIntermediateObjects: true.
	miner captureContext: self reificationsForMiner.
	miner install.
	res := self profileMiner.
	miner uninstall.
	^ res
]

{ #category : #profiling }
OMBenchmark >> profileMinersRecordIntermediate [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner recordIntermediateObjects: true.
	miner install.
	res := self profileMiner.
	miner uninstall.
	^ res
]

{ #category : #profiling }
OMBenchmark >> profileMinersSimple [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner install.
	res := self profileMiner.
	miner uninstall.
	^ res
]

{ #category : #profiling }
OMBenchmark >> profileMinersWithReifications [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner captureContext: self reificationsForMiner.
	miner install.
	res := self profileMiner.
	miner uninstall.
	^ res
]

{ #category : #'reference methods' }
OMBenchmark >> referenceNoInstrumentation [
	(10 squared + 1) asString
]

{ #category : #'reference methods' }
OMBenchmark >> referenceWithSimpleInstrumentation [
	simpleItems add: (10 squared + 1) asString.
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> reificationsForMiner [
	^ #(#object #class #arguments #receiver #selector)
	" #(#object #receiver #arguments)"
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> showSlowdown: results [
	| computingBlock dict |
	computingBlock := [ :ref :res | (ref / res round: 2) asFloat ].
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
	^ dict
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> timeToBench [
	^ 2 seconds
]
