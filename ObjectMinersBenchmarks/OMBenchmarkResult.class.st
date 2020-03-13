Class {
	#name : #OMBenchmarkResult,
	#superclass : #Object,
	#instVars : [
		'sample',
		'mean',
		'stdev'
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
OMBenchmarkResult >> computeResults [
	mean := self computeFrequencyMeans.
	stdev := self computeStdev 
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
