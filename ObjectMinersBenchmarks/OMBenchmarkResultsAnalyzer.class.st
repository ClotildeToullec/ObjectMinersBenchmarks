Class {
	#name : #OMBenchmarkResultsAnalyzer,
	#superclass : #Object,
	#instVars : [
		'x1',
		'x10',
		'x100',
		'x1ref',
		'x10ref',
		'x100ref'
	],
	#category : #ObjectMinersBenchmarks
}

{ #category : #'as yet unclassified' }
OMBenchmarkResultsAnalyzer >> compare: minerResult withReference: refResult [
	| res |
	res := OMBenchmarkResult new.
	res mean: Dictionary new.
	minerResult mean keys
		do: [ :scenario | 
			res mean
				at: scenario
				put:
					(self
						compare: minerResult
						withReference: refResult
						forScenario: scenario) ].
	^ res
]

{ #category : #'as yet unclassified' }
OMBenchmarkResultsAnalyzer >> compare: minerResult withReference: refResult forScenario: scenario [
	| scnMean scnStdev refMean refStdev difference Sp errorMargin overhead overheadMargin|
	scnMean := minerResult mean at: scenario.
	scnStdev := minerResult stdev at: scenario.
	refMean := refResult mean.
	refStdev := refResult stdev.
	(((refStdev squared / scnStdev squared) <= 2) or:[
	 (scnStdev squared / refStdev squared) <= 2]) ifTrue:[('Scenario ', scenario, ' stdevs not in [0,5, 2]') crLog].
	difference := (scnMean - refMean).
	Sp := (((self sampleSize - 1) * scnStdev squared
		+ ((self sampleSize - 1) * refStdev squared))
		/ (2 * self sampleSize - 2)) sqrt.
	errorMargin := self criticalValue * Sp * ((1/self sampleSize) + (1/self sampleSize)) sqrt.
	overhead := (difference / refMean) asFloat.
	overheadMargin := (errorMargin / refMean) asFloat.
	^{difference asFloat. errorMargin. overhead. overheadMargin}
]

{ #category : #'as yet unclassified' }
OMBenchmarkResultsAnalyzer >> criticalValue [
	^1.96
	
	

]

{ #category : #'as yet unclassified' }
OMBenchmarkResultsAnalyzer >> sampleSize [
	^30
	
	

]
