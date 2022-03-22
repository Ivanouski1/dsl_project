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
        url 'https://github.com/Ivanouski1/build-t00ls'
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
        url 'https://github.com/Ivanouski1/build-t00ls'
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
        shell('nohup java -jar home-task/target/hw3-app-1.0.jar com.test >> home-task/target/output.log')
        shell('tar -cvf "$(echo $BRANCH_NAME | cut -d "/" -f 2)_dsl_script.tar.gz" home-task/target/*.jar home-task/target/output.log')
    }
  
  publishers {
        archiveArtifacts('*.tar.gz')
    }
}
}