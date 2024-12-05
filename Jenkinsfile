#!/usr/bin/env groovy
@Library(value="prospera-jenkins-libraries", changelog=false)
@Library(value="xenv-jenkins-lib", changelog=false) _

def lastCommitInfo = ""
def skippingText = ""
def commitContainsSkip = 0
def slackMessage = ""
def slackChannel = '#ios_builds'
def sourceFile = "simulator_build/Openfield.xcarchive/Products/Applications/Openfield.app"



pipeline {
    agent {
      label 'ios_only'
    }
    environment {
        shouldBuild = "true"
        BLUE_OCEAN_JOB_URL = "${env.HUDSON_URL}blue/organizations/jenkins/ios_build/detail/${env.JOB_BASE_NAME}/${env.BUILD_NUMBER}/pipeline"
        LANG = "en_US.UTF-8"
        PATH = "$PATH:/usr/local/bin:$HOME/.rbenv/bin:$HOME/.rbenv/shims:/usr/bin"
    }
    options {
        ansiColor("xterm")
        timestamps()
        timeout(time: 5, unit: 'HOURS')
        buildDiscarder(logRotator(numToKeepStr:'10'))
        disableConcurrentBuilds abortPrevious: true
    }

    parameters {
        gitParameter branch: '', branchFilter: 'origin/production|origin/qa', defaultValue: 'origin/qa', description: 'Source branch.', name: 'BRANCH', quickFilterEnabled: false, selectedValue: 'NONE', sortMode: 'NONE', tagFilter: '*', type: 'GitParameterDefinition'
        extendedChoice bindings: '', description: 'lanes from Fastlane file', groovyClasspath: '', groovyScript: '''
            import jenkins.model.*
            import com.cloudbees.plugins.credentials.*
            import com.cloudbees.plugins.credentials.common.*
            import com.cloudbees.plugins.credentials.domains.*;

            def jenkinsCredentials = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
            com.cloudbees.plugins.credentials.Credentials.class,
            Jenkins.instance,
            null,
            null
            );
            def username
            def password
            for (creds in jenkinsCredentials)
            {
            if(creds.id == "ci@prospera.ag")
            {
                username = 'ci-prospera' //creds.username
                password = creds.password
                break
            }
            }
            response = "curl  -u $username:$password https://api.bitbucket.org/2.0/repositories/prosperaag/openfield-ios/src/28391a607fe3a154b48a02898be92486e58ed363/fastlane/Fastfile?at=automated_build_qa".execute().text

            List<String> lanes_list = new ArrayList<String>()
            lanes_list.add('SELECT A LANE!!!')
            def build_arr = response.readLines().findAll({x -> x ==~ /.*lane\\s:(?<lane>.+?)\\s.*$/ }).
                collect { it.stripIndent().replaceAll(\' do\', \'\').replaceAll(\'lane :\', \'\') }
            for(item in build_arr){
                lanes_list.add(item)
            }
            return lanes_list.sort()''', multiSelectDelimiter: ',', name: 'LANE', quoteValue: false, saveJSONParameterToFile: false, type: 'PT_SINGLE_SELECT', visibleItemCount: 30
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    set_shared_lib()
                    color_print.blue("Git checkout to ${params.BRANCH}")
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: params.BRANCH]],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [],
                        submoduleCfg: [],
                        userRemoteConfigs: [[credentialsId: 'constantinpaigin_bitbucket', url: 'git@bitbucket.org:prosperaag/openfield-ios.git']]
                    ])
                }
            }
        }
        stage('Init') {
            steps {
                script {
                    lastCommitInfo = sh(script: "git log -1", returnStdout: true).trim()
                    commitContainsSkip = sh(script: "git log -1 | grep '.*\\[skip ci\\].*'", returnStatus: true)
                    color_print.green("Lane ${env.LANE} selected")
                    color_print.blue('Creating empty fastlane/.env.secret file')
                    sh 'touch fastlane/.env.secret'
                    color_print.blue('Setting up rbenv')
                    sh '''
                        eval "$(rbenv init -)"
                        rbenv global 2.7.5
                        bundle update --bundler
                        bundle update
                    '''

                    if(commitContainsSkip == 0) {
                        skippingText = "Skipping commit."
                        env.shouldBuild = false
                        currentBuild.result = "NOT_BUILT"
                    }

                    slackMessage = "*${env.JOB_NAME}* *${env.GIT_BRANCH}* started. ${skippingText}\nHere is commmit info:\n ${lastCommitInfo}"

                }
            }
        }

        stage('Notify Slack') {
            steps {
                slackSend channel: slackChannel, color: "#2222FF", message: slackMessage
            }
        }

        stage('Run Tests') {
            when {
                expression {
                    return env.shouldBuild != "false"
                }
            }
            steps {
                script {
                    try {
                        withCredentials([string(credentialsId: 'KEYCHAIN_USER_PASS_MAC_2_PORTS', variable: 'KEYCHAIN_USER_PASS')]) {
                            color_print.blue("unlocking keychain")
                            sh "security unlock-keychain -p ${KEYCHAIN_USER_PASS}"
                        }
                        withCredentials([
                            string(credentialsId: 'FASTLANE_APPLE_PASSWORD', variable: 'FASTLANE_APPLE_PASSWORD'),
                            string(credentialsId: 'IOS_FIREBASE_APP_ID_QA', variable: 'FIREBASE_APP_ID_QA'),
                            string(credentialsId: 'IOS_FIREBASE_CLI_TOKEN_QA', variable: 'FIREBASE_CLI_TOKEN_QA'),
                            string(credentialsId: 'IOS_FIREBASE_APP_TOKEN_QA', variable: 'FIREBASE_APP_TOKEN_QA')]) {
                                sh '''
                                    eval "$(rbenv init -)"
                                    rbenv global 2.7.5
                                    bundle exec fastlane pod_install
                                    bundle exec fastlane generate_r_swift
                                    bundle exec fastlane test_app
                                '''
                                env.IOS_VERSION_NUMBER = sh(script: "eval \"\$(rbenv init -)\" && bundle e fastlane run get_version_number | grep Result |  awk '{print \$3}'", returnStdout: true).replaceAll("\\.*", "").trim()
                                env.IOS_BUILD_NUMBER = sh(script: "eval \"\$(rbenv init -)\" && bundle e fastlane run get_build_number | grep Result |  awk '{print \$3}'", returnStdout: true).replaceAll("\\.*", "").trim()
                        }
                    } catch(exc) {
                        currentBuild.result = "UNSTABLE"
                        error('Tests failed')
                    }
                }
            }
        }

        stage('Build and deploy QA') {
            when {
                allOf {
                    environment name: 'shouldBuild', value: 'true';
                    environment name: 'LANE', value: 'build_for_firebase_qa'
                }
            }
            environment {
                ENV = "qa"
            }
            steps {
                script{
                    withCredentials([string(credentialsId: 'KEYCHAIN_USER_PASS_MAC_2_PORTS', variable: 'KEYCHAIN_USER_PASS')]) {
                        color_print.blue("unlocking keychain")
                        sh "security unlock-keychain -p ${KEYCHAIN_USER_PASS}"
                    }
                    withCredentials([
                        string(credentialsId: 'FASTLANE_APPLE_PASSWORD', variable: 'FASTLANE_APPLE_PASSWORD'),
                        string(credentialsId: 'IOS_FIREBASE_APP_ID_QA', variable: 'FIREBASE_APP_ID_QA'),
                        string(credentialsId: 'IOS_FIREBASE_CLI_TOKEN_QA', variable: 'FIREBASE_CLI_TOKEN_QA'),
                        string(credentialsId: 'IOS_FIREBASE_APP_TOKEN_QA', variable: 'FIREBASE_APP_TOKEN_QA')]) {
                            sh '''
                                eval "$(rbenv init -)"
                                rbenv global 2.7.5
                                bundle exec fastlane "${LANE}"
                            '''
                    }
                }
            }
            post{
                success{
                    script {
                        if (fileExists(file: sourceFile)) {
                            env.IOS_ARTIFACT = "Openfield-${env.IOS_VERSION_NUMBER}.${env.IOS_BUILD_NUMBER}-${env.ENV}.app.zip"
                            sh """
                            zip -vr ${IOS_ARTIFACT} simulator_build/Openfield.xcarchive/Products/Applications/Openfield.app
                            """
                            withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "AWS_OF_AUTOMATION", accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                                color_print.blue("Uploading ${env.IOS_ARTIFACT} file to S3")
                                sh "aws s3 cp ${env.IOS_ARTIFACT} s3://prospera-mobile-uploads/ios/${env.ENV}/"
                            }
                        }
                    }
                }
            }
        }
        stage('Build and deploy Staging') {
            when {
                allOf {
                    environment name: 'shouldBuild', value: 'true';
                    environment name: 'LANE', value: 'build_for_firebase_staging'
                }
            }
            environment {
                ENV = "staging"
            }
            steps {
                script{
                    withCredentials([string(credentialsId: 'KEYCHAIN_USER_PASS_MAC_2_PORTS', variable: 'KEYCHAIN_USER_PASS')]) {
                        color_print.blue("unlocking keychain")
                        sh "security unlock-keychain -p ${KEYCHAIN_USER_PASS}"
                    }
                    withCredentials([
                        string(credentialsId: 'FASTLANE_APPLE_PASSWORD', variable: 'FASTLANE_APPLE_PASSWORD'),
                        string(credentialsId: 'IOS_FIREBASE_APP_ID_STAGING', variable: 'FIREBASE_APP_ID_STAGING'),
                        string(credentialsId: 'IOS_FIREBASE_CLI_TOKEN_STAGING', variable: 'FIREBASE_CLI_TOKEN_STAGING'),
                        string(credentialsId: 'IOS_FIREBASE_APP_TOKEN_STAGING', variable: 'FIREBASE_APP_TOKEN_STAGING')]) {
                        sh '''
                            eval "$(rbenv init -)"
                            rbenv global 2.7.5
                            bundle exec fastlane "${LANE}"
                        '''
                    }
                }
            }
            post {
                success {
                    script {
                        if (fileExists(file: sourceFile)) {
                            env.IOS_ARTIFACT = "Openfield-${env.IOS_VERSION_NUMBER}.${env.IOS_BUILD_NUMBER}-${env.ENV}.app.zip"
                            sh """
                            zip -vr ${IOS_ARTIFACT} simulator_build/Openfield.xcarchive/Products/Applications/Openfield.app
                            """
                            withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "AWS_OF_AUTOMATION", accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                                color_print.blue("Uploading ${env.IOS_ARTIFACT} file to S3")
                                sh "aws s3 cp ${env.IOS_ARTIFACT} s3://prospera-mobile-uploads/ios/${env.ENV}/"
                            }
                        }
                    }
                }
            }
        }
        stage('Build and deploy TestFlight PROD') {
            when {
                allOf {
                    environment name: 'shouldBuild', value: 'true';
                    environment name: 'LANE', value: 'build_for_testflight'
                }
            }
            environment {
                ENV = "prod"
            }
            steps {
                script {
                    withCredentials([string(credentialsId: 'KEYCHAIN_USER_PASS_MAC_2_PORTS', variable: 'KEYCHAIN_USER_PASS')]) {
                        color_print.blue("unlocking keychain")
                        sh "security unlock-keychain -p ${KEYCHAIN_USER_PASS}"
                    }
                    withCredentials([string(credentialsId: 'FASTLANE_APPLE_PASSWORD', variable: 'FASTLANE_APPLE_PASSWORD')]) {
                        sh '''
                            eval "$(rbenv init -)"
                            rbenv global 2.7.5
                            bundle exec fastlane "${LANE}"
                        '''
                    }
                }
            }
            
            post{
                success{
                    script {
                        if (fileExists(file: sourceFile)) {
                            env.IOS_ARTIFACT = "Openfield-${env.IOS_VERSION_NUMBER}.${env.IOS_BUILD_NUMBER}-${env.ENV}.app.zip"
                            sh """
                            zip -vr ${IOS_ARTIFACT} simulator_build/Openfield.xcarchive/Products/Applications/Openfield.app
                            """
                            withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "AWS_OF_AUTOMATION", accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                                color_print.blue("Uploading ${env.IOS_ARTIFACT} file to S3")
                                sh "aws s3 cp ${env.IOS_ARTIFACT} s3://prospera-mobile-uploads/ios/${env.ENV}/"
                            }
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo "========pipeline execution succeded========"
            script {
                color_print.green("Build: ${env.JOB_NAME} ${BUILD_ID} success! \nLane: ${env.LANE}")
                recipients = ''
                channel = slackChannel
                subject = ''
                body = "Build: ${env.JOB_NAME} ${BUILD_ID} success! \nLane: ${env.LANE}"
                send_notification.message(
                    recipients,
                    channel,
                    subject,
                    body,
                    'green'
                )
            }
        }
        failure{
            echo "========pipeline execution failed========"
            script {
                color_print.red("Build: ${env.JOB_NAME} ${BUILD_ID} Failed! \nLane: ${env.LANE}")
                send_notification.message(
                    '', //recipients
                    slackChannel, // channel
                    '', // subject
                    "Build: ${env.JOB_NAME} ${BUILD_ID} Failed!\nLane: ${env.LANE}", // body
                    'red' // message color
                )
            }
        }
        unstable{
            echo "========pipeline execution unstable========"
            script {
                color_print.yellow("Build: ${env.JOB_NAME} ${BUILD_ID} is unstable! \nLane: ${env.LANE}")
                send_notification.message(
                    '',
                    slackChannel,
                    '',
                    "*Build:* ${env.JOB_NAME} ${BUILD_ID} *Unstable!* \nLane: ${env.LANE}",
                    'yellow'
                )
            }
        }
        always {
            sh 'printenv'
            cleanWs()
        }
    }
}
