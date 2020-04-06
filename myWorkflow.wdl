workflow myWorkflow {
    ### Set variables to be passed with input json and their defaults. These could be used for sample names, etc.
    String title = 'Untitled'
    String description = 'No description'
    call myTask
}

task myTask {
    command {
        echo "hello world" > hello.txt
    }
    output {
        File helloWorldFile = "hello.txt"
    }
	runtime {
        	cpu: 1
        	memory: '128 MB'
        	time: 1
        	container: "docker.io/library/centos:7"
    }

}
