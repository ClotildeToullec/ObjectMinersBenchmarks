# Benchmarks for Object Miners
## Installation
Install the Pharo launcher and start a fresh Pharo 7 image (https://pharo.org/).

Load ObjectMiners from https://github.com/ClotildeToullec/ObjectMiners (follow instructions from that github project).

Go to Iceberg (cmd+o+i) and checkout branch Collectors 3-optimizations.

Save your image.

## Launch the benchmarks

Open the class browser and go to class `OMBenchmark`. In the instance side, comment or uncomment the parts you want to evaluate. Scripts can be launched from the class side. Data is saved on files. To load and compute the data, use:

```Smalltalk
OMBenchmark new materializeResults.
OMBenchmark new materializeMemoryResults.
```

It is possible that depending on your local folders names the tool does not find his marks, that can be set in methods `materializeResults` and `materializeMemoryResults`.

To facilitate running the benchmarks, some bash scripts are provided in this repository. They must be edited to properly set the virtual machine location.

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
  miner setCondition: 
    (CollectEvaluation new 
      source: 'object bool';
      yourself).
  miner setAction: 
    (CollectEvaluation new 
      source: 'object actionMethod'; 
      yourself).
  miner recordIntermediateObjects: true.
  miner install.
  res := self benchMiner.
  miner uninstall.
  ^ res
```
