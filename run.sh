#!/bin/bash

fswatch -l 1 lib --event=Updated -o | mix test --stale --listen-on-stdin
