import { Handler } from "aws-lambda/handler";

import { NewAccessRequestFunction } from "@functions/new-access-request-function";
import { OpenCloseDoorFunction } from "@functions/open-close-door-function";

export const newAccessRequest: Handler = (event, context) => NewAccessRequestFunction.getInstance().run(event, context);
export const openCloseDoor: Handler = (event, context) => OpenCloseDoorFunction.getInstance().run(event, context);
