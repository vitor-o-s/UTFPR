import type { AWS, AwsLambdaEnvironment } from "@serverless/typescript";

import { serverlessResources, serverlessRoles } from "./configuration";

const service = "oficina-integracao";

const configuration: AWS = {
  service,
  variablesResolutionMode: "20210326",
  frameworkVersion: ">=1.83.3",
  functions: {
    "new-access-request": {
      handler: "src/handlers.newAccessRequest",
      timeout: 10,
      events: [{ http: { method: "POST", path: "new-access" } }]
    },
    "open-close-door": {
      handler: "src/handlers.openCloseDoor",
      timeout: 10,
      events: [{ http: { method: "PATCH", path: "door" } }]
    }
  },
  useDotenv: true,
  provider: {
    name: "aws",
    runtime: "nodejs14.x",
    lambdaHashingVersion: "20201221",
    stage: "${self:custom.stage}",
    region: "us-east-1",
    versionFunctions: false,
    timeout: 40,
    // tracing: {
    //   apiGateway: true,
    //   lambda: true
    // },
    environment: {
      STAGE: "${opt:stage,'dev'}",
      AWS_ACCOUNT_REGION: "${aws:region}",
      AWS_ACCOUNT_ID: "${aws:accountId}"
    } as AwsLambdaEnvironment,
    iamRoleStatements: serverlessRoles
  },
  custom: {
    stage: "${opt:stage,'dev'}",
    ssm: {}, // "${ssm:/aws/reference/secretsmanager/secret-name}",

    webpack: {
      webpackConfig: "./webpack.config.js",
      includeModules: true,
      packager: "yarn"
    }
  },
  resources: serverlessResources,
  package: {
    // individually: true,
    excludeDevDependencies: true
  },
  plugins: ["serverless-webpack", "serverless-offline"]
};

module.exports = configuration;
