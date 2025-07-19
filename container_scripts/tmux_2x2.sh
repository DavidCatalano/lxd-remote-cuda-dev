#!/usr/bin/env bash
# Script assumes windows start at 1 (not default: 0)
# TODO: make this script generic (currently hardcoded for s2s-pipeline and imperfekt-ai directories)
SESSION_NAME="dev-2x2"
tmux kill-session -t "$SESSION_NAME" 2>/dev/null
tmux new-session  -d -s "$SESSION_NAME" -c ~/s2s-pipeline -n main
tmux split-window -h -c ~/s2s-pipeline -t "$SESSION_NAME":main
tmux select-pane  -t "$SESSION_NAME":main.1
tmux split-window -v -c ~/imperfekt-ai -t "$SESSION_NAME":main.1
tmux select-pane  -t "$SESSION_NAME":main.3
tmux split-window -v -c ~/imperfekt-ai -t "$SESSION_NAME":main.3
tmux select-pane  -t "$SESSION_NAME":main.1 -T "s2s-cli"
tmux select-pane  -t "$SESSION_NAME":main.3 -T "s2s-serve"
tmux select-pane  -t "$SESSION_NAME":main.2 -T "imperfekt-cli"
tmux select-pane  -t "$SESSION_NAME":main.4 -T "imperfekt-serve"
tmux select-layout -t "$SESSION_NAME":main tiled
tmux select-pane  -t "$SESSION_NAME":main.1
tmux attach-session -t "$SESSION_NAME"