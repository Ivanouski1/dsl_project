def list_Jobs = ["MNTLAB-aivanouski1-child1-build-job", "MNTLAB-aivanouski1-child2-build-job", "MNTLAB-aivanouski1-child3-build-job", "MNTLAB-aivanouski1-child4-build-job"]

job('MNTLAB-aivanouski1-main-build-job') {

  description 'Main Job'
  label 'built-in'
  parameters {
    activeChoiceParam('BRANCH_NAME') {
      description('Branch name')
        choiceType('SINGLE_SELECT')
        groovyScript {
        script("""def gitURL = "https://github.com/Ivanouski1/build-t00ls.git"
            def command = "git ls-remote -h \$gitURL"
            def proc = command.execute()
            proc.waitFor()
            if ( proc.exitValue() != 0 ) {
              println "Error, \${proc.err.text}"
              System.exit(-1)
            }
            def branches = proc.in.text.readLines().collect {
              it.replaceAll(/[a-z0-9]*\\trefs\\/heads\\//, '')
            }
            return branches
            """)
        fallbackScript()
      }
    }
    activeChoiceReactiveParam('CHILD_NAMES') {
           description('Choose childe jobs')
           choiceType('CHECKBOX')
           groovyScript {
               script('return ["MNTLAB-aivanouski1-child1-build-job", "MNTLAB-aivanouski1-child2-build-job", "MNTLAB-aivanouski1-child3-build-job", "MNTLAB-aivanouski1-child4-build-job"]')
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
    triggerBuilder {
      configs {
        blockableBuildTriggerConfig {
          projects('$CHILD_NAMES')
          block {
            buildStepFailureThreshold('FAILURE')
            unstableThreshold('UNSTABLE')
            failureThreshold('FAILURE')
          }
          configs {
            predefinedBuildParameters {
              properties('BRANCH_NAME=$BRANCH_NAME')
              textParamValueOnNewLine(false)
            }
          } 
        }
      }
    } 
  }
 }
}


    

for(jobs in list_Jobs) {
  
	job(jobs) {
      
 	description 'Child job'
      
  	parameters {
    	stringParam('BRANCH_NAME', '', 'Branche name')
    }  
      
    
    steps {
        maven {
            rootPOM 'home-task/pom.xml'
  		              	goals 'clean install'
            mavenInstallation('mvn3')
        }
      	shell('echo $BRANCH_NAME') 
        shell('java -cp home-task/target/ci-training-1.jar com.test.Project > output.log')
        shell('tar -czvf ${BRANCH_NAME}_dsl_script.tar.gz output.log')
	      shell('tar -czvf ${BRANCH_NAME}_dsl_script.tar.gz $JENKINS_HOME/jenkinsfile')
    }

   scm {
    git {
      remote {
        url 'https://github.com/Ivanouski1/build-t00ls.git'
      }
      branch '$BRANCH_NAME'
    }
  }

  
   
  publishers {
        archiveArtifacts('${BRANCH_NAME}_dsl_script.tar.gz')
    }
}
}