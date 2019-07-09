Class {
	#name : #BaselineOfObjectMinersBenchmarks,
	#superclass : #BaselineOf,
	#category : #BaselineOfObjectMinersBenchmarks
}

{ #category : #script }
BaselineOfObjectMinersBenchmarks >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec postLoadDoIt: #postload:package:.
			spec
				baseline: 'Collectors'
				with:
					[ spec repository: 'github://StevenCostiou/Collectors:3-Optimizations' ].
			spec
				baseline: 'ObjectMiners'
				with: [ spec repository: 'github://ClotildeToullec/ObjectMiners'.
					spec package: 'ObjectMiners' ].
			spec repository: 'github://ClotildeToullec/ObjectMinersBenchmarks'.
			spec package: 'ObjectMinersBenchmarks' ]
]

{ #category : #script }
BaselineOfObjectMinersBenchmarks >> postLoad [
	ObjectMinersIcons loadIconsFromGithub
]

{ #category : #script }
BaselineOfObjectMinersBenchmarks >> postload: loader package: packageSpec [
	self postLoad
]
