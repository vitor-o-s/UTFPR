import { SnsService } from "@services/sns-service";

import { CustomResponse, HttpRequestWrapper } from "./@types";
import { FunctionAbstract } from "./abstracts/function-abstract";

import { noContent } from "@helpers/response";
import { changeDoorStatusTopic } from "configuration";

enum DoorStatusEnum {
  OPEN = "open",
  CLOSE = "close"
}

type Request = {
  status: DoorStatusEnum;
};

type Response = any;

export class OpenCloseDoorFunction extends FunctionAbstract<Request, Response> {
  static instance: OpenCloseDoorFunction;

  protected buildRequest(request: HttpRequestWrapper<string>): Request {
    return JSON.parse(request.body);
  }

  protected async execute({ status }: Request): Promise<CustomResponse<Response>> {
    const sns = new SnsService(changeDoorStatusTopic);
    const snsPublishResult = await sns.publish({ status });
    console.log({ snsPublishResult });

    return noContent();
  }

  static getInstance() {
    if (!this.instance) {
      this.instance = new this();
    }

    return this.instance;
  }
}
