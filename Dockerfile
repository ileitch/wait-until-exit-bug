FROM swift:6.0
WORKDIR /workspace
COPY . /workspace
RUN swift build
ENTRYPOINT [".build/debug/WaitUntilExitBug"]
