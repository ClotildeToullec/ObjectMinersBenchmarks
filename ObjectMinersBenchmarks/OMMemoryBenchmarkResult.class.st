Class {
	#name : #OMMemoryBenchmarkResult,
	#superclass : #OMBenchmarkResult,
	#category : #ObjectMinersBenchmarks
}

{ #category : #computing }
OMMemoryBenchmarkResult >> computeResults [
	self computeReferenceResults
]

{ #category : #periods }
OMMemoryBenchmarkResult >> referencePeriods [
	^ (sample collect: [ :col | (col second / col first) asFloat roundTo: 0.01]) 
]
