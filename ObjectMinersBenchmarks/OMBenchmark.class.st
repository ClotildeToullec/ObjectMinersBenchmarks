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

{ #category : #benchmarks }
OMBenchmark >> bench: aBlock [
	 ^aBlock benchFor: self timeToBench 
]

{ #category : #benchmarks }
OMBenchmark >> benchAll [
	|results|
	results := Dictionary new.
	results at: 'Reference no instrumentation' put: self benchReferenceNoInstrumentation.
	results inspect 
]

{ #category : #benchmarks }
OMBenchmark >> benchReferenceNoInstrumentation [ 
	 ^self bench: [self referenceNoInstrumentation ] 
]

{ #category : #'reference methods' }
OMBenchmark >> referenceNoInstrumentation [
	
	((Random new next: 10) squared + 1) asString
]

{ #category : #benchmarks }
OMBenchmark >> timeToBench [
  ^2 seconds
]
