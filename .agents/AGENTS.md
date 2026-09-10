# UniBoot Workspace Rules

- **Atomic Execution & Commit Policy**: Perform changes atomically (one logical task/fix per unit of work) and create atomic local git commits (`git commit`) immediately after completing each logical change.
- **Git Push Policy**: Do NOT automatically push commits to remote git repositories (`git push`). Only commit locally, and wait for explicit user request or batch pushes to avoid wasting CI/CD action resources.
- **Shell Script Quality & Verification Policy**: Every edit to shell scripts (*.sh) MUST be immediately verified using static syntax analysis (`bash -n <script>`). Use standard `[[ ... ]]` conditionals, double-quote all variable references, and ensure clean newline termination at EOF.
