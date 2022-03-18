import type { AWS } from "@serverless/typescript";

const service = "oficina-integracao-resource";

const configuration: AWS = {
  service,
  frameworkVersion: "2",
  provider: {
    name: "aws",
    runtime: "nodejs14.x",
    environment: {
      STAGE: "${opt:stage,'dev'}",
      AWS_PROFILE: "${opt:stage,'dev'}",
    },
    tags: {},
  },
  resources: {
    Resources: {
      // Dynamo resources
      FacesTable: {
        Type: "AWS::DynamoDB::Table",
        DeletionPolicy: "Retain",
        Properties: {
          TableName: "FacesTable",
          // BillingMode: "PAY_PER_REQUEST", sob demanda não entra no plano free
          ProvisionedThroughput: {
            ReadCapacityUnits: 2,
            WriteCapacityUnits: 2,
          },
          AttributeDefinitions: [
            {
              AttributeName: "id",
              AttributeType: "S",
            },
          ],
          KeySchema: [
            {
              AttributeName: "id",
              KeyType: "HASH",
            },
          ],
        },
      },

      // SNS resources
      PhotoTopic: {
        Type: "AWS::SNS::Topic",
        Properties: {
          DisplayName: "Receberá todas as fotos tiradas no ESP",
          TopicName: "PHOTO_TOPIC",
        },
      },
      ChangeDoorStatusTopic: {
        Type: "AWS::SNS::Topic",
        Properties: {
          DisplayName:
            "Receberá ordens de alteração de status da porta para aberto/fechado",
          TopicName: "CHANGE_DOOR_STATUS_TOPIC",
        },
      },

      // S3 resources
      MyBucket: {
        Type: "AWS::S3::Bucket",
        Properties: {
          BucketName: "faces-bucket",
          AccessControl: "PublicRead",
        },
      },
    },
    Outputs: {},
  },
};

module.exports = configuration;
