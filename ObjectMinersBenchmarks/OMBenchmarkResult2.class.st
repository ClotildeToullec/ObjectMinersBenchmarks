Class {
	#name : #OMBenchmarkResult2,
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
OMBenchmarkResult2 >> computeFrequencyMeans [
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
OMBenchmarkResult2 >> computeMemoryOverheadMean [
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
OMBenchmarkResult2 >> computeMemoryOverheadStdev [
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
OMBenchmarkResult2 >> computeMinersMargin [
	margin := Dictionary new.
	stdev
		keysAndValuesDo: [ :scn :dev | margin at: scn put: 1.96 * (dev / 30 sqrt) ]
]

{ #category : #results }
OMBenchmarkResult2 >> computeMinersResults [
	|meansAndStdevs|
	meansAndStdevs := self minersPeriodMeansAndStDevs.
	mean := meansAndStdevs first.
	stdev :=  meansAndStdevs second.
	self computeMinersMargin
	
]

{ #category : #computing }
OMBenchmarkResult2 >> computeReferenceFrequencyMeans [
	^ (sample collect: [ :col | col first first iterations]) average
		rounded
]

{ #category : #margins }
OMBenchmarkResult2 >> computeReferenceMargin [
	margin := 1.96 * (stdev / 30 sqrt)
]

{ #category : #computing }
OMBenchmarkResult2 >> computeReferenceMemoryOverhead [
	^ (sample collect: [ :col | col first first frequency ]) stdev rounded
]

{ #category : #computing }
OMBenchmarkResult2 >> computeReferenceMemoryOverheadMean [
	^ (sample collect: [ :col | col third / col second ]) average rounded
]

{ #category : #computing }
OMBenchmarkResult2 >> computeReferenceMemoryOverheadStdev [
	^ (sample collect: [ :col | col third / col second ]) stdev rounded
]

{ #category : #results }
OMBenchmarkResult2 >> computeReferenceResults [
	|meansAndStdevs|
	meansAndStdevs := self referenceMeanAndStdev.
	mean := meansAndStdevs first.
	stdev := meansAndStdevs second.
	self computeReferenceMargin
]

{ #category : #computing }
OMBenchmarkResult2 >> computeReferenceStdev [
	^ (sample collect: [ :col | col first first iterations]) stdev rounded
]

{ #category : #computing }
OMBenchmarkResult2 >> computeResults [
	sample isDictionary ifTrue:[^self computeMinersResults].
	self computeReferenceResults 
]

{ #category : #computing }
OMBenchmarkResult2 >> computeStdev [
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
OMBenchmarkResult2 >> margin [
	^ margin
]

{ #category : #accessing }
OMBenchmarkResult2 >> margin: anObject [
	margin := anObject
]

{ #category : #accessing }
OMBenchmarkResult2 >> mean [
	^ mean
]

{ #category : #accessing }
OMBenchmarkResult2 >> mean: anObject [
	mean := anObject
]

{ #category : #periods }
OMBenchmarkResult2 >> minersPeriodMeansAndStDevs [
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
OMBenchmarkResult2 >> minersPeriods [
	| periods |
	periods := Dictionary new.
	self sampleKeys
		do: [ :key | 
			periods
				at: key
				put: (sample at: key)] .
	^ periods
]

{ #category : #periods }
OMBenchmarkResult2 >> referenceMeanAndStdev [
	|periodMean periodStdev|
	periodMean := self referencePeriods average.
	periodStdev := self referencePeriods stdev.
	^ { periodMean. periodStdev }
]

{ #category : #periods }
OMBenchmarkResult2 >> referencePeriods [
	^ (sample ) 
]

{ #category : #accessing }
OMBenchmarkResult2 >> sample [
	^ sample
]

{ #category : #accessing }
OMBenchmarkResult2 >> sample: anObject [
	sample := anObject
]

{ #category : #computing }
OMBenchmarkResult2 >> sampleKeys [
	^sample keys
]

{ #category : #accessing }
OMBenchmarkResult2 >> stdev [
	^ stdev
]

{ #category : #accessing }
OMBenchmarkResult2 >> stdev: anObject [
	stdev := anObject
]
