# Test + Analysis Milestone

Screencast: https://youtu.be/jJJOnZmi3TQ

### Team Members:
1. Shantanu Bhoyar - sbhoyar 
2. Akshay Saxena - asaxena5
3. Richa Dua - rdua2
4. Tushar Dahibhate - tdahibh

### In this milestone, we performed the following tasks:
1. Coverage/Jenkins Support
2. Setup automated commit generation - Commit Fuzzer
3. Test Prioritization Analysis
4. Analysis:
    - iTrust
        - Run a static analysis tool
        - Extend the build job to fail the minimum testing criteria
    - checkbox.io
        - Custom metrics

* The [itrust-fuzzer](https://github.ncsu.edu/asaxena5/itrust-fuzzer) repo contains the fuzzing logic and task runner for executing the build 100 times.

* checkbox.io-private [MileStone2](https://github.ncsu.edu/asaxena5/checkbox.io-private/tree/Milestone2) branch contains testcases for threshold checks for custom metrics.

# Tasks
1. Coverage/Jenkins Support

![alt jacoco image](https://github.ncsu.edu/asaxena5/Devops-Project1/blob/ta_milestone/imgs/jacoco.jpeg)


2. Checkbox
Created metrics for calculating following in source-code:
- Max condition
- Long method
- Console log statements in a file


### Contributions
1. Shantanu Bhoyar - Jenkins setup, Test Prioritization analysis
2. Tushar Dahibhate - Fuzzing script, Coverage/Jenkins Support
3. Akshay Saxena - Fuzzer execution script, Checkbox TCs & Jenkins build
4. Richa Dua - checkbox.io AST based metrics
