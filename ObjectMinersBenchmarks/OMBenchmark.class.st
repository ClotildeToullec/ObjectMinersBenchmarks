Class {
	#name : #OMBenchmark,
	#superclass : #Object,
	#instVars : [
		'simpleItems',
		'bool'
	],
	#category : #ObjectMinersBenchmarks
}

{ #category : #benchmarking }
OMBenchmark class >> bench [
	<script>
	Smalltalk garbageCollect.
	^ self new benchAll
]

{ #category : #benchmarking }
OMBenchmark class >> benchMinerMemorySimpleInstrumentation [
	<script>
	Smalltalk garbageCollect.
	^ self new benchMinerMemorySimpleInstrumentation
]

{ #category : #benchmarking }
OMBenchmark class >> benchMinersMemoryFullInstrumentationNoStack [
	<script>
	Smalltalk garbageCollect.
	^ self new benchMinersMemoryFullInstrumentationNoStack
]

{ #category : #benchmarking }
OMBenchmark class >> benchReferenceMemoryFullInstrumentationNoStack [
	<script>
	Smalltalk garbageCollect.
	^ self new benchReferenceMemoryFullInstrumentationNoStack
]

{ #category : #benchmarking }
OMBenchmark class >> benchReferenceMemoryNoInstrumentation [
	<script>
	Smalltalk garbageCollect.
	^ self new benchReferenceMemoryNoInstrumentation
]

{ #category : #benchmarking }
OMBenchmark class >> benchReferenceMemorySimpleInstrumentation [
	<script>
	Smalltalk garbageCollect.
	^ self new benchReferenceMemorySimpleInstrumentation
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> actionMethod [
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
		at: 'Reference record intermediate'
			put: self benchReferenceRecordIntermediateInstrumentation;
		at: 'Reference With Reifications'
			put: self benchReferenceWithReificationsInstrumentation;
		at: 'Reference Record Intermediate Objects, with reifications'
			put: self benchReferenceRecordIntermediateWithReificationsInstrumentation;
		at: 'Miner Simple' put: self benchMinersSimple;
		at: 'Miner Record Intermediate Objects'
			put: self benchMinersRecordIntermediate;
		at: 'Miner With Reifications' put: self benchMinersWithReifications;
		at: 'Miner Record Intermediate Objects, with reifications'
			put: self benchMinersIntermediateAndReifications.
	(self computeSlowdown: results) inspect
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> benchMiner [
	|inst|
	inst := OMBenchmark new.
	^ self bench: [ inst minerInstrumentedMethod ]
]

{ #category : #'benchmark - memory' }
OMBenchmark >> benchMinerMemorySimpleInstrumentation [
	| miner inst res|
	Smalltalk garbageCollect.
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner install.
	inst := OMBenchmark new.
	res := self timeAndMemoryProfile: [ inst minerInstrumentedMethod ].
	miner uninstall.
	^res
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

{ #category : #'benchmark - memory' }
OMBenchmark >> benchMinersMemoryFullInstrumentationNoStack [
	| miner inst res|
	Smalltalk garbageCollect.
	self flag: 'configure miner'.
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner install.
	inst := OMBenchmark new.
	res := self timeAndMemoryProfile: [ inst minerInstrumentedMethod ].
	miner uninstall.
	^res
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
OMBenchmark >> benchMinersReplay [
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner install.
	self setReplayForMiner: miner.
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
OMBenchmark >> benchMinersSimpleWithContext [
	| miner res |
	self reinstallCollectorsContextBehavior.
	miner := ObjectMiner new reachFromAST: self astForMiner.
	self flag: 'Set the context as reification'.
	miner install.
	res := self benchMiner.
	miner uninstall.
	self uninstallCollectorsContextBehavior.
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

{ #category : #'benchmark - references' }
OMBenchmark >> benchReferenceActionInstrumentation [ 
	|inst|
	inst := OMBenchmark new.	
	 ^self bench: [inst referenceActionInstrumentation  ] 
]

{ #category : #'benchmark - references' }
OMBenchmark >> benchReferenceActionWithReificationsInstrumentation [ 
	|inst|
	inst := OMBenchmark new.	
	 ^self bench: [inst referenceActionWithReificationsInstrumentation  ] 
]

{ #category : #'benchmark - references' }
OMBenchmark >> benchReferenceFalseConditionInstrumentation [ 
	|inst|
	inst := OMBenchmark new.
	inst bool: false.
	 ^self bench: [inst referenceConditionInstrumentation  ] 
]

{ #category : #'benchmark - references' }
OMBenchmark >> benchReferenceFalseConditionWithReificationsInstrumentation [ 
	|inst|
	inst := OMBenchmark new.
	inst bool: false.
	 ^self bench: [inst referenceConditionWithReificationsInstrumentation  ] 
]

{ #category : #'benchmark - references' }
OMBenchmark >> benchReferenceFullInstrumentationNoStack [ 
	|inst|
	inst := OMBenchmark new.
	inst bool: true.	
	 ^self bench: [inst referenceFullInstrumentation  ] 
]

{ #category : #'benchmark - memory' }
OMBenchmark >> benchReferenceMemoryFullInstrumentationNoStack [
	| inst |
	inst := OMBenchmark new.
	inst bool: true.
	^self timeAndMemoryProfile: [ inst referenceFullInstrumentation ]
]

{ #category : #'benchmark - memory' }
OMBenchmark >> benchReferenceMemoryNoInstrumentation [
	| inst |
	Smalltalk garbageCollect.
	inst := OMBenchmark new.
	^self timeAndMemoryProfile:[ inst referenceNoInstrumentation]
	
]

{ #category : #'benchmark - memory' }
OMBenchmark >> benchReferenceMemorySimpleInstrumentation [
	| inst |
	Smalltalk garbageCollect.
	inst := OMBenchmark new.
	^self timeAndMemoryProfile:[ inst referenceWithSimpleInstrumentation]
	
]

{ #category : #'benchmark - references' }
OMBenchmark >> benchReferenceNoInstrumentation [ 
	|inst|
	inst := OMBenchmark new.
	 ^self bench: [inst referenceNoInstrumentation  ] 
]

{ #category : #'benchmark - references' }
OMBenchmark >> benchReferenceRecordIntermediateInstrumentation [ 
	|inst|
	inst := OMBenchmark new.
	 ^self bench: [inst referenceRecordIntermediateInstrumentation  ] 
]

{ #category : #'benchmark - references' }
OMBenchmark >> benchReferenceRecordIntermediateWithReificationsInstrumentation [ 
	|inst|
	inst := OMBenchmark new.
	 ^self bench: [inst referenceReificationsWithIntermediateInstrumentation  ] 
]

{ #category : #'benchmark - references' }
OMBenchmark >> benchReferenceReplayInstrumentation [ 
	|inst|
	inst := OMBenchmark new.
	inst simpleItems: #(1 1 1 1 1 1 1 1 1 1).
	 ^self bench: [inst referenceReplayInstrumentation  ] 
]

{ #category : #'benchmark - references' }
OMBenchmark >> benchReferenceSimpleInstrumentation [ 
	|inst|
	inst := OMBenchmark new.
	 ^self bench: [inst referenceWithSimpleInstrumentation  ] 
]

{ #category : #'benchmark - references' }
OMBenchmark >> benchReferenceSimpleInstrumentationWithContext [ 
	|inst|
	inst := OMBenchmark new.
	 ^self bench: [inst referenceSimpleInstrumentationWithContext  ] 
]

{ #category : #'benchmark - references' }
OMBenchmark >> benchReferenceTrueConditionInstrumentation [ 
	|inst|
	inst := OMBenchmark new.
	inst bool: true.
	 ^self bench: [inst referenceConditionInstrumentation  ] 
]

{ #category : #'benchmark - references' }
OMBenchmark >> benchReferenceTrueConditionWithReificationsInstrumentation [ 
	|inst|
	inst := OMBenchmark new.
	inst bool: true.
	 ^self bench: [inst referenceConditionWithReificationsInstrumentation  ] 
]

{ #category : #'benchmark - references' }
OMBenchmark >> benchReferenceWithReificationsInstrumentation [ 
	|inst|
	inst := OMBenchmark new.
	 ^self bench: [inst referenceWithReificationsInstrumentation  ] 
]

{ #category : #'benchmark - memory' }
OMBenchmark >> benchmarkSimpleInstrumentationMemory [
	| no reference miner results|
	Smalltalk garbageCollect.
	no := self class new benchReferenceMemoryNoInstrumentation.
	Smalltalk garbageCollect.
	reference := self class new benchReferenceMemorySimpleInstrumentation.
	Smalltalk garbageCollect.
	miner := self class new benchMinerMemorySimpleInstrumentation.
	results := WriteStream on: String new.
	results nextPutAll: 'no: ', no printString, 'bytes'.
	results cr.
	results nextPutAll: 'reference: ', reference printString, 'bytes'.
	results cr.
	results nextPutAll: 'miners: ', miner printString, 'bytes'.
	results cr.
	results nextPutAll: 'reference/no: x', (reference/no) asFloat printString.
	results cr.
	results nextPutAll: 'miners/no: x', (miner/no) asFloat printString.
	results cr.
	results nextPutAll: 'miners/reference: x', (miner/reference) asFloat printString.
	^results contents
	
]

{ #category : #accessing }
OMBenchmark >> bool: anObject [
	bool := anObject
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> computeSlowdown: results [
	| dict |
	dict := Dictionary new.
	dict
		at: 'Simple instrumentation'
		put:
			(self
				computeSlowdownBetween: (results at: 'Reference no instrumentation') frequency
				instrumented: (results at: 'Reference simple instrumentation') frequency
				miners: (results at: 'Miner Simple') frequency).
	dict
		at: 'Record intermediate'
		put:
			(self
				computeSlowdownBetween: (results at: 'Reference no instrumentation') frequency
				instrumented: (results at: 'Reference record intermediate') frequency
				miners: (results at: 'Miner Record Intermediate Objects') frequency).
	dict
		at: 'Reifications'
		put:
			(self
				computeSlowdownBetween: (results at: 'Reference no instrumentation') frequency
				instrumented: (results at: 'Reference With Reifications') frequency
				miners: (results at: 'Miner With Reifications') frequency).
	dict
		at: 'Record intermediate + reifications'
		put:
			(self
				computeSlowdownBetween: (results at: 'Reference no instrumentation') frequency
				instrumented: (results at: 'Reference Record Intermediate Objects, with reifications') frequency
				miners: (results at: 'Miner Record Intermediate Objects, with reifications') frequency).
	^ dict
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> computeSlowdownBetween: reference instrumented: instrumented miners: miners [
	| computingBlock col |
	computingBlock := [ :ref :res | (ref / res round: 2) asFloat - 1 ].
	col := OrderedCollection new.
	col add: ('Instrumented/Reference slowdown' -> (computingBlock value: reference value: instrumented)).
	col add: ('Miners/Reference slowdown' -> (computingBlock value: reference value: miners)).
	col add: ('Miners/Instrumented' -> (computingBlock value: instrumented value: miners)).
	^col
]

{ #category : #initialize }
OMBenchmark >> initialize [
	simpleItems := OrderedCollection new: 1000000
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
OMBenchmark >> referenceActionInstrumentation [
	simpleItems add: (10 squared + 1) asString.
	self actionMethod
]

{ #category : #'reference methods' }
OMBenchmark >> referenceActionWithReificationsInstrumentation [
	| value receiver reifications |
	reifications := OrderedCollection new.
	receiver := 10 squared + 1.
	value := receiver asString.
	reifications add: value.
	reifications add: #asString.
	reifications add: OMBenchmark.
	reifications add: self.
	reifications add: receiver.
	simpleItems add: reifications.
	self actionMethod
]

{ #category : #'reference methods' }
OMBenchmark >> referenceConditionInstrumentation [
	bool
		ifTrue: [ simpleItems add: (10 squared + 1) asString ]
]

{ #category : #'reference methods' }
OMBenchmark >> referenceConditionWithReificationsInstrumentation [
	| value receiver reifications |
	reifications := OrderedCollection new.
	receiver := 10 squared + 1.
	value := receiver asString.
	reifications add: value.
	reifications add: #asString.
	reifications add: OMBenchmark.
	reifications add: self.
	reifications add: receiver.
	bool
		ifTrue: [ simpleItems add: reifications ]
]

{ #category : #'reference methods' }
OMBenchmark >> referenceFullInstrumentation [
	|rcv reifs subs temp1 temp2 temp3|
	
	subs := OrderedCollection new.
	
	rcv := 10.
	temp1 := rcv squared.
	reifs := OrderedCollection new.
	reifs add: temp1; add: #squared; add: OMBenchmark; add: self; add: rcv.
	subs add: reifs.
	
	rcv := temp1.
	temp2 := temp1 + 1.
	reifs := OrderedCollection new.
	reifs add: temp2; add: #+; add: OMBenchmark; add: self; add: rcv.
	subs add: reifs.
	
	rcv := temp2.
	temp3 := temp2 asString.
	reifs := OrderedCollection new.
	reifs add: temp3; add: #asString; add: OMBenchmark; add: self; add: rcv.
	subs add: reifs.	
	
	bool ifTrue:[
	simpleItems add: subs].

	self actionMethod
]

{ #category : #'reference methods' }
OMBenchmark >> referenceNoInstrumentation [
	(10 squared + 1) asString
]

{ #category : #'reference methods' }
OMBenchmark >> referenceRecordIntermediateInstrumentation [
	|subs temp1 temp2 temp3|
	subs := OrderedCollection new.
	temp1 := 10 squared.
	temp2 := temp1 + 1.
	temp3 := temp2 asString.
	subs add: temp1; add: temp2; add: temp3.
	simpleItems add: subs
]

{ #category : #'reference methods' }
OMBenchmark >> referenceReificationsWithIntermediateInstrumentation [
	|rcv reifs subs temp1 temp2 temp3|
	
	subs := OrderedCollection new.
	
	rcv := 10.
	temp1 := rcv squared.
	reifs := OrderedCollection new.
	reifs add: temp1; add: #squared; add: OMBenchmark; add: self; add: rcv.
	subs add: reifs.
	
	rcv := temp1.
	temp2 := temp1 + 1.
	reifs := OrderedCollection new.
	reifs add: temp2; add: #+; add: OMBenchmark; add: self; add: rcv.
	subs add: reifs.
	
	rcv := temp2.
	temp3 := temp2 asString.
	reifs := OrderedCollection new.
	reifs add: temp3; add: #asString; add: OMBenchmark; add: self; add: rcv.
	subs add: reifs.	
	

	simpleItems add: subs

]

{ #category : #'reference methods' }
OMBenchmark >> referenceReplayInstrumentation [
	(10 squared + (simpleItems at: 5)) asString
]

{ #category : #'reference methods' }
OMBenchmark >> referenceSimpleInstrumentationWithContext [
	|context|
	context := thisContext.
	context := (context stackOfSize: 20) copy.
	simpleItems add: (10 squared + 1) asString
]

{ #category : #'reference methods' }
OMBenchmark >> referenceWithReificationsInstrumentation [
	| value receiver reifications |
	reifications := OrderedCollection new.
	receiver := 10 squared + 1.
	value := receiver asString.
	reifications add: value.
	reifications add: #asString.
	reifications add: OMBenchmark.
	reifications add: self.
	reifications add: receiver.
	simpleItems add: reifications
]

{ #category : #'reference methods' }
OMBenchmark >> referenceWithSimpleInstrumentation [
	simpleItems add: (10 squared + 1) asString
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> reificationsForMiner [
	^ #(#object #class #receiver #selector)
]

{ #category : #'benchmarks - tools' }
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

{ #category : #'benchmarks - tools' }
OMBenchmark >> setReplayForMiner: miner [
	|node rawData record|
	node := self astForMiner allChildren last.
	rawData := {nil. 1. node. nil.}.
	record := OmniscientItem new.
	record rawData: rawData.
	miner collector replayCollectedItem: record 
	
]

{ #category : #'benchmarks - tools' }
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

{ #category : #accessing }
OMBenchmark >> simpleItems: anObject [
	simpleItems := anObject
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> timeAndMemoryProfile: aBlock [
	1000000 timesRepeat: aBlock.
	^ (SpaceTally new
		spaceTally:
			{Array.
			OmniscientItem.
			ObjectMiner.
			Collector.
			OrderedCollection.
			SmallInteger.
			Set.
			ByteString}) inject: 0 into: [ :t :s | t + s spaceForInstances ]
]

{ #category : #'benchmarks - tools' }
OMBenchmark >> timeToBench [
	^ 2 seconds
]

{ #category : #'benchmarks - tools' }
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
