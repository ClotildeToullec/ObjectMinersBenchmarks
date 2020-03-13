Class {
	#name : #OMBenchmarkResult,
	#superclass : #Object,
	#instVars : [
		'sample',
		'mean',
		'stdev',
		'memoryOverheadMean',
		'memoryOverheadStdev'
	],
	#category : #ObjectMinersBenchmarks
}

{ #category : #computing }
OMBenchmarkResult >> computeFrequencyMeans [
	| freqMeans |
	freqMeans := Dictionary new.
	self sampleKeys
		do: [ :key | 
			freqMeans
				at: key
				put: (sample collect: [ :dic | (dic at: key) first frequency ]) average rounded ].
	^ freqMeans
]

{ #category : #computing }
OMBenchmarkResult >> computeMemoryOverheadMean [
	| memOverheads |
	memOverheads := Dictionary new.
	{'Simple Instrumentation' . 'Full Instrumentation'}
		do: [ :key | 
			memOverheads
				at: key
				put:
					(sample
						collect: [ :dic | 
							| bc |
							bc := dic at: key.
							bc third / bc second ]) average rounded ].
	^ memOverheads
]

{ #category : #computing }
OMBenchmarkResult >> computeMemoryOverheadStdev [
	| memOverheads |
	memOverheads := Dictionary new.
	{'Simple Instrumentation' . 'Full Instrumentation'}
		do: [ :key | 
			memOverheads
				at: key
				put:
					(sample
						collect: [ :dic | 
							| bc |
							bc := dic at: key.
							bc third / bc second ]) stdev rounded ].
	^ memOverheads
]

{ #category : #computing }
OMBenchmarkResult >> computeMinersResults [
	mean := self computeFrequencyMeans.
	stdev := self computeStdev.
	memoryOverheadMean := self computeMemoryOverheadMean.
	memoryOverheadStdev := self computeMemoryOverheadStdev.
]

{ #category : #computing }
OMBenchmarkResult >> computeReferenceFrequencyMeans [
	^ (sample collect: [ :col | col first first frequency ]) average
		rounded
]

{ #category : #computing }
OMBenchmarkResult >> computeReferenceMemoryOverhead [
	^ (sample collect: [ :col | col first first frequency ]) stdev rounded
]

{ #category : #computing }
OMBenchmarkResult >> computeReferenceMemoryOverheadMean [
	^ (sample collect: [ :col | col third / col second ]) average rounded
]

{ #category : #computing }
OMBenchmarkResult >> computeReferenceMemoryOverheadStdev [
	^ (sample collect: [ :col | col third / col second ]) stdev rounded
]

{ #category : #computing }
OMBenchmarkResult >> computeReferenceResults [
	mean := self computeReferenceFrequencyMeans.
	stdev := self computeReferenceStdev. 
	memoryOverheadMean := self computeReferenceMemoryOverheadMean.
	memoryOverheadStdev := self computeReferenceMemoryOverheadStdev.
]

{ #category : #computing }
OMBenchmarkResult >> computeReferenceStdev [
	^ (sample collect: [ :col | col first first frequency ]) stdev rounded
]

{ #category : #computing }
OMBenchmarkResult >> computeResults [
	sample first isDictionary ifTrue:[^self computeMinersResults].
	self computeReferenceResults 
]

{ #category : #computing }
OMBenchmarkResult >> computeStdev [
	| stdevs |
	stdevs := Dictionary new.
	self sampleKeys
		do: [ :key | 
			stdevs
				at: key
				put: (sample collect: [ :dic | (dic at: key) first frequency ]) stdev rounded].
	^ stdevs
]

{ #category : #accessing }
OMBenchmarkResult >> mean [
	^ mean
]

{ #category : #accessing }
OMBenchmarkResult >> mean: anObject [
	mean := anObject
]

{ #category : #accessing }
OMBenchmarkResult >> sample [
	^ sample
]

{ #category : #accessing }
OMBenchmarkResult >> sample: anObject [
	sample := anObject
]

{ #category : #computing }
OMBenchmarkResult >> sampleKeys [
	^sample first keys
]

{ #category : #accessing }
OMBenchmarkResult >> stdev [
	^ stdev
]

{ #category : #accessing }
OMBenchmarkResult >> stdev: anObject [
	stdev := anObject
]
