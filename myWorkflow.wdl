# This workflow runs two tasks (print hello world to a file; print goodbye to a file)
# and then combines their output into one file. Also demonstrates passing string inputs
# which are written to a separate file. A third file collects manually-generated "logging" info.

workflow myWorkflow {
    ### Set variables to be passed with input json and their defaults. These could be used for sample names, etc.
    String title = 'Untitled' # This will show up on cromwell ls
    String description = 'No description'
    call firstTask as first
    call secondTask as second
    call catTask { input: firstFile=first.helloWorldFile, # Set the outputs of firstTask and secondTask as inputs of catTask
                          secondFile=second.goodbyeWorldFile,
                          firstString=first.helloString,
                          secondString=second.goodbyeString,
                          stringToPass=first.passedString }

}

task firstTask {
  String inputString
    command {
        echo "hello world" > hello.txt
    }
    output {
        File helloWorldFile = "hello.txt"
        String helloString = "I said hello." # directly define an ouput variable
        String passedString = inputString # pass the input string to output
    }
    runtime { # must specify a container that will run the commands
        	cpu: 1
        	memory: '128 MB'
        	time: 1
        	container: "centos:7" # shows use of an external image on Dockerhub
          # container: "centos:7" will pull from DockerHub as if running "docker pull centos:7"
    }

}

task secondTask {
  command {
    echo "goodbye" > goodbye.txt
  }
  output {
    File goodbyeWorldFile = "goodbye.txt"
    String goodbyeString = "I said goobye"
  }
  runtime {
    cpu: 1
    memory: '32 MB'
    time: 1
    container: "docker-registry.haib.org/research/clumpify:1" # shows use of a HudsonAlpha custom image, which offers the echo command
  }
}

task catTask{
  File firstFile
  File secondFile
  String firstString
  String secondString
  String stringToPass

  output {
    File outputFile = "output.txt"
    File whatDid = "i_did.txt"
    File whatPassed = "i_passed.txt"
  }

  command {
    cat ${firstFile} ${secondFile} > output.txt
    echo "${firstString} ${secondString}" > i_did.txt
    echo "${stringToPass}" > i_passed.txt
  }

  runtime {
    cpu: 1
    memory: '128 MB'
    time: 1
    container: "docker.io/library/centos:7" # example absolute URL to DockerHub for clarity 
  }
}
