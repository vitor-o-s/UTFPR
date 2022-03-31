import { TelegramService } from "@services/telegram-service";

import { FunctionSubscriberAbstract } from "./abstracts/function-subscriber-abstract";

import { facesBucket } from "configuration";

type Message = { fileKeyId: string; fileContentType: string };

export class NotifyUserSubscriberFunction extends FunctionSubscriberAbstract<Message> {
  static instance: NotifyUserSubscriberFunction;

  protected async onErrorOnMessage(error: Error, message: Message): Promise<void> {
    console.log("Error on subscriber");
    console.log({ error, message });
  }

  protected buildRequest(request: string): Message {
    return JSON.parse(request);
  }

  protected async execute({ fileKeyId }: Message): Promise<void> {
    const telegramService = new TelegramService();
    const photoUrl = `https://${facesBucket}.s3.us-east-1.amazonaws.com/${fileKeyId}`;

    const message = `Nova requisição de entrada às ${new Date()} \n visualize a foto ${photoUrl}`;

    console.log("Enviando mensagem para telegram", message);

    const resultMessage = await telegramService.sendNotification(message);

    console.log("Resultado envio mensage", JSON.stringify(resultMessage));
  }

  static getInstance() {
    if (!this.instance) {
      this.instance = new this();
    }

    return this.instance;
  }
}
