//test demo pipeline 

def name="cherrysri/dockertest"
def tag="test"
def fun_tag="testing"
def prod_tag="prod"
def perf_tag="perf"

def user="cherrysri"
def testable="test_ready"


def pushToImage(name, tag){
 sh "/usr/local/bin/docker tag $name:$tag $name:$tag"
 sh "/usr/local/bin/docker push $name:$tag"
 echo "Image push complete"
}

def pullImage(name, tag){
 sh "/usr/local/bin/docker pull $name:$tag"
 echo "Image pull complete"
}

def tagImage(name, tag, fun_tag){
 sh "/usr/local/bin/docker tag $name:$tag $name:$fun_tag"
 echo "Image Functional complete"
}
def runTests(name, tag){
 sh "/usr/local/bin/docker run $name:$tag "
 echo "run complete"
}

node {
//     stage('Initialize'){
//     def dockerHome = tool 'myDocker'
//     def mavenHome  = tool 'maven3'
//     env.PATH = "${mavenHome}/bin:${env.PATH}"
// }
  stage("Setup"){
	git poll: true, credentialsId: '8c3acf9a-80aa-446b-b1a1-95e1f78d267f', url: 'https://github.com/smkptc/dockerpipetests.git'	
}
  stage('Pull & Build'){

    // docker.pull("cherrysri/hubtest:testing")
withCredentials([string(credentialsId: 'okpass', variable: 'tt')]) {

    sh "echo $tt|/usr/local/bin/docker login -u $user --password-stdin"

    
}
                 pullImage(name, tag)  


}
    stage("Run smoke/ functional"){
        runTests(name,tag)
        tagImage(name, tag, fun_tag)
    }
     stage("pushToPerformanceTest"){
        //  input message: 'approveToDeploy', ok: 'PromoteToPerf'
        pushToImage(name, fun_tag)
    }
    stage("Performance Test"){
        //Execute perf tests
        sh "/Users/seshu/Desktop/py3/bin/python3 -m bzt /Users/seshu/Desktop/perf/test.yml"
        // tagImage(name, fun_tag, perf_tag)
    }
    stage("DeployToProd"){
         input message: 'approveToDeploy', ok: 'ReadyforProd?'
        tagImage(name, perf_tag, prod_tag)
    }
    stage("prepare results")
    junit testDataPublishers: [[$class: 'StabilityTestDataPublisher']], testResults: 'target/**/*.xml'
    perfReport filterRegex: '', ignoreFailedBuilds: true, ignoreUnstableBuilds: true, junitOutput: '**/*.xml', sourceDataFiles: '**/'
    perfpublisher healthy: '', metrics: '', name: '**/', parseAllMetrics: false, threshold: '', unhealthy: '', unstableThreshold: ''
}

  


