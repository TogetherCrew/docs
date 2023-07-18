# tc-architecture

## requirements

- docker

## getting started

You can now start Structurizr Lite with the following commands, replacing PATH with the path to your Structurizr data directory:

### general

```
cd docs
docker pull structurizr/lite
docker run -it --rm -p 8080:8080 -v ./:/usr/local/structurizr structurizr/lite
```

### custom path
```
docker pull structurizr/lite
docker run -it --rm -p 8080:8080 -v PATH:/usr/local/structurizr structurizr/lite
```

For example, if your Structurizr data directory is located at /Users/simon/structurizr, the command would be:

```
docker pull structurizr/lite
docker run -it --rm -p 8080:8080 -v /Users/simon/structurizr:/usr/local/structurizr structurizr/lite
```

With Structurizr Lite running, you can head to http://localhost:8080 in your web browser, where you should see the diagram editor.