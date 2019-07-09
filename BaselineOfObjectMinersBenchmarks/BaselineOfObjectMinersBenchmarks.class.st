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
				loads: #('ObjectMiners');
				repository: 'github://ClotildeToullec/ObjectMiners'.
				
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
