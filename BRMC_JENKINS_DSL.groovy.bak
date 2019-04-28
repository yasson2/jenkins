///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////// Jenkins Function for BRMC ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
def BrmcJob(BRMC_job_name,BRMC_job_display,BRMC_job_cronplan,BRMC_job_script,BRMC_job_plateform_env,BRMC_job_RF_Tags,BRMC_job_VM_to_rely) {
    pipelineJob("$BRMC_job_name") {
        displayName("$BRMC_job_display")
        //label('ubuntu-14.04')
        triggers {
            cron("$BRMC_job_cronplan")
        }
        logRotator {
            numToKeep(3000)
        }
        environmentVariables {
            env('plateform_env', "$BRMC_job_plateform_env")
            env('rf_tags', "$BRMC_job_RF_Tags")
            env('vm', "$BRMC_job_VM_to_rely")
        }
        definition {
            cps {
                script(readFileFromWorkspace("$BRMC_job_script"))
                sandbox()
            }
        }
    }
}

def BrmcView(BRMC_view_name,BRMC_view_regex) {
    listView("$BRMC_view_name") {
        jobs {
            regex(/.*($BRMC_view_regex).*/)
        }
        recurse(true)
        columns {
            status()
            weather()
            name()
            lastSuccess()
            lastFailure()
            robotResults()
        }
    }
}

