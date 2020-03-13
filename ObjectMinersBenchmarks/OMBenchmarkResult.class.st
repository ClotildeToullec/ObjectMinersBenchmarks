Class {
	#name : #OMBenchmarkResult,
	#superclass : #Object,
	#instVars : [
		'sample',
		'mean',
		'stdev',
		'margin',
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
				put: (sample collect: [ :dic | (dic at: key) first iterations]) average rounded ].
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

{ #category : #margins }
OMBenchmarkResult >> computeMinersMargin [
	margin := Dictionary new.
	stdev
		keysAndValuesDo: [ :scn :dev | margin at: scn put: 1.96 * (dev / 30 sqrt) ]
]

{ #category : #results }
OMBenchmarkResult >> computeMinersResults [
	|meansAndStdevs|
	meansAndStdevs := self minersPeriodMeansAndStDevs.
	mean := meansAndStdevs first.
	stdev :=  meansAndStdevs second.
	self computeMinersMargin
	
]

{ #category : #computing }
OMBenchmarkResult >> computeReferenceFrequencyMeans [
	^ (sample collect: [ :col | col first first iterations]) average
		rounded
]

{ #category : #margins }
OMBenchmarkResult >> computeReferenceMargin [
	margin := 1.96 * (stdev / 30 sqrt)
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

{ #category : #results }
OMBenchmarkResult >> computeReferenceResults [
	|meansAndStdevs|
	meansAndStdevs := self referenceMeanAndStdev.
	mean := meansAndStdevs first.
	stdev := meansAndStdevs second.
	self computeReferenceMargin
]

{ #category : #computing }
OMBenchmarkResult >> computeReferenceStdev [
	^ (sample collect: [ :col | col first first iterations]) stdev rounded
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
				put: (sample collect: [ :dic | (dic at: key) first iterations]) stdev rounded].
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

{ #category : #periods }
OMBenchmarkResult >> minersPeriodMeansAndStDevs [
	| periodMeans periodStdevs |
	periodMeans := Dictionary new.
	periodStdevs := Dictionary new.
	self minersPeriods
		keysAndValuesDo: [ :scenario :periods | 
			periodMeans at: scenario put: periods average.
			periodStdevs at: scenario put: periods stdev ].
	^ {periodMeans.
	periodStdevs}
]

{ #category : #periods }
OMBenchmarkResult >> minersPeriods [
	| periods |
	periods := Dictionary new.
	self sampleKeys
		do: [ :key | 
			periods
				at: key
				put: (sample collect: [ :dic | (dic at: key) first period asNanoSeconds]) ].
	^ periods
]

{ #category : #periods }
OMBenchmarkResult >> referenceMeanAndStdev [
	|periodMean periodStdev|
	periodMean := self referencePeriods average.
	periodStdev := self referencePeriods stdev.
	^ { periodMean. periodStdev }
]

{ #category : #periods }
OMBenchmarkResult >> referencePeriods [
	^ (sample collect: [ :col | col first first period asNanoSeconds]) 
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
