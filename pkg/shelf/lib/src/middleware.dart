// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library shelf.middleware;

import 'request.dart';
import 'response.dart';
import 'handler.dart';
import 'hijack_exception.dart';
import 'util.dart';

/// A function which creates a new [Handler] by wrapping a [Handler].
///
/// You can extend the functions of a [Handler] by wrapping it in
/// [Middleware] that can intercept and process a request before it it sent
/// to a handler, a response after it is sent by a handler, or both.
///
/// Because [Middleware] consumes a [Handler] and returns a new
/// [Handler], multiple [Middleware] instances can be composed
/// together to offer rich functionality.
///
/// Common uses for middleware include caching, logging, and authentication.
///
/// Middleware that captures exceptions should be sure to pass
/// [HijackException]s on without modification.
///
/// A simple [Middleware] can be created using [createMiddleware].
typedef Handler Middleware(Handler innerHandler);

/// Creates a [Middleware] using the provided functions.
///
/// If provided, [requestHandler] receives a [Request]. It can respond to
/// the request by returning a [Response] or [Future<Response>].
/// [requestHandler] can also return `null` for some or all requests in which
/// case the request is sent to the inner [Handler].
///
/// If provided, [responseHandler] is called with the [Response] generated
/// by the inner [Handler]. Responses generated by [requestHandler] are not
/// sent to [responseHandler].
///
/// [responseHandler] should return either a [Response] or
/// [Future<Response>]. It may return the response parameter it receives or
/// create a new response object.
///
/// If provided, [errorHandler] receives errors thrown by the inner handler. It
/// does not receive errors thrown by [requestHandler] or [responseHandler], nor
/// does it receive [HijackException]s. It can either return a new response or
/// throw an error.
Middleware createMiddleware({requestHandler(Request request),
    responseHandler(Response response),
    errorHandler(error, StackTrace stackTrace)}) {
  if (requestHandler == null) requestHandler = (request) => null;

  if (responseHandler == null) responseHandler = (response) => response;

  var onError = null;
  if (errorHandler != null) {
    onError = (error, stackTrace) {
      if (error is HijackException) throw error;
      return errorHandler(error, stackTrace);
    };
  }

  return (Handler innerHandler) {
    return (request) {
      return syncFuture(() => requestHandler(request)).then((response) {
        if (response != null) return response;

        return syncFuture(() => innerHandler(request))
            .then((response) => responseHandler(response), onError: onError);
      });
    };
  };
}
