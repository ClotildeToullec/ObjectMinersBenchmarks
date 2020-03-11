Extension { #name : #SmallInteger }

{ #category : #'*ObjectMinersBenchmarks' }
SmallInteger >> asString1 [
	^self asString
]

{ #category : #'*ObjectMinersBenchmarks' }
SmallInteger >> asString10 [
	9 timesRepeat: [ self asString ].
	^self asString
]

{ #category : #'*ObjectMinersBenchmarks' }
SmallInteger >> asString100 [
	99 timesRepeat: [ self asString ].
	^self asString
]
