workflow myWorkflow {
    ### Set variables to be passed with input json and their defaults. These could be used for sample names, etc.
    String title = 'Untitled'
    String description = 'No description'
    call firstTask as first
    call secondTask as second
    call catTask { input: firstFile=first.helloWorldFile,
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
        String helloString = "I said hello."
        String passedString = inputString
    }
    runtime {
        	cpu: 1
        	memory: '128 MB'
        	time: 1
        	container: "docker.io/library/centos:7"
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
    memory: '128 MB'
    time: 1
    container: "docker.io/library/centos:7"
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
    container: "docker.io/library/centos:7"
  }
}