def BrmcFolder(BRMC_folder_path,BRMC_folder_name,BRMC_folder_dsc) {
    folder("$BRMC_folder_path") {
        displayName("$BRMC_folder_name")
        description("$BRMC_folder_dsc")
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

def BrmcJob_RF_test_CC(BRMC_job_cronplan) {
    return {
        triggers {
            cron("$BRMC_job_cronplan")
        }
        definition {
            cps {
                script('''pipeline {
        agent any
        stages {
            stage('Cleanning the slave') {
                steps {
                    sh 'rm -rf API/log/'
                    sh 'rm -rf IHM/log/'
                }
            }
            stage('Clone test repository from GitLab') {
                steps {
                    git branch: 'master',credentialsId: '932a4ff3-42ce-4523-a730-13d1be57d156', url: 'https://gitlab.forge.orange-labs.fr/BRMC/test-auto-robotframework.git'
                }
            }  
            stage('Installing RobotFramework on Jenkins'){
                steps {
                    tool name: 'Robot Framework', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool'
                }
            }
            stage('Start the RobotFramework Tests') {
                steps {
                    runRFRemoteTests()
                }
            }
            stage('Publish RobotFramework Reports') {
                steps {
                    publishRFReports()
                }
            }
            stage('Publish to Grafana') {
                steps {
                    publish2Grafana()
                }
            }
        }
        post{
            success {
                mattermostSend color: "#18d45c", text: "Pipeline Success of ${currentBuild.fullDisplayName}", message: "${currentBuild.result} - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
                slackSend color: "#18d45c", message: "Pipeline ${currentBuild.fullDisplayName} : ${currentBuild.result} - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
            }
            failure {
                mattermostSend color: "#f9530b", text: "@channel Pipeline Failed of ${currentBuild.fullDisplayName}", message: "${currentBuild.result} - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
                slackSend color: "#f9530b", message: "@channel Pipeline ${currentBuild.fullDisplayName} : ${currentBuild.result} - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
            }
        }
    }

    def runRFRemoteTests() {
        withCredentials([usernamePassword(credentialsId: 'fa235b55-3c49-4482-ac35-4d18990bcd15', passwordVariable: 'cloud_cred_password', usernameVariable: 'cloud_cred_user')]){
            try {
                sh \'\'\'export PATH=/home/jenkins/tools/robotframework/bin:$PATH; cd $RF_ROBOT_FOLDER; robot $RF_TAG_LIST $GEN_REPORT_BOOL $ENV_value -v Comment:${JOB_NAME}_${BUILD_NUMBER} -v JENKINS_BUILD_NUM:${JOB_NAME}_${BUILD_NUMBER} -v username:$cloud_cred_user -v password:$cloud_cred_password $LAST_RF_ARG -d log $ROBOT_FILE.robot\'\'\'
            }
            catch (err) {
                echo "Caught: ${err}"
                currentBuild.result = 'FAILURE'
            }
        }
    }

    def publishRFReports() {
        step([
        $class: 'RobotPublisher',
        disableArchiveOutput: false,
        logFileName: 'log.html',
        onlyCritical: true,
        otherFiles: '*.png',
        outputPath: 'API/log',
        passThreshold: 90,
        reportFileName: 'report.html',
        unstableThreshold: 75
        ])
    }

    def publish2Grafana() {
        try {
            step([
                $class: 'InfluxDbPublisher',
                customData: null,
                customDataMap: null,
                customPrefix: null,
                target: 'brmc-graph'
                //selectedTarget: 'local influxDB', // OPTIONAL, recommended if you have multiple InfluxDB targets configured to ensure you write to correct target
                //jenkinsEnvParameterTag: 'KEY=' + env.PARAM,     // OPTIONAL, custom tags
                //jenkinsEnvParameterField: 'KEY=' + env.PARAM, // OPTIONAL, custom fields
                //measurementName: 'myMeasurementName', // OPTIONAL, custom measurement name
                //replaceDashWithUnderscore: true, // OPTIONAL, replace "-" with "_" for tag names. Default=false
            ])
        }
        catch (err) {
                echo "Caught: ${err}"
                currentBuild.result = 'FAILURE'
        }
    }'''.stripIndent())
                sandbox()
            }
        }
    }
}

def BrmcJob_RF_test_CC_BETA(BRMC_job_cronplan) {
    return {
        logRotator {
            daysToKeep(7)
        }
        triggers {
            cron("$BRMC_job_cronplan")
        }
        definition {
            cps {
                script('''pipeline {
        agent any
        stages {
            stage('Cleanning the slave') {
                steps {
                    sh 'rm -rf API/log/'
                    sh 'rm -rf IHM/log/'
                }
            }
            stage('Clone test repository from GitLab') {
                steps {
                    git branch: 'dev_terminer',credentialsId: '932a4ff3-42ce-4523-a730-13d1be57d156', url: 'https://gitlab.forge.orange-labs.fr/BRMC/test-auto-robotframework.git'
                }
            }  
            stage('Installing RobotFramework on Jenkins'){
                steps {
                    tool name: 'Robot Framework', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool'
                }
            }
            stage('Start the RobotFramework Tests') {
                steps {
                    runRFRemoteTests()
                }
            }
            stage('Publish RobotFramework Reports') {
                steps {
                    publishRFReports()
                }
            }
        }
    }

    def runRFRemoteTests() {
        withCredentials([usernamePassword(credentialsId: 'fa235b55-3c49-4482-ac35-4d18990bcd15', passwordVariable: 'cloud_cred_password', usernameVariable: 'cloud_cred_user')]){
            try {
                sh \'\'\'export PATH=/home/jenkins/tools/robotframework/bin:$PATH; cd $RF_ROBOT_FOLDER; robot $RF_TAG_LIST $GEN_REPORT_BOOL $ENV_value -v Comment:${JOB_NAME}_${BUILD_NUMBER} -v JENKINS_BUILD_NUM:${JOB_NAME}_${BUILD_NUMBER} -v username:$cloud_cred_user -v password:$cloud_cred_password $LAST_RF_ARG -d log $ROBOT_FILE.robot\'\'\'
            }
            catch (err) {
                echo "Caught: ${err}"
                currentBuild.result = 'FAILURE'
            }
        }
    }
    
    def publishRFReports() {
        if (JOBS_BETA_ENABLE != "true"){
            step([
            $class: 'RobotPublisher',
            disableArchiveOutput: false,
            logFileName: 'log.html',
            onlyCritical: true,
            otherFiles: '*.png',
            outputPath: 'API/log',
            passThreshold: 90,
            reportFileName: 'report.html',
            unstableThreshold: 75
            ])
        }
        else {
            // top
        } 
    }'''.stripIndent())
                sandbox()
            }
        }
    }
}

def BrmcJob_Curl_CC(BRMC_job_cronplan) {
    return {
        logRotator {
            daysToKeep(7)
        }
        triggers {
            cron("$BRMC_job_cronplan")
        }
        definition {
            cps {
                script('''pipeline {
        agent any
        stages {
            stage('Healthcheck with CuRL module') {
                steps {
                    HealthCheck('$Healthcheck_URL', 'false')
                }
            }
            stage('Publish to Grafana') {
                steps {
                    publish2Grafana()
                }
            }
        }
        post{
            success {
                mattermostSend color: "#18d45c", text: "Pipeline Success of ${currentBuild.fullDisplayName}", message: "${currentBuild.result} - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
                slackSend color: "#18d45c", message: "Pipeline ${currentBuild.fullDisplayName} : ${currentBuild.result} - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
            }
            failure {
                mattermostSend color: "#f9530b", text: "@channel Pipeline Failed of ${currentBuild.fullDisplayName}", message: "${currentBuild.result} - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
                slackSend color: "#f9530b", message: "@channel Pipeline ${currentBuild.fullDisplayName} : ${currentBuild.result} - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
                mattermostSend channel: 'town-square', color: "#f9530b", text: "@channel Pipeline Failed of ${currentBuild.fullDisplayName}", message: "${currentBuild.result} - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
                slackSend channel: 'jenkins-p0', color: "#f9530b", message: "@channel Pipeline ${currentBuild.fullDisplayName} : ${currentBuild.result} - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
            }
        }
    }

    def HealthCheck(url,sensitive) {
        try {
            sh \'\'\'no_proxy=$no_proxy,\'\'\' + IP_NO_PROXY + \'\'\'; curl \'\'\' + Healthcheck_URL + \'\'\' --max-time 10 -H "Host: 10.118.113.78" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101 Firefox/52.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" -H "Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3" --compressed -H "DNT: 1" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1" -H "If-Modified-Since: Wed, 07 Nov 2018 10:50:48 GMT" -H "If-None-Match: ""1036-57a10e41fd563""" -H "Cache-Control: max-age=0" \'\'\'
            currentBuild.result = 'SUCCESS'
        }
        catch (err) {
            echo "Caught: ${err}"
            if (sensitive == true){
                currentBuild.result = 'FAILURE'
            }
            else {
                currentBuild.result = 'UNSTABLE'
            }
            
        }
    }
    def publish2Grafana() {
        try {
            step([
                $class: 'InfluxDbPublisher',
                customData: null,
                customDataMap: null,
                customPrefix: null,
                target: 'brmc-graph'
                //selectedTarget: 'local influxDB', // OPTIONAL, recommended if you have multiple InfluxDB targets configured to ensure you write to correct target
                //jenkinsEnvParameterTag: 'KEY=' + env.PARAM,     // OPTIONAL, custom tags
                //jenkinsEnvParameterField: 'KEY=' + env.PARAM, // OPTIONAL, custom fields
                //measurementName: 'myMeasurementName', // OPTIONAL, custom measurement name
                //replaceDashWithUnderscore: true, // OPTIONAL, replace "-" with "_" for tag names. Default=false
            ])
        }
        catch (err) {
                echo "Caught: ${err}"
                currentBuild.result = 'FAILURE'
        }
    }'''.stripIndent())
                sandbox()
            }
        }
    }
}

def BrmcJob_Wget_SGIC_Rapport(BRMC_job_cronplan) {
    return {
        logRotator {
            daysToKeep(7)
        }
        triggers {
            cron("$BRMC_job_cronplan")
        }
        definition {
            cps {
                script('''pipeline {
        agent any
        stages {
            stage('Clean Workspace') {
                steps {
                    sh \'\'\'rm -f report*.txt; rm -f number.txt\'\'\'
                }
            }
            stage('Wget the report result with CuRL module') {
                steps {
                    sh \'\'\'no_proxy=$no_proxy,\'\'\' + report_SRV + \'\'\';wget http://\'\'\' + report_SRV +\'\'\'/\'\'\'+ report_file_name
                }
            }
            stage('Check if any port is open') {
                steps {
                    CheckSecPort()
                }
            }
            stage('Publish to Grafana') {
                steps {
                    publish2Grafana()
                }
            }
        }
        post{
            success {
                mattermostSend color: "#18d45c", text: "Pipeline Success of ${currentBuild.fullDisplayName}", message: "${currentBuild.result} - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
                slackSend color: "#18d45c", message: "Pipeline ${currentBuild.fullDisplayName} : ${currentBuild.result} - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
            }
            failure {
                mattermostSend color: "#f9530b", text: "@channel Pipeline Failed of ${currentBuild.fullDisplayName}", message: "${currentBuild.result} - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
                slackSend color: "#f9530b", message: "@channel Pipeline ${currentBuild.fullDisplayName} : ${currentBuild.result} - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
                mattermostSend channel: 'town-square', color: "#f9530b", text: "@channel Pipeline Failed of ${currentBuild.fullDisplayName}", message: "${currentBuild.result} - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
                slackSend channel: 'jenkins-p0', color: "#f9530b", message: "@channel Pipeline ${currentBuild.fullDisplayName} : ${currentBuild.result} - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
            }
        }
    }

    def CheckSecPort() {
        try {
            sh \'\'\'cat report*.txt | grep OPEN | wc -l > number.txt\'\'\'
            def output=readFile('number.txt').trim()
            if (output == '0'){
                currentBuild.result = 'SUCCESS'
            }
            else {
                currentBuild.result = 'FAILURE'
            }
        }
        catch (err) {
            echo "Caught: ${err}"
            currentBuild.result = 'FAILURE' 
        }
    }
    def publish2Grafana() {
        try {
            step([
                $class: 'InfluxDbPublisher',
                customData: null,
                customDataMap: null,
                customPrefix: null,
                target: 'brmc-graph'
                //selectedTarget: 'local influxDB', // OPTIONAL, recommended if you have multiple InfluxDB targets configured to ensure you write to correct target
                //jenkinsEnvParameterTag: 'KEY=' + env.PARAM,     // OPTIONAL, custom tags
                //jenkinsEnvParameterField: 'KEY=' + env.PARAM, // OPTIONAL, custom fields
                //measurementName: 'myMeasurementName', // OPTIONAL, custom measurement name
                //replaceDashWithUnderscore: true, // OPTIONAL, replace "-" with "_" for tag names. Default=false
            ])
        }
        catch (err) {
                echo "Caught: ${err}"
                currentBuild.result = 'FAILURE'
        }
    }'''.stripIndent())
                sandbox()
            }
        }
    }
}

/////////////////////////////////////////////////// List of Jenkins Folder ///////////////////////////////////////////////////
BrmcFolder('PRODUCTION','PRODUCTION','Folder for PRODUCTION ENV')
BrmcFolder('PRODUCTION/ZZZ_BRMC_TOOLBOX','ZZZ_BRMC_TOOLBOX','Folder for toolbox for BRMC as Jenkins Job')

BrmcFolder('PRE-PRODUCTION','PRE-PRODUCTION','Folder for PRE-PRODUCTION ENV')
BrmcFolder('QUALIFICATION','QUALIFICATION','Folder for QUALIFICATION ENV')

BrmcFolder('ZZZ_SANDBOX_JENKINS','ZZZ_SANDBOX_JENKINS','Sandox Folder for testing Jenkins Job')

/////////////////////////////////////////////////// List of Jenkins Filter ///////////////////////////////////////////////////
BrmcView('API','API')
BrmcView('HEALTHCHECK','HEALTH')
BrmcView('PRODUCTION','PRODUCTION')

/////////////////////////////////////////////////// List of Jenkins Jobs ///////////////////////////////////////////////////
// HEALTHCHECK
pipelineJob('PRODUCTION/HEALTHCHECK_BRMC_CUSTOMER_VM_HTTP'){
	displayName("OP HEALTH Test BRMC Customer VM")
    logRotator {
        numToKeep (100)
    }
    environmentVariables {
        env('IP_NO_PROXY', '10.118.113.78')
        env('Healthcheck_URL', 'http://10.118.113.78/index.html')
    }
}.with BrmcJob_Curl_CC("$JENKINS_DSL_cronplan_healthcheck")

pipelineJob('PRODUCTION/HEALTHCHECK_BRMC_PORTAL_HTTP_REQUEST'){
	displayName("OP HEALTH Test BRMC VCAC PORTAL")
    logRotator {
        numToKeep (100)
    }
    environmentVariables {
        env('IP_NO_PROXY', '')
        env('Healthcheck_URL', 'https://brmc.si.fr.intraorange/vcac')
    }
}.with BrmcJob_Curl_CC("$JENKINS_DSL_cronplan_healthcheck")

pipelineJob('PRODUCTION/HEALTHCHECK_BRMC_INFO_HTTP_REQUEST'){
	displayName("OP HEALTH Test BRMC INFO PORTAL")
    logRotator {
        numToKeep (100)
    }
    environmentVariables {
        env('IP_NO_PROXY', '')
        env('Healthcheck_URL', 'http://brmc-info.si.francetelecom.fr')
    }
}.with BrmcJob_Curl_CC("$JENKINS_DSL_cronplan_healthcheck")

pipelineJob('PRODUCTION/API_Token_Generation_Test'){
	displayName("OP API Test token generation")
    logRotator {
        numToKeep (100)
    }
    environmentVariables {
        env('ENV_value', '-v env:pr')
        env('RF_ROBOT_FOLDER', 'API')
        env('GEN_REPORT_BOOL','-v gen_report:false')
        env('RF_TAG_LIST', "--include login")
        env('ROBOT_FILE','LOGIN')
        env('LAST_RF_ARG','')
    }
}.with BrmcJob_RF_test_CC("$JENKINS_DSL_cronplan_healthcheck")

pipelineJob('PRODUCTION/FW_SECURITY_PORT_REPORT'){
	displayName("OP HEALTH FW SECURITY PORT REPORT")
    logRotator {
        numToKeep (100)
    }
    environmentVariables {
        env('report_SRV', '10.118.115.192')
        env('report_file_name', 'report-1-to-60000.txt')
    }
}.with BrmcJob_Wget_SGIC_Rapport("H 7 * * *")

pipelineJob('PRODUCTION/FW_SECURITY_PORT_QUICK_REPORT'){
	displayName("OP HEALTH FW SECURITY PORT QUICK REPORT")
    logRotator {
        numToKeep (100)
    }
    environmentVariables {
        env('report_SRV', '10.118.115.192')
        env('report_file_name', 'report-1-to-1024.txt')
    }
}.with BrmcJob_Wget_SGIC_Rapport("H 7 * * 1")

// FAST
pipelineJob('PRODUCTION/API_FAST_Create_VM_Test_RHEL_7.3'){
	displayName("OP API FAST Create VM RHEL 7.3")
    logRotator {
        daysToKeep (5)
    }
    environmentVariables {
        env('ENV_value', '-v env:pr')
        env('RF_ROBOT_FOLDER', 'API')
        env('GEN_REPORT_BOOL','-v gen_report:false')
        env('RF_TAG_LIST', "--include vm")
        env('ROBOT_FILE','Fast_api')
        env('LAST_RF_ARG','-v RH_version:7.3')
    }
}.with BrmcJob_RF_test_CC("$JENKINS_DSL_cronplan_2h_order")

pipelineJob('PRODUCTION/API_FAST_Create_VM_Test_RHEL_7.4'){
	displayName("OP API FAST Create VM RHEL 7.4")
    logRotator {
        daysToKeep (5)
    }
    environmentVariables {
        env('ENV_value', '-v env:pr')
        env('RF_ROBOT_FOLDER', 'API')
        env('GEN_REPORT_BOOL','-v gen_report:false')
        env('RF_TAG_LIST', "--include vm")
        env('ROBOT_FILE','Fast_api')
        env('LAST_RF_ARG','-v RH_version:7.4')
    }
}.with BrmcJob_RF_test_CC("$JENKINS_DSL_cronplan_2h_order")

pipelineJob('PRODUCTION/API_FAST_NFS_Continous_Test'){
	displayName("OP API FAST NFS Continous Testing")
    logRotator {
        daysToKeep (5)
    }
    environmentVariables {
        env('ENV_value', '-v env:pr')
        env('RF_ROBOT_FOLDER', 'API')
        env('GEN_REPORT_BOOL','-v gen_report:false')
        env('RF_TAG_LIST', "--include nfs")
        env('LAST_RF_ARG', "-v VM_reserve_fast_1:dv0diws00b00015")
        env('ROBOT_FILE','Fast_api')
    }
}.with BrmcJob_RF_test_CC("$JENKINS_DSL_cronplan_min_order")

pipelineJob('PRODUCTION/API_FAST_REBOOT_VM_Continous_Test'){
	displayName("OP API FAST REBOOT VM Continous Testing")
    logRotator {
        daysToKeep (5)
    }
    triggers {
        upstream('PRODUCTION/API_FAST_NFS_Continous_Test', 'FAILURE')
    }
    environmentVariables {
        env('ENV_value', '-v env:pr')
        env('RF_ROBOT_FOLDER', 'API')
        env('GEN_REPORT_BOOL','-v gen_report:false')
        env('RF_TAG_LIST', "--include start_restart")
        env('LAST_RF_ARG', "-v VM_reserve_fast_1:dv0diws00b00015")
        env('ROBOT_FILE','Fast_api')
        env('JOBS_BETA_ENABLE','true')
    }
}.with BrmcJob_RF_test_CC("#Day2_Suite")

pipelineJob('PRODUCTION/API_FAST_CACTUS_Continous_Test'){
	displayName("OP API FAST CACTUS Continous Testing")
    logRotator {
        daysToKeep (5)
    }
    environmentVariables {
        env('ENV_value', '-v env:pr')
        env('RF_ROBOT_FOLDER', 'API')
        env('GEN_REPORT_BOOL','-v gen_report:false')
        env('RF_TAG_LIST', "--include cactus")
        env('LAST_RF_ARG', "-v VM_reserve_fast_1:dv0diws00b00015")
        env('ROBOT_FILE','Fast_api')
        env('JOBS_BETA_ENABLE','true')
    }
}.with BrmcJob_RF_test_CC("$JENKINS_DSL_cronplan_min_order")

// DCAAS
pipelineJob('PRODUCTION/API_DCaaS_Create_VM_Test_RHEL_7.3'){
	displayName("OP API DCaaS Create VM RHEL 7.3")
    logRotator {
        daysToKeep (5)
    }
    environmentVariables {
        env('ENV_value', '-v env:pr')
        env('RF_ROBOT_FOLDER', 'API')
        env('GEN_REPORT_BOOL','-v gen_report:false')
        env('RF_TAG_LIST', "--include vm")
        env('ROBOT_FILE','DCaaS_api')
        env('LAST_RF_ARG','-v RH_version:7.3')
    }
}.with BrmcJob_RF_test_CC("$JENKINS_DSL_cronplan_2h_order")

pipelineJob('PRODUCTION/API_DCaaS_Create_VM_Test_RHEL_7.4'){
	displayName("OP API DCaaS Create VM RHEL 7.4")
    logRotator {
        daysToKeep (5)
    }
    environmentVariables {
        env('ENV_value', '-v env:pr')
        env('RF_ROBOT_FOLDER', 'API')
        env('GEN_REPORT_BOOL','-v gen_report:false')
        env('RF_TAG_LIST', "--include vm")
        env('ROBOT_FILE','DCaaS_api')
        env('LAST_RF_ARG','-v RH_version:7.4')
    }
}.with BrmcJob_RF_test_CC("$JENKINS_DSL_cronplan_2h_order")

pipelineJob('PRODUCTION/API_DCaaS_NFS_Continous_Test'){
	displayName("OP API DCaaS NFS Continous Testing")
    logRotator {
        daysToKeep (5)
    }
    environmentVariables {
        env('ENV_value', '-v env:pr')
        env('RF_ROBOT_FOLDER', 'API')
        env('GEN_REPORT_BOOL','-v gen_report:false')
        env('RF_TAG_LIST', "--include nfs")
        env('LAST_RF_ARG', "-v VM_reserve_dcaas_1:dv0diws00b00016")
        env('ROBOT_FILE','DCaaS_api')
    }
}.with BrmcJob_RF_test_CC("$JENKINS_DSL_cronplan_min_order")

pipelineJob('PRODUCTION/API_DCAAS_REBOOT_VM_Continous_Test'){
	displayName("OP API DCaaS REBOOT VM Continous Testing")
    logRotator {
        daysToKeep (5)
    }
    triggers {
        upstream('PRODUCTION/API_DCaaS_NFS_Continous_Test', 'FAILURE')
    }
    environmentVariables {
        env('ENV_value', '-v env:pr')
        env('RF_ROBOT_FOLDER', 'API')
        env('GEN_REPORT_BOOL','-v gen_report:false')
        env('RF_TAG_LIST', "--include start_restart")
        env('LAST_RF_ARG', "-v VM_reserve_dcaas_1:dv0diws00b00016")
        env('ROBOT_FILE','DCaaS_api')
        env('JOBS_BETA_ENABLE','true')
    }
}.with BrmcJob_RF_test_CC("#Day2_Suite")

pipelineJob('PRODUCTION/API_DCAAS_SGIC_Continous_Test'){
	displayName("OP API DCaaS SGIC Continous Testing")
    logRotator {
        daysToKeep (5)
    }
    environmentVariables {
        env('ENV_value', '-v env:pr')
        env('RF_ROBOT_FOLDER', 'API')
        env('GEN_REPORT_BOOL','-v gen_report:false')
        env('RF_TAG_LIST', "--include sgic")
        env('LAST_RF_ARG', "-v VM_reserve_dcaas_1:dv0diws00b00016")
        env('ROBOT_FILE','DCaaS_api')
        env('JOBS_BETA_ENABLE','true')
    }
}.with BrmcJob_RF_test_CC("$JENKINS_DSL_cronplan_min_order")

pipelineJob('PRODUCTION/API_DCAAS_CACTUS_Continous_Test'){
	displayName("OP API DCaaS CACTUS Continous Testing")
    logRotator {
        daysToKeep (5)
    }
    environmentVariables {
        env('ENV_value', '-v env:pr')
        env('RF_ROBOT_FOLDER', 'API')
        env('GEN_REPORT_BOOL','-v gen_report:false')
        env('RF_TAG_LIST', "--include cactus")
        env('LAST_RF_ARG', "-v VM_reserve_dcaas_1:dv0diws00b00016")
        env('ROBOT_FILE','DCaaS_api')
        env('JOBS_BETA_ENABLE','true')
    }
}.with BrmcJob_RF_test_CC_BETA("$JENKINS_DSL_cronplan_min_order")

// SANDBOX

//BRMC_TOOLBOX
pipelineJob('PRODUCTION/ZZZ_BRMC_TOOLBOX/API_Generate_Jenkins_Reserved_Elements_SGIC'){
	displayName("BRMC TOOLING API Generate Jenkins Reserved Elements : SGIC")
    logRotator {
        numToKeep (5)
    }
    environmentVariables {
        env('ENV_value', '-v env:pr')
        env('RF_TAG_LIST', '--include SGIC')
        env('RF_ROBOT_FOLDER', 'API')
        env('GEN_REPORT_BOOL','-v gen_report:false')
        env('ROBOT_FILE','Create_Reserved_Elements')
        env('LAST_RF_ARG', "-v bg:")
    }
}.with BrmcJob_RF_test_CC("#NULL")

pipelineJob('PRODUCTION/ZZZ_BRMC_TOOLBOX/API_Generate_Jenkins_Reserved_Elements_VM'){
	displayName("BRMC TOOLING API Generate Jenkins Reserved Elements : VM")
    logRotator {
        numToKeep (5)
    }
    environmentVariables {
        env('ENV_value', '-v env:pr')
        env('RF_TAG_LIST', '--include VM')
        env('RF_ROBOT_FOLDER', 'API')
        env('GEN_REPORT_BOOL','-v gen_report:false')
        env('ROBOT_FILE','Create_Reserved_Elements')
        env('LAST_RF_ARG', "-v SGICName: -v bg: -v SGIC_long:")
    }
}.with BrmcJob_RF_test_CC("#NULL")

pipelineJob('PRODUCTION/ZZZ_BRMC_TOOLBOX/API_Generate_Jenkins_Reserved_Elements_NFS'){
	displayName("BRMC TOOLING API Generate Jenkins Reserved Elements : NFS")
    logRotator {
        numToKeep (5)
    }
    environmentVariables {
        env('ENV_value', '-v env:pr')
        env('RF_TAG_LIST', '--include NFS')
        env('RF_ROBOT_FOLDER', 'API')
        env('GEN_REPORT_BOOL','-v gen_report:false')
        env('ROBOT_FILE','Create_Reserved_Elements')
        env('LAST_RF_ARG', "-v bg:")
    }
}.with BrmcJob_RF_test_CC("#NULL")

//DEPRECATED

pipelineJob('PRODUCTION/API_DFY_Create_VM_Test'){
	displayName("OP API DFY Create VM")
    environmentVariables {
        env('ENV_value', '-v env:pr')
        env('RF_ROBOT_FOLDER', 'API')
        env('GEN_REPORT_BOOL','-v gen_report:false')
        env('RF_TAG_LIST', "--include vm")
        env('ROBOT_FILE','DFY_api')
        env('LAST_RF_ARG','-v RH_version:7.3')
    }
}.with BrmcJob_RF_test_CC("$JENKINS_DSL_cronplan_2h_order")

pipelineJob('PRODUCTION/API_DFY_NFS_Continous_Test'){
	displayName("OP API DFY NFS Continous Testing")
    environmentVariables {
        env('ENV_value', '-v env:pr')
        env('RF_ROBOT_FOLDER', 'API')
        env('GEN_REPORT_BOOL','-v gen_report:false')
        env('RF_TAG_LIST', "--include nfs")
        env('LAST_RF_ARG', "-v VM2:DF00671")
        env('ROBOT_FILE','DFY_api')
    }
}.with BrmcJob_RF_test_CC("$JENKINS_DSL_cronplan_min_order")
