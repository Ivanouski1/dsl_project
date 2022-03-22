job('MNTLAB-aivanouski1-main-build-job') {
  description 'The Main job'

  parameters {
    gitParam('BRANCH_NAME') {
      description 'Homework 7'
      type 'BRANCH'
      defaultValue 'origin/master'
    }
    activeChoiceReactiveParam('Job_name') {
           description('Allows job choose from multiple choices')
           choiceType('CHECKBOX')
           groovyScript {
               script('return ["MNTLAB-aivanouski1-child1-build-job", "MNTLAB-aivanouski1-child2-build-job", "MNTLAB-aivanouski1-child3-build-job", "MNTLAB-aivanouski1-child4-build-job"]')
           }
    }
  }
  
  scm {
    git {
      remote {
        url 'https://github.com/Ivanouski1/build-t00ls.git'
      }
      branch '$BRANCH_NAME'
    }
  }
  steps {
       downstreamParameterized {
               trigger('$Job_name') {
                 block {
                    buildStepFailure('FAILURE')
                    failure('FAILURE')
                    unstable('UNSTABLE')
                 }
                 parameters {
                     currentBuild()
                 }
           }
       }
   }
}
def JOBS = ["MNTLAB-aivanouski1-child1-build-job", "MNTLAB-aivanouski1-child2-build-job", "MNTLAB-aivanouski1-child3-build-job", "MNTLAB-aivanouski1-child4-build-job"]
for(job in JOBS) {


mavenJob(job) {
  description 'Child work'
  parameters {
    gitParam('BRANCH_NAME') {
      description 'Homework 7 child'
      type 'BRANCH'
    }
    activeChoiceReactiveParam('Job_name') {
           description('Allows job choose from multiple choices')
           choiceType('CHECKBOX')
           groovyScript {
               script('return ["MNTLAB-aivanouski1-child1-build-job", "MNTLAB-aivanouski1-child2-build-job", "MNTLAB-aivanouski1-child3-build-job", "MNTLAB-aivanouski1-child4-build-job"]')
           }
    }
  }  

  scm {
    git {
      remote {
        url 'https://github.com/Ivanouski1/build-t00ls.git'
      }
      branch '$BRANCH_NAME'
    }
  }

  triggers {
    scm 'H/10 * * * *'
  }

  rootPOM 'home-task/pom.xml'
  goals 'clean install'
  postBuildSteps {
        
        shell('echo $BRANCH_NAME') 
        shell('java -cp home-task/target/ci-training-1.jar com.test.Project > output.log')
        shell('tar -czvf ${BRANCH_NAME}_dsl_script.tar.gz output.log')
	    shell('tar -czvf ${BRANCH_NAME}_dsl_script.tar.gz $JENKINS_HOME/jenkinsfile')
    }
  
  publishers {
        archiveArtifacts('*.tar.gz')
    }
}
}