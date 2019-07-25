//test demo pipeline 

def name='cherrysri/hubtest'
def tag='testing'
def prod_tag='prod'
def perf_tag='perf'
def user='cherrysri'
def testable='test_ready'


def pushToImage(name, tag, user){
 sh "/usr/local/bin/docker tag $name:$tag $name:$tag"
 sh "/usr/local/bin/docker push $name:$tag"
 echo "Image push complete"
}

def pullImage(name, tag, user){
 sh "/usr/local/bin/docker pull $name:$tag"
 echo "Image pull complete"
}

def tagImage(name, tag, testable){
 sh "/usr/local/bin/docker tag $name:$tag $name:$testable"
 echo "Image tag complete"
}


node {
//     stage('Initialize'){
//     def dockerHome = tool 'myDocker'
//     def mavenHome  = tool 'maven3'
//     env.PATH = "${mavenHome}/bin:${env.PATH}"
// }
   stage("Setup"){
	git poll: true, credentialsId: '8c3acf9a-80aa-446b-b1a1-95e1f78d267f', url: 'https://github.com/smkptc/dockerhub.git'	
}
   stage('Pull & Build'){

    // docker.pull("cherrysri/hubtest:testing")
withCredentials([string(credentialsId: 'okpass', variable: 'tt')]) {

    sh "echo $tt|/usr/local/bin/docker login -u $user --password-stdin"

    
}
                 pullImage(name, tag, user)  


}
    stage("Run smoke/ functional"){
        tagImage(name, tag, testable)
    }
     stage("pushToPerformanceTest"){
        //  input message: 'approveToDeploy', ok: 'PromoteToPerf'
        pushToImage(name, tag, user)
    }
    stage("Performance Test"){
        //Execute perf tests
        sh "/Users/seshu/Desktop/py3/bin/python3 -m bzt /Users/seshu/Desktop/perf/test.yml"

        tagImage(name, testable, perf_tag)
    }
    stage("DeployToProd"){
         input message: 'approveToDeploy', ok: 'ReadyforProd?'
        tagImage(name, perf_tag, prod_tag)
    }
}

  


