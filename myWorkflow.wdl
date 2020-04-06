workflow myWorkflow {
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
        	memory: '1 MB'
        	time: 1
        	container: "docker-registry.haib.org/research/clumpify:1"
    }

}
