Extension { #name : #SmallInteger }

{ #category : #'*ObjectMinersBenchmarks' }
SmallInteger >> asString1 [
	99999 timesRepeat: [ self asString ].
	^self asString
]

{ #category : #'*ObjectMinersBenchmarks' }
SmallInteger >> asString10 [
	499999 timesRepeat: [ self asString ].
	^self asString
]

{ #category : #'*ObjectMinersBenchmarks' }
SmallInteger >> asString100 [
	999999 timesRepeat: [ self asString ].
	^self asString
]

{ #category : #'*ObjectMinersBenchmarks' }
SmallInteger >> asString1000 [
	999999 timesRepeat: [ self asString ].
	^self asString
]
