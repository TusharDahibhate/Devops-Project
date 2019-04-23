#!/bin/sh

jenkins_user="$1"
jenkins_pwd="$2"

crumbLine=$(curl --user $jenkins_user:$jenkins_pwd 'http://localhost:8081/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')


curl -X POST http://localhost:8081/credentials/store/system/domain/_/createCredentials -H "$crumbLine" -F secret=@/jenkins-server/iTrust2-v4/iTrust2/src/main/java/db.properties -F 'json={"": "4", "credentials": {"file": "secret", "id": "db_properties", "description": "db_properties", "stapler-class": "org.jenkinsci.plugins.plaincredentials.impl.FileCredentialsImpl", "$class": "org.jenkinsci.plugins.plaincredentials.impl.FileCredentialsImpl"}}' --user "$jenkins_user":"$jenkins_pwd"

curl -X POST http://localhost:8081/credentials/store/system/domain/_/createCredentials -H "$crumbLine" -F secret=@/jenkins-server/iTrust2-v4/iTrust2/src/main/java/email.properties -F 'json={"": "4", "credentials": {"file": "secret", "id": "email_properties", "description": "email_properties", "stapler-class": "org.jenkinsci.plugins.plaincredentials.impl.FileCredentialsImpl", "$class": "org.jenkinsci.plugins.plaincredentials.impl.FileCredentialsImpl"}}' --user "$jenkins_user":"$jenkins_pwd"
