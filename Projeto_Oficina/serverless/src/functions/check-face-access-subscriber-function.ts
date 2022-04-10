import { IoTService } from "@services/iot-service";
import { RekognitionService } from "@services/rekognition-service";
import { S3Service } from "@services/s3-service";

import { changeDoorStatusTopic, facesBucket } from "../../configuration";

import { FunctionSubscriberAbstract } from "./abstracts/function-subscriber-abstract";
import { DoorStatusEnum } from "./enums/door-status-enum";

type Message = { fileKeyId: string; fileContentType: string };

export class CheckFaceAccessSubscriberFunction extends FunctionSubscriberAbstract<Message> {
  static instance: CheckFaceAccessSubscriberFunction;

  protected async onErrorOnMessage(error: Error, message: Message): Promise<void> {
    console.log("Error on subscriber");
    console.log({ error, message });
  }

  protected buildRequest(request: string): Message {
    return JSON.parse(request);
  }

  protected async execute({ fileKeyId }: Message): Promise<void> {
    const s3 = new S3Service(facesBucket);

    const file = await s3.findFile(fileKeyId);

    if (!file.Body) {
      console.log("Arquivo não encontrado");
      return;
    }

    const rekognition = new RekognitionService();

    const faceMatch = await rekognition.searchFace(file.Body as string);

    const IoT = new IoTService(changeDoorStatusTopic);

    const status = faceMatch ? DoorStatusEnum.OPEN : DoorStatusEnum.CLOSE;

    await IoT.publishMessage({ status });
  }

  static getInstance() {
    if (!this.instance) {
      this.instance = new this();
    }

    return this.instance;
  }
}
