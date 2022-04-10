import { Rekognition } from "aws-sdk";

export class RekognitionService {
  private rekognition: Rekognition;

  constructor() {
    this.rekognition = new Rekognition();
  }

  async searchFace(encodedPhoto: string) {
    const searchResult = await this.rekognition
      .searchFacesByImage({
        CollectionId: process.env.REKOGNITION_COLLECTION_ID!,
        FaceMatchThreshold: 70, // set minumum match in image send
        Image: {
          Bytes: encodedPhoto
        },
        MaxFaces: 1 // set the number face detect in image send
      })
      .promise();

    const { FaceMatches } = searchResult;

    return FaceMatches ? FaceMatches[0] : undefined;
  }
}
