# Benchmarks for Object Miners: load ObjectMiners here
https://github.com/ClotildeToullec/ObjectMiners

# Experiment: instrumenting with Object Miners
In the following we describe how we instrumented a reference method for the evaluation of Object Miners.
The reference method is illustrated below. At run-time it just performs a simple computation:

```Smalltalk
referenceNoInstrumentation
	10 squared + 1
```

## Miner installation
For each scenario, a method is responsible for the installation of a miner.
We show here the *Full Instrumentation* method scenario, for which we use all possible options of the miners.
We create the miner line 3 on the AST node of the expression.
Line 4 we configure the miner to capture reifications.
Lines 6 to 9 and lines 10 to 14 are respectively the configuration of the condition and action.
We configure the miner to capture intermediate objects line 15.
Once it is configured, the miner is installed (line 16).
We run the benchmark (line 17) then uninstall the miner (line 18) and return the result.


```Smalltalk
benchMinersFullNoStack
	| miner res |
	miner := ObjectMiner new reachFromAST: self astForMiner.
	miner captureContext: self reificationsForMiner.
	miner
		setCondition:
			(CollectEvaluation new
				source: 'object bool';
				yourself).
	miner
		setAction:
			(CollectEvaluation new
				source: 'object actionMethod';
				yourself).
	miner recordIntermediateObjects: true.
	miner install.
	res := self benchMiner.
	miner uninstall.
	^ res
```
