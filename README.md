# A simple Cromwell+Docker test case
## Description
This workflow runs two tasks in parallel:
1. Print "hello world" to a file. Take a string input and return it to the next process. Print "I said hello" to another file.
2. Print "goodbye" to a file. Print "I said goodbye" to another file.

And then combines them in the third step, making outputs:
1. A combined file that says "hello world" and "goobye"
2. A second combined file that says "I said hello. I said goodbye."
3. A file that contains the string input submitted by the user.

The included croo file does the following:
1. Calls output #1 `final_output.txt`
2. Calls output #2 `my_output_log.txt`
3. Calls output #3 `my_commentary.txt`
4. Puts the "hello world" file at `intermediate_outputs/hello_file.txt`
5. Puts the "goodbye" file at `intermediate_outputs/goodbye_file.txt`
6. Prints output file paths and descriptions in a table: `croo.filetable.<RUN_ID>.tsv` and `croo.report.<RUN_ID>.html`

Croo is copying output files from `/gpfs/gpfs1/cromwell/cromwell-executions/myWorkflow/<RUN_ID>`. You can also find LSF logs and other information there, in a byzantine file structure.

## Usage
```bash
# Setup
git clone
module load g/cromwell_cli

# Use Cromwell's WOMTool to verify WDL and provided input file
java -jar /gpfs/gpfs1/home/jlawlor/cromwell_test/womtool-49.jar validate myWorkflow.wdl -i myInput.json
# What if we didn't have a pre-made input file?
# Let's use the WOMTool to generate our own input file from the WDL and validate it
# We can leave newInput.json as-is (with the variable descriptions as input data) or put in values of our own.
java -jar /gpfs/gpfs1/home/jlawlor/cromwell_test/womtool-49.jar inputs myWorkflow.wdl > newInput.json
java -jar /gpfs/gpfs1/home/jlawlor/cromwell_test/womtool-49.jar validate myWorkflow.wdl -i newInput.json
cromwell submit myWorkflow.wdl newInput.json
cromwell ls
# Wait for cromwell job to be marked as "Succeeded". Take note of the cromwell Id from cromwell ls
cromwell croo <RUN_ID> myCroo.json my_outputs
cd my_outputs
ls -R
```
Should show something like:
```bash
[jlawlor@hpc0004 cromwell_test]$ ls -Rlh my_outputs/
my_outputs/:
total 128K
-rw-r--r-- 1 jlawlor gcooper-lab  816 Apr  7 22:32 croo.filetable.b5efab9f-ae1d-482f-b4a1-1d1948968906.tsv
-rw-r--r-- 1 jlawlor gcooper-lab 2.6K Apr  7 22:32 croo.report.b5efab9f-ae1d-482f-b4a1-1d1948968906.html
-rw-r--r-- 1 jlawlor gcooper-lab   20 Apr  7 21:56 final_output.txt
drwxr-xr-x 2 jlawlor gcooper-lab  512 Apr  7 22:32 intermediate_outputs
-rw-r--r-- 1 jlawlor gcooper-lab    7 Apr  7 21:56 my_commentary.txt
-rw-r--r-- 1 jlawlor gcooper-lab   28 Apr  7 21:56 my_output_log.txt

output5/intermediate_outputs:
total 0
-rw-r--r-- 1 jlawlor gcooper-lab  8 Apr  7 21:56 goodbye_file.txt
-rw-r--r-- 1 jlawlor gcooper-lab 12 Apr  7 21:56 hello_file.txt

```

## Useful Info
[Markdown Specification](https://github.com/openwdl/wdl/blob/master/versions/1.0/SPEC.md)
[Broad Cromwell Intro](https://cromwell.readthedocs.io/en/stable/tutorials/FiveMinuteIntro/)
