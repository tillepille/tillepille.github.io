---
title: "OpenTelemetry for FastAPI"
date: 2022-10-13T18:56:24+02:00
draft: false
---

## What is FastAPI

[FastAPI](https://github.com/tiangolo/fastapi) is a Python framework for building, you guessed it, APIs.
I especially like it because it's so simple to use.

## What is OTel

OTel, or better [OpenTelemetry](https://opentelemetry.io), is the next iteration of defining one standard to ship traces, metrics and logs in a common format so you'll never be vendor-locked for your observability solution.

Since all major observability tools are heavily investing on it and we want to move to a different solution in the future, this is the best solution to let your code run anywhere.

For many programming languages and frameworks there are packages available, including FastAPI:  [opentelemetry-python-contrib.readthedocs.io/en/latest/instrumentation/fastapi](https://opentelemetry-python-contrib.readthedocs.io/en/latest/instrumentation/fastapi/fastapi.html)

## What am I missing?

So I added the code from the documentation above, but nothing arrived at my collector.
What was missing?

Turns out, if you don't use the complete auto-instrumentation, you have to add an exporter yourself!
Check out a complete implementation below:

```python
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor

#create your FastAPI app
app = FastAPI()

trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)

otlp_exporter = OTLPSpanExporter()
span_processor = BatchSpanProcessor(otlp_exporter) # we don't want to export every single trace by itself but rather batch them
otlp_tracer = trace.get_tracer_provider().add_span_processor(span_processor)

# now the official documented part
FastAPIInstrumentor.instrument_app(app,tracer_provider=otlp_tracer)

@app.get("/")
async def index():
    return {"foo": "bar"}

```

## Kubernetes Deployment

So now, after getting the stuff inside your container right, it's time to spiff out the outer parts.
Luckily, you basically just have to set your OTel Endpoint via `OTEL_EXPORTER_OTLP_ENDPOINT`.

_Hint: It's the same variable name, no matter which language you use, one of the elegancies of OTel..._

```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fastapi-otel-app
spec:
  selector:
    matchLabels:
      app: fastapi-otel-app
  template:
    metadata:
      labels:
        app: fastapi-otel-app
  spec:
    containers: 
    - image: fastapi-otel-app:latest
      command: ["/venv/bin/uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
      env:
      - name: OTEL_EXPORTER_OTLP_ENDPOINT
        value: "http://otel-collector.svc.monitoring.cluster.local:4317"
```

## Wrap up

At the time writing this the documentation just tells you to add

```python
FastAPIInstrumentor.instrument_app(app)
```

to your code and you're done. That you have to add your exporter is no part of the documentation and I spend a good day until I found out about it through various blogposts and examples.

Hopefully I can improve the official documentation as well, so you don't even have to read this blogpost ;-)
